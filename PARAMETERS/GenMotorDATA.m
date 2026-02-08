clear all

%% 5Phase PMSM Lille %%
% Electrical parameters
Type = 'PMSM 5Ph';
Index = 1; % To activate this subsytem in SIMULINK
Phase = 5;
P=7;
Rs=0.09+0.16; % 0.09 machine resistance - 0.16 conection resistance

Ld = 0.0006; % [H]
Lq = 0.0006; % [H]
Lx = 0.0004; % [H]
Ly = 0.0004; % [H]
Lh = 0.0003; % [H]

Lambda = 0.0138; % [Wb]  Flujo de magnetización del rotor (imanes / ind-Ldm.If)
kfem=0.0965;

kfem3=kfem*0.08*1;
Lambda3 = kfem3/P;

kfem5=kfem*0.08*1;
Lambda5 = kfem5/P;

RatedCurr = 70; % [A]

% Clarke transformation 
ang = 2*pi/5;
Clarke=(2/5)*...
   [1	       cos(ang)	    cos(2*ang)	cos(3*ang)	cos(4*ang)  ;
    0 		   sin(ang)	    sin(2*ang)	sin(3*ang)	sin(4*ang)  ;
    1	       cos(3*ang)	cos(6*ang)  cos(9*ang)	cos(12*ang) ;
    0  		   sin(3*ang)	sin(6*ang)	sin(9*ang)	sin(12*ang) ;
    1/(2)      1/(2)        1/(2)       1/(2)       1/(2)]	 ;
invClarke = inv(Clarke);

% Mechanical parameters
B = 0.0242;   % Friction coefficient
J = 0.0052;   % Inertia

clear ang
save('PARAMETERS/Lille5Ph.mat')
clear all

%% 7Phase SM Lille %%
% Electrical parameters
Index = 3; % To activate this subsytem in SIMULINK
Phase = 7;
P  = 7;
RatedCurr = 100;

Rs = 0.1;
Ld = 0.0014;
Lq = 0.0014;
Lx1 = 0.0009;
Ly1 = 0.0009;
Lx2 = 0.0009;
Ly2 = 0.0009;
Lh  = 0.0007;

Lambda = 0.01;
Lambda2 = 0.001;
Lambda3 = 0;
Lambda4 = 0;

% MECHANICAL
J = 0.005;  % [kg*m2] Mechanic inertia
B = 0.0001;   % [Nms]   Mechanical damping

% CLARKE SIMETRICA
vph = 2*pi/Phase;
h1 = 2;
h2 = 3;
Clarke = 2/Phase* ...
  [cos(vph)    cos(2*vph)    cos(3*vph)    cos(4*vph)    cos(5*vph)    cos(6*vph)    cos(7*vph) 
   sin(vph)    sin(2*vph)    sin(3*vph)    sin(4*vph)    sin(5*vph)    sin(6*vph)    sin(7*vph) 
   cos(h1*vph) cos(2*h1*vph) cos(3*h1*vph) cos(4*h1*vph) cos(5*h1*vph) cos(6*h1*vph) cos(7*h1*vph) 
   sin(h1*vph) sin(2*h1*vph) sin(3*h1*vph) sin(4*h1*vph) sin(5*h1*vph) sin(6*h1*vph) sin(7*h1*vph)
   cos(h2*vph) cos(2*h2*vph) cos(3*h2*vph) cos(4*h2*vph) cos(5*h2*vph) cos(6*h2*vph) cos(7*h2*vph) 
   sin(h2*vph) sin(2*h2*vph) sin(3*h2*vph) sin(4*h2*vph) sin(5*h2*vph) sin(6*h2*vph) sin(7*h2*vph) 
   1/2         1/2           1/2           1/2           1/2           1/2           1/2          ]; 
invClarke = inv(Clarke);

hp1 = 5;
hp2 = 3;

clear vph
save('PARAMETERS/Lille7Ph.mat')
clear all

%% 9Phase PMSM Málaga %%
% Electrical parameters

Type = 'PMSM 9Ph';           % Electric machine type (by default: PMSM)
Index = 2; % To activate this subsytem in SIMULINK
Phase = 9;           % Phases number (by default: 9)
P = 3;             % Pair pole number (by default: 3)
RatedPower = 15;   % [kW]  Nominal power (por defecto: 15 kW)
RatedSpeed = 1000; % [rpm] Nominal speed (por defecto: 1000 rpm)
RatedCurr = 14;    % [A]   Nominal current RMS (por defecto: 10 A)
RatedVolt = 230;   % [V]   Nominal voltage RMS (por defecto: 230 V)
Rs = 1;            % [ohm] Stator resistance
Ld = 0.0264;       % [H]   Inductance Ld
Lq = 0.0564;       % [H]   Inductance Lq (old = 0.0711)
Lx1 = 0.0104;      % [H]   Inductance Lxy1
Ly1 = 0.0078;      % [H]   Inductance Lxy1
Lx2 = 0.0032;      % [H]   Inductance Lxy2
Ly2 = 0.0029;      % [H]   Inductance Lxy2
Lambda = 0.93;     % [Wb]  Fundamental Flux (old = 0.85)
Lambda2 = 0;       % [Wb]  Second harm. Flux
Lambda3 = 0;       % [Wb]  Third harm. Flux 

% MECHANICAL
J = 0.005;  % [kg*m2] Mechanic inertia
B = 0.0001;   % [Nms]   Mechanical damping

% CLARKE SIMÉTRICA
k = 2/9; % Para mantener invariantes corrientes, tensiones y flujos
vph = 2*pi/9 *[0 6 3   1 7 4   2 8 5];
h1 = 2;
h2 = 4;
Clarke = k * [cos(vph(1))       cos(vph(2))       cos(vph(3))       cos(vph(4))       cos(vph(5))       cos(vph(6))       cos(vph(7))       cos(vph(8))       cos(vph(9))
                  sin(vph(1))       sin(vph(2))       sin(vph(3))       sin(vph(4))       sin(vph(5))       sin(vph(6))       sin(vph(7))       sin(vph(8))       sin(vph(9))
                  cos(h1*vph(1)) cos(h1*vph(2)) cos(h1*vph(3)) cos(h1*vph(4)) cos(h1*vph(5)) cos(h1*vph(6)) cos(h1*vph(7)) cos(h1*vph(8)) cos(h1*vph(9))
                  sin(h1*vph(1)) sin(h1*vph(2)) sin(h1*vph(3)) sin(h1*vph(4)) sin(h1*vph(5)) sin(h1*vph(6)) sin(h1*vph(7)) sin(h1*vph(8)) sin(h1*vph(9))
                  cos(h2*vph(1)) cos(h2*vph(2)) cos(h2*vph(3)) cos(h2*vph(4)) cos(h2*vph(5)) cos(h2*vph(6)) cos(h2*vph(7)) cos(h2*vph(8)) cos(h2*vph(9))
                  sin(h2*vph(1)) sin(h2*vph(2)) sin(h2*vph(3)) sin(h2*vph(4)) sin(h2*vph(5)) sin(h2*vph(6)) sin(h2*vph(7)) sin(h2*vph(8)) sin(h2*vph(9))
                  9/6            9/6            9/6             0              0              0              0              0              0   % no estoy seguro si es 1 o 9/6       
                   0              0              0             9/6            9/6            9/6             0              0              0          
                   0              0              0              0              0              0             9/6            9/6            9/6          ]; 
% % CLARKE ASIMETRICA
% theta = pi/9;
% obj.Clarke = 2/9*[    1     cos(6*theta)   cos(12*theta)    cos(theta)   cos(7*theta)  cos(13*theta)  cos(2*theta) cos(8*theta)   cos(14*theta); 
%               0     sin(6*theta)   sin(12*theta)    sin(theta)   sin(7*theta)  sin(13*theta)  sin(2*theta) sin(8*theta)   sin(14*theta);
%               1     cos(30*theta)  cos(60*theta)  cos(5*theta)  cos(35*theta)  cos(65*theta) cos(10*theta) cos(40*theta)  cos(70*theta); 
%               0     sin(30*theta)  sin(60*theta)  sin(5*theta)  sin(35*theta)  sin(65*theta) sin(10*theta) sin(40*theta)  sin(70*theta); 
%               1     cos(42*theta)  cos(84*theta)  cos(7*theta)  cos(49*theta)  cos(91*theta) cos(14*theta) cos(56*theta)  cos(98*theta); 
%               0     sin(42*theta)  sin(84*theta)  sin(7*theta)  sin(49*theta)  sin(91*theta) sin(14*theta) sin(56*theta)  sin(98*theta);
%              1/3        1/3          1/3            0             0            0             0             0              0    ;
%               0         0            0            1/3           1/3          1/3            0             0              0    ;
%               0         0            0             0             0            0            1/3           1/3            1/3   ;];

invClarke = inv(Clarke);

hp1 = 1;
hp2 = 1;

clear vph
save('PARAMETERS/Malaga9Ph.mat')
clear all


%% 5Phase IM Málaga %%
Index = 4; % To activate this subsytem in SIMULINK
Phase = 5;           % Phases number 



save('PARAMETERS/Malaga5Ph.mat')
clear all