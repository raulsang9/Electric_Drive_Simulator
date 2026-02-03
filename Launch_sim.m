%% ELECTRIC DRIVE SIMULATOR
clear all; close all; clc;

% Configuration SetUp
CtrlSchem = 'MPC';      % [MPC, MPCVV, FOCcb, FOCsv]
Machine   = 'Lille5Ph'; % [Lille5Ph, Lille7Ph, Malaga5Ph, Malaga9Ph]
Topology  = 'OW';       % [SC:star-connected, OW, SEW]

% Test Setup
speed = 500; % [rpm] Mechanical speed reference
Tload = 4; % [Nm] Torque load

CtrlFreq = 10e3; % [Hz] Control Frequency
tsim     = 1;    % [s] Simulation time

load("private\COLORPALETTE_ENSAM.mat")