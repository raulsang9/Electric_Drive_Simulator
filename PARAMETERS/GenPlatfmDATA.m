clear all

%%% 5Phase PMSM Lille %%%
% Electrical parameters
MOTOR.Label = 'Lille5Ph';
MOTOR.P=7;
MOTOR.Rs=0.09+0.16; % 0.09 machine resistance - 0.16 conection resistance

MOTOR.Ld = 0.0006; % [H]
MOTOR.Lq = 0.0006; % [H]
MOTOR.Lx = 0.0004; % [H]
MOTOR.Ly = 0.0004; % [H]
MOTOR.Lh = 0.0003; % [H]

MOTOR.In = 55; % [A]

% Clarke transformation 
ang = 2*pi/5;
MOTOR.Clarke=(2/5)*...
   [1	       cos(ang)	    cos(2*ang)	cos(3*ang)	cos(4*ang)  ;
    0 		   sin(ang)	    sin(2*ang)	sin(3*ang)	sin(4*ang)  ;
    1	       cos(3*ang)	cos(6*ang)  cos(9*ang)	cos(12*ang) ;
    0  		   sin(3*ang)	sin(6*ang)	sin(9*ang)	sin(12*ang) ;
    1/(2)      1/(2)        1/(2)       1/(2)       1/(2)]	 ;
MOTOR.invClarke = inv(MOTOR.Clarke);

% Mechanical parameters
MOTOR.B = 0.0242;   % Friction coefficient
MOTOR.J=0.0052;    % Inertia

clear ang
save('PARAMETERS/Lille5Ph.mat')