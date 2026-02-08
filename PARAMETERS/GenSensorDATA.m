clear all; close all; clc;

%% 5Phase Lille Test Bench %%
% Electrical parameters

Inom = 125;
error = 0.8; % [%] Tolerance
sigma = error*Inom/100; % [A] Desviación típica

save('PARAMETERS\LEM_LA_125_P.mat');
clear all

