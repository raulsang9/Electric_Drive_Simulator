%% ELECTRIC DRIVE SIMULATOR
clear all; close all; clc;

% Configuration SetUp
CtrlSchem = 'MPC';      % [MPC, MPCVV, FOCcb, FOCsv]
Machine   = 'Lille5Ph'; % [Lille5Ph, Lille7Ph, Malaga5Ph, Malaga9Ph]
Topology  = 'OW';       % [SC:star-connected, OW, SEW]

% Test Setup
speed = 500; % [rpm] Mechanical speed reference
Tload = 4;   % [Nm] Torque load
Vdc   = 30;  % [V] DC supply

CtrlFreq = 20e3; % [Hz] Control Frequency
tsim     = 0.2;  % [s] Simulation time

[MOTOR, CONTROL, VSC] = load_parameter(Machine, Topology, CtrlSchem, CtrlFreq, Vdc);

% Simulation
DEC = 10; % Decimation data logging
tic; sim("SIMULATOR/ELECTRIC_DRIVE.slx"); elapsed = toc; disp(['Simulation time: ', num2str(elapsed), ' s' ])

file = [Machine,'_',Topology,'_',CtrlSchem,'_',num2str(Vdc),'Vdc_',num2str(CtrlFreq/1000),'kHz_',num2str(speed),'rpm_',num2str(Tload),'Nm']


%%
% figure; hold on;
% plot(timeL,Iphase)
% 
% 
% figure; hold on;
% plot(timeL,Idq(:,1:2))
% plot(timeL,Idq_ref(:,1:2),'-')
