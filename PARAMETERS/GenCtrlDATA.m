clear all; close all; clc;
%% MPC Single-vector OW 5Ph

% Factores de peso del MPC
Kd = 1;    % []    Peso del error en d de la funcion de coste
Kx = 0.4;  % []    Peso del error en x de la funcion de coste
Ky = 0.4;  % []    Peso del error en y de la funcion de coste
Kh = 1.6;  % []    Peso del error en homopolar de la funcion de coste

load("PARAMETERS\Lille5Ph.mat")
%----- STATE SPACE -----% no coupling without reluctance effect
A=[-Rs/Ld   0       0      0      0
    0    -Rs/Lq     0      0      0
    0       0    -Rs/Lx    0      0
    0       0       0    -Rs/Ly   0
    0       0       0      0   -Rs/Lh];
% Ap=[ 0 -((Ld-Lq)*we)/Ld 0  0  0
% ((Ld-Lq)*we)/Lq    0    0  0  0
%     0              0    0  0  0
%     0              0    0  0  0
%     0              0    0  0  0];

B=[ 1/Ld   0       0       0    0
    0   1/Lq       0       0    0
    0      0    1/Lx       0    0
    0      0       0    1/Ly    0
    0      0       0       0  1/Lh];

E= -1*[kfem 
      -kfem 
      -kfem3
       kfem3
       kfem5];
% E=-wm*[kfem *sin(th)
%       -kfem *cos(th)
%       -kfem3*sin(3*th)
%        kfem3*cos(3*th)
%        kfem5*sin(5*th)];

    % E=[ (we*lambda*sin(th))/Lq 
    %    -(we*lambda*cos(th))/Lq  
    %     (we*3*lambda3*sin(3*th))/Ly 
    %    -(we*3*lambda3*cos(3*th))/Ly 
    %    -(we*5*lambda5)/Lh ];

save('PARAMETERS\MPC_Lille5ph')
clear all