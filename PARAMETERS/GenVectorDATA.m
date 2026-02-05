clear all; close all; clc;
%% Single-vectors MPC OW 5Ph

MOTOR = load("PARAMETERS\Lille5Ph.mat");
VSC   = load("PARAMETERS\VSCow5ph.mat");

n = 2*MOTOR.Phase;
total_combinations = 2^n; % Total de combinaciones posibles
S = zeros(total_combinations, n); % Matriz para almacenar todas las combinaciones

% Switching states
for i = 0:total_combinations-1
    % Convertir el número a binario y almacenarlo en la matriz
    S(i+1, :) = bitget(i, n:-1:1);
end

% Phase voltage
V_abcde = zeros(MOTOR.Phase, length(S));
VSC.Vdc = 1;
for i = 1:length(S)
    V_abcde(:,i) = VSC.Vdc .* VSC.K * S(i,:)';
end

% Alpha-Beta voltage
V_abxy = zeros(MOTOR.Phase,length(S));
for i = 1:length(S)
    V_abxy(:,i) = MOTOR.Clarke * V_abcde(:,i);
end
clear n total_combinations i

S = S';

clear MOTOR VSC

save('PARAMETERS\VECTow5ph.mat');