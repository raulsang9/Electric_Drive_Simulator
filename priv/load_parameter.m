function [MOTOR, CONTROL, VSC] = load_parameter(Machine, Topology, CtrlSchem, CtrlFreq, Vdc)
%LOAD_PARAMETER Summary of this function goes here
%   Detailed explanation goes here

if strcmp(Machine,'Lille5Ph')
    MOTOR = load('Lille5Ph.mat');
elseif strcmp(Machine,'Lille7Ph')
    MOTOR = load('Lille7Ph.mat');
elseif strcmp(Machine,'Malaga9Ph')
    MOTOR = load('Malaga9Ph.mat');
end


if strcmp(Topology,'SC') && strcmp(Machine,'Malaga9Ph')
    VSC = load('VSCsc9ph.mat');
elseif strcmp(Topology,'OW') && strcmp(Machine,'Lille5Ph')
    VSC = load('VSCow5ph.mat');
% elseif strcmp(Topology,'SEW')
%     load('Malaga9Ph.mat');
end

VSC.Vdc = Vdc;

CONTROL.Fctrl = CtrlFreq;   % Control frecuency
CONTROL.Ts = 1/CtrlFreq;    % Control period
CONTROL.Tm = CONTROL.Ts/100;% Calculation step period
CONTROL.N_calc = round(CONTROL.Ts/CONTROL.Tm);% Calculation step into a control period 


end

