clear all; close all; clc;

%% Star-connected
% 9Phase
Type = 'SC 2-Level 9Ph';
C_link = 2000e-6;    % Capacidad del condensador del bus de continua
NumPhase = 9;      % Número de fases del accionamiento (por defecto: 9)
NunLev = 2;        % Número de niveles de tensión (por defecto: 2)
DeadTime = 0.6e-6; % Tiempos muertos del driver (por defecto: 0.6 µs)
td  = 1e-6;        % Tiempo de subida/bajada en la respuesta (por defecto: 1 µs)
SwLoss = 0.5;      % Pérdidas por conmutación (por defecto: 0.5 J/conm)
K = 1/3*[ 2 -1 -1  0  0  0  0  0  0 
         -1  2 -1  0  0  0  0  0  0
         -1 -1  2  0  0  0  0  0  0
          0  0  0  2 -1 -1  0  0  0
          0  0  0 -1  2 -1  0  0  0
          0  0  0 -1 -1  2  0  0  0
          0  0  0  0  0  0  2 -1 -1  
          0  0  0  0  0  0 -1  2 -1  
          0  0  0  0  0  0 -1 -1  2 ]; % Matriz vi=vdc·K·[Si]
save('PARAMETERS\VSCsc9ph')
clear all

%% Open-end Winding
% 5 Phase

Type = 'OW 2-Level 5Ph';
C_link = 2000e-6;    % Capacidad del condensador del bus de continua
NumPhase = 5;      % Número de fases del accionamiento (por defecto: 9)
NunLev = 2;        % Número de niveles de tensión (por defecto: 2)
DeadTime = 6e-6;   % Tiempos muertos del driver (por defecto: 0.6 µs)
SwLoss = 0.5;      % Pérdidas por conmutación (por defecto: 0.5 J/conm)
K = [1  0  0  0  0 -1  0  0  0  0 
     0  1  0  0  0  0 -1  0  0  0
     0  0  1  0  0  0  0 -1  0  0
     0  0  0  1  0  0  0  0 -1  0
     0  0  0  0  1  0  0  0  0 -1]; % Matriz vaa'=vdc·K·[Si] % Matriz vi=vdc·K·[Si]
save('PARAMETERS\VSCow5ph')
clear all

