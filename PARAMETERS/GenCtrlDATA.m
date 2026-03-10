clear all; close all; clc;
%% MPC Single-vector OW 5Ph
Index = 1;
Phase = 5;
% Factores de peso del MPC
Kd = 1;    % []    Peso del error en d de la funcion de coste
Kx = 0.3;  % []    Peso del error en x de la funcion de coste
Ky = 0.3;  % []    Peso del error en y de la funcion de coste
Kh = 0.4;  % []    Peso del error en homopolar de la funcion de coste

Parm = load("PARAMETERS\Lille5Ph.mat"); Clarke = Parm.Clarke;invClarke = Parm.invClarke;
P  = Parm.P;
In = Parm.RatedCurr;
Rs = Parm.Rs;
Ld = Parm.Ld;
Lq = Parm.Lq;
Lx = Parm.Lx;
Ly = Parm.Ly;
Lh = Parm.Lh;
Lambda = Parm.Lambda;
Lambda3 = Parm.Lambda3;
Lambda5 = Parm.Lambda5;
kfem = Parm.Lambda * Parm.P;
kfem3 = Parm.Lambda3 * Parm.P;
kfem5 = Parm.Lambda5 * Parm.P;
%----- STATE SPACE -----% no coupling without reluctance effect
A=[-Rs/Ld   0       0      0      0    % Ap=[ 0 -((Ld-Lq)*we)/Ld 0  0  0
    0    -Rs/Lq     0      0      0    % ((Ld-Lq)*we)/Lq    0    0  0  0
    0       0    -Rs/Lx    0      0    %     0              0    0  0  0
    0       0       0    -Rs/Ly   0    %     0              0    0  0  0
    0       0       0      0   -Rs/Lh];%     0              0    0  0  0];

B=[ 1/Ld   0       0       0    0
    0   1/Lq       0       0    0
    0      0    1/Lx       0    0
    0      0       0    1/Ly    0
    0      0       0       0  1/Lh];

E= -1*[Lambda   % E=-wm*[kfem *sin(th)
      -Lambda   %       -kfem *cos(th)
      -Lambda3  %       -kfem3*sin(3*th)
       Lambda3  %        kfem3*cos(3*th)
       Lambda5];%        kfem5*sin(5*th)];

clear Parm
save('PARAMETERS\MPC_Lille5ph')
% clear all


%% Vf OW 5Ph
Index = 5;
Phase = 5;
% Valores Nominales
wm_n = 50; % [rad/s]

save('PARAMETERS\Vf_5ph')
% clear all

%% MPC 9Ph PMSM
Index = 11;
Phase = 9;
% Factores de peso del MPC
Kd   = 1;       % []    Peso del error en xy de la funcion de coste
Kxy1 = 0.06;%0.09;       % []    Peso del error en xy de la funcion de coste
Kxy2 = 0.04;%0.06;     % []    Peso del error en xy2

%----- STATE SPACE -----% no coupling without reluctance effect
A=[ -Rs/Ld   0     0      0      0       0;
       0  -Rs/Lq   0      0      0       0;
       0     0  -Rs/Lx1   0      0       0;
       0     0     0   -Rs/Ly1   0       0;
       0     0     0      0   -Rs/Lx2    0;
       0     0     0      0      0    -Rs/Ly2;];

B=[1/Ld   0       0       0       0       0;
    0  1/Lq       0       0       0       0;
    0     0   1/Lx1       0       0       0;
    0     0       0   1/Ly1       0       0;
    0     0       0       0   1/Lx2       0;
    0     0       0       0       0   1/Ly2;];

%% FOC 9Ph PMSM
Index = 12;
Phase = 9;
% PI id
Kp_id = 390;   % PI speed Proportional constant
Ki_id = 200;    % PI speed Integral constant
% PI iq
Kp_iq = 290;   % PI speed Proportional constant
Ki_iq = 120;     % PI speed Integral constant
% PI ix1
Kp_ix1 = 38;   % PI speed Proportional constant
Ki_ix1 = 4;    % PI speed Integral constant
% PI iy1
Kp_iy1 = 38;   % PI speed Proportional constant
Ki_iy1 = 4;    % PI speed Integral constant
% PI ix2
Kp_ix2 = 20;   % PI speed Proportional constant
Ki_ix2 = 2;    % PI speed Integral constant
% PI iy2
Kp_iy2 = 20;   % PI speed Proportional constant
Ki_iy2 = 2;    % PI speed Integral constant

% Voltages Saturations
Vd_max = 100; % [V]
Vq_max = 480; % [V]
Vxy_max=  10; % [V]

