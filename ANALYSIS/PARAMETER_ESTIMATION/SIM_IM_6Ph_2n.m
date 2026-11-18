function [Iab, Psir, Te] = SIM_IM_6Ph_2n(I0, Psir0, Uab, wm, Rs, Rr, Lls, Llr, Lm, Lx, Ly, P, Ts, method)
%   SIM_IM_6Ph_2n
%   Offline simulation of the state space model of an asymmetrical 6Ph IM
%   (dual three-phase, 30 deg shift) with 2 isolated neutrals.
%
%   VSD subspaces, Clarke: [a1 b1 c1 a2 b2 c2]' -> [al be x y z1 z2]'
%     alpha-beta : harmonics 12k+-1. Electromechanical conversion, the only
%                  subspace coupled to the rotor cage -> Ls, Lr, Lm, Rr.
%     x-y        : harmonics 12k+-5. NO rotor coupling (the cage is transparent
%                  to it) -> limited only by Rs and the stator leakage. This is
%                  the key difference with the 5Ph PMSM model.
%     z1-z2      : harmonics 3k. Identically zero with two isolated neutrals,
%                  therefore not simulated.
%
%   The alpha-beta model is written in the stationary frame with states
%   [i_al i_be psir_al psir_be]', which keeps the cage flux explicit:
%     v_s   = Rs*i_s + d(psis)/dt            psis = Ls*i_s + Lm*i_r
%     0     = Rr*i_r + d(psir)/dt - j*wr*psir  psir = Lr*i_r + Lm*i_s
%
%   Input  -> I0    : Initial stator current [4x1]  (free-running simulation)
%                     or measured currents   [4xN]  (one-step-ahead, k -> k+1)
%          -> Psir0 : Initial rotor flux     [2x1]  ([] -> zeros)
%          -> Uab   : Voltage state          [4xN] or [6xN] (z1-z2 ignored)
%          -> wm    : Mechanical speed       [1xN] or [1] (rad/s)
%          -> Rs    : Stator resistance      [1]
%          -> Rr    : Rotor resistance       [1]
%          -> Lls   : Stator leakage induct. [1]
%          -> Llr   : Rotor leakage induct.  [1]
%          -> Lm    : Magnetizing inductance [1]
%          -> Lx    : X leakage inductance   [1] ([] -> Lls)
%          -> Ly    : Y leakage inductance   [1] ([] -> Lls)
%          -> P     : Pole pairs             [1]
%          -> Ts    : Sample time            [1]
%          -> method: 'euler' (default) | 'exact'   Discretisation
%
%   Output -> Iab  : Stator currents [al be x y]' [4xN]
%          -> Psir : Rotor flux      [al be]'     [2xN]
%          -> Te   : Electromagnetic torque       [1xN] (Nm)
%

if nargin < 14 || isempty(method), method = 'euler'; end
if nargin < 11 || isempty(Lx), Lx = Lls; end
if nargin < 12 || isempty(Ly), Ly = Lls; end
if isempty(Psir0), Psir0 = zeros(2,1); end

N = size(Uab,2);
Iab  = zeros(4,N);
Psir = zeros(2,N);

% Electrical rotor speed
if isscalar(wm), wm = wm*ones(1,N); end
wr = P*wm;

% [4xN] initial condition -> one-step-ahead prediction from the measurement
oneStep = size(I0,2) > 1;

%----- MACHINE CONSTANTS -----%
Ls  = Lls + Lm;             % (H)   Stator self inductance
Lr  = Llr + Lm;             % (H)   Rotor self inductance
sg  = 1 - Lm^2/(Ls*Lr);     % (-)   Total leakage factor
Tr  = Lr/Rr;                % (s)   Rotor time constant
sLs = sg*Ls;                % (H)   Transient (short-circuit) inductance
Rsg = Rs + Lm^2*Rr/Lr^2;    % (Ohm) Equivalent transient resistance

%----- STATE SPACE: x-y -----%
% No rotor coupling: two independent R-L circuits, LTI -> discretised once
Axy = [-Rs/Lx    0
          0   -Rs/Ly];
Bxy = [ 1/Lx     0
          0    1/Ly];
[FIxy, GAxy] = discretise(Axy, Bxy, Ts, method);

% El plano x-y es el que primero se desestabiliza con Euler: su constante de
% tiempo es Lx/Rs, mucho mas rapida que la del plano alpha-beta. Con Ts
% grande (p.ej. 320 us de data-logger) y Lls pequena, Rs*Ts/Lx supera 2 y la
% simulacion diverge sin avisar. Mas vale pararlo aqui.
if strcmpi(method,'euler') && max(Rs*Ts/Lx, Rs*Ts/Ly) >= 2
    error('SIM_IM_6Ph_2n:unstable', ...
        ['Euler inestable en el plano x-y: Rs*Ts/L = %.2f (limite 2).\n' ...
         'Usa method = ''exact'' o reduce Ts.'], max(Rs*Ts/Lx, Rs*Ts/Ly));
end

%----- STATE SPACE: alpha-beta -----%
Bab = [1/sLs    0
          0  1/sLs
          0     0
          0     0];
% A depends on wr -> rebuilt only when the speed changes
wrk  = NaN;
FIab = [];
GAab = [];


%%%-----------------------  OFFLINE SIMULATION    ----------------------%%%
% Initial condition
Iab(:,1)  = I0(:,1);
Psir(:,1) = Psir0;
% Simulation loop
for k = 1:N-1

    %----- SPEED DEPENDENT MATRICES -----%
    if wr(1,k) ~= wrk
        Aab = [-Rsg/sLs          0            Lm*Rr/(Lr^2*sLs)   Lm*wr(1,k)/(Lr*sLs)
                   0         -Rsg/sLs       -Lm*wr(1,k)/(Lr*sLs)  Lm*Rr/(Lr^2*sLs)
                 Lm/Tr            0               -1/Tr               -wr(1,k)
                   0           Lm/Tr              wr(1,k)              -1/Tr     ];
        [FIab, GAab] = discretise(Aab, Bab, Ts, method);
        wrk = wr(1,k);
    end

    %----- PREDICTION k+1 -----%
    % The cage flux is never measured: it is always propagated open-loop
    if oneStep, ik = I0(:,k); else, ik = Iab(:,k); end

    xk   = [ik(1:2); Psir(:,k)];
    xkp1 = FIab*xk + GAab*Uab(1:2,k);

    ixykp1 = FIxy*ik(3:4) + GAxy*Uab(3:4,k);

    % Update current and flux states
    Iab(:,k+1)  = [xkp1(1:2); ixykp1];
    Psir(:,k+1) = xkp1(3:4);
end

%----- ELECTROMAGNETIC TORQUE -----%
% Amplitude-invariant Clarke (kc = 2/n) -> power scaling n/2 = 3
Te = 3*P*(Lm/Lr)*(Psir(1,:).*Iab(2,:) - Psir(2,:).*Iab(1,:));

end


function [FI, GA] = discretise(A, B, Ts, method)
%   Discrete equivalent of dx/dt = A*x + B*u  ->  x(k+1) = FI*x(k) + GA*u(k)
switch lower(method)
    case 'euler'    % Forward Euler, as implemented in the DSP
        FI = eye(size(A)) + A*Ts;
        GA = B*Ts;
    case 'exact'    % Zero-order hold, valid for any Ts
        n = size(A,1);
        m = size(B,2);
        M  = expm([A B; zeros(m,n+m)]*Ts);
        FI = M(1:n,1:n);
        GA = M(1:n,n+1:n+m);
    otherwise
        error('SIM_IM_6Ph_2n:method','Unknown discretisation method ''%s''.',method);
end
end
