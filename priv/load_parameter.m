function [MOTOR, CONTROL, VSC, SENSOR] = load_parameter(Machine, Topology, CtrlSchem, CtrlFreq, Vdc)
%LOAD_PARAMETER Summary of this function goes here
%   Detailed explanation goes here

%%%--------- MACHINE ---------%%%
if strcmp(Machine,'Lille5Ph')
    MOTOR = load('Lille5Ph.mat');
elseif strcmp(Machine,'Lille7Ph')
    MOTOR = load('Lille7Ph.mat');
elseif strcmp(Machine,'Malaga9Ph')
    MOTOR = load('Malaga9Ph.mat');
end

%%%---------   VSC   ---------%%%
if strcmp(Topology,'SC') && strcmp(Machine,'Malaga9Ph')
    VSC = load('VSCsc9ph.mat');
elseif strcmp(Topology,'OW') && strcmp(Machine,'Lille5Ph')
    VSC = load('VSCow5ph.mat');
% elseif strcmp(Topology,'SEW')
%     load('Malaga9Ph.mat');
end
VSC.Vdc = Vdc;


%%%--------- CONTROL ---------%%%
if strcmp(CtrlSchem,'MPC')
    if strcmp(Machine,'Lille5Ph')
        CONTROL = load('MPC_Lille5ph.mat');
        CONTROL.VECT = load('VECTow5ph.mat');
    elseif strcmp(Machine,'Lille7Ph')
        CONTROL = load('MPC_Lille7Ph.mat');
    elseif strcmp(Machine,'Malaga9Ph')
        CONTROL = load('MPC_Malaga9Ph.mat');
    end

elseif strcmp(CtrlSchem,'MPCVV')    
    if strcmp(Machine,'Lille5Ph')
        CONTROL = load('MPCvv_Lille5ph.mat');
    elseif strcmp(Machine,'Lille7Ph')
        CONTROL = load('MPCvv_Lille7Ph.mat');
    elseif strcmp(Machine,'Malaga9Ph')
        CONTROL = load('MPCvv_Malaga9Ph.mat');
    end
elseif strcmp(CtrlSchem,'FOC')
    CONTROL = load('FOC.mat');
end

CONTROL.Vdc = Vdc;
CONTROL.Ts = 1/CtrlFreq;    % Control period
CONTROL.Tm = CONTROL.Ts/100;% Calculation step period
CONTROL.N_calc = round(CONTROL.Ts/CONTROL.Tm);% Calculation step into a control period 

% Constantes del controlador PI de velocidad
CONTROL.VEL.Kp   = 8;   % [] Proporcional constant PI speed control (revisar unidades)
CONTROL.VEL.Ki   = 23;   % [] Integer constant PI speed control

%%%---------  SENSOR  ---------%%%
SENSOR.CURRENT = load('LEM_LA_125_P.mat');


CONTROL.KALMAN.R = SENSOR.CURRENT.sigma^2 * eye(5); % Matriz de confianza del sensor
CONTROL.KALMAN.Q = 1 * eye(5); % Matriz de confianza de la predicción


end

