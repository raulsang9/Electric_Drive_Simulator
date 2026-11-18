%%% Simulacion offline - IM hexafasica asimetrica (30 deg) con 2 neutros %%%
%
% Reconstruye las corrientes de la maquina con el modelo, a partir de la
% tension de referencia y la velocidad MEDIDAS en el ensayo, y las compara
% con las corrientes tambien medidas.
%
% Datos: volcado del DSP en .dat (ver LoadDAT_IM6Ph.m)
% Modelo: SIM_IM_6Ph_2n.m
%
% Para ajustar los parametros automaticamente usa Identify_IM6Ph_2n.m.

clear all; close all; clc


%------------------------------  CONFIG  ---------------------------------%
archivo = 'CB_700rpm_3kHz.dat';

Ts = 320e-6;    % (s) Periodo del data-logger. Viene de la temporizacion del
                % bucle principal: ConfigCpuTimer(&CpuTimer0,150,320) -> 320 us
                % con decimacion data_l == 1. Si el ensayo fuese a 3 kHz
                % exactos, poner 1/3000.
P  = 3;         % (-) Pares de polos
nd = 1;         % (muestras) Retardo de calculo tension-corriente. Lo
                % determina Identify_IM6Ph_2n.m barriendo nd; para este
                % ensayo el minimo esta claramente en 1.

met = 'exact';  % Discretizacion. OJO: con Ts = 320 us y Lls pequena, Euler
                % DIVERGE en el plano x-y (Rs*Ts/Lls = 3.0 > 2). Para este
                % ensayo 'exact' no es una opcion, es un requisito.

sav = 0;        % 1: guardar figuras


%------------------------------  DATALOAD  -------------------------------%
ens = LoadDAT_IM6Ph(archivo, Ts, P, nd);

Imed = ens.Iab;     % [4xN] corrientes medidas  [alpha beta x y]
Uab  = ens.Uab;     % [4xN] referencias de tension, ya desplazadas nd muestras
N    = ens.N;

fprintf('\n===== ENSAYO: %s =====\n', archivo);
fprintf('Muestras   : %d   Ts = %.1f us   duracion = %.4f s\n', N, Ts*1e6, N*Ts);
fprintf('Retardo    : %d muestras\n', nd);
fprintf('Velocidad  : %.2f rad/s = %.1f rpm\n', mean(ens.wm), mean(ens.wm)*60/(2*pi));
fprintf('f1         : %.3f Hz  ->  %.2f ciclos en la ventana\n', ens.f1, N*Ts*ens.f1);
fprintf('Deslizam.  : %.3f rad/s elec  (s = %.4f)\n', ens.wsl, ens.s);


%-------------------------  MOTOR PARAMETERS   ---------------------------%
% Valores ajustados sobre este ensayo con Identify_IM6Ph_2n.m; al lado, los
% preliminares de PARAMETERS/Malaga6PhIM.mat.
% OJO con Rr: no esta identificado. Sale de Lr/Tr con Tr FIJADO, porque la
% ventana solo cubre 0.41 constantes de tiempo rotoricas. Lls tampoco: esta
% puesto por convenio (no es separable desde bornes del plano alpha-beta).
Rs    = 10.9125;%14.2;         % (Ohm) Resistence of stator
Rr    = 2.0669;%2.04;         % (Ohm) Resistence of rotor
Lls   = 0.0015;%0.0015;       % (H) Leakage Inductance of the stator
Llr   = 0.07289;%0.05512;      % (H) Leakage Inductance of the rotor
Lm    = 0.40829;%0.4198;       % (H) Mutue Inductance Transformation
J     = 0.005;        % (Kg/m^2) Rotational Inertia of the rotor
Bm    = 0.00;         % (Nms/rad) Coefficient of friction
Ls    = Lls + Lm;     % (H)
Lr    = Llr + Lm;     % (H)
Kw    = 1;            % (-) Ratio between rotor and stator parameters

% Plano x-y: la jaula no interviene, pero la inductancia que se ve aqui NO
% es Lls. Medida sobre este ensayo en los armonicos 5 y 7 (los unicos donde
% la tension registrada explica la corriente): Rxy = 21.5 ohm, Lxy = 0.0447 H,
% es decir 30 veces Lls. Con Lls las corrientes simuladas de 5o y 7o salian
% 6-7 veces demasiado grandes.
Lx    = 0.04473;%Lls;  % (H) X inductance
Ly    = 0.04473;%Lls;  % (H) Y inductance

% Constantes derivadas (diagnostico del ajuste)
sg  = 1 - Lm^2/(Ls*Lr);  % (-) Factor de dispersion total
Tr  = Lr/Rr;             % (s) Constante de tiempo del rotor
sLs = sg*Ls;             % (H) Inductancia transitoria

fprintf('\nParametros: sigma = %.5f   Tr = %.5f s   sigma*Ls = %.6f H\n', sg, Tr, sLs);
fprintf('La ventana cubre %.2f constantes de tiempo rotoricas\n', N*Ts/Tr);


%------------------------  INITIAL ROTOR FLUX  ---------------------------%
% El flujo de jaula no se mide y el modelo lo propaga en lazo abierto, asi
% que un Psir(0) erroneo contamina toda la ventana (se extingue con Tr).
% Este registro no tiene tramo previo con el que converger un observador, de
% modo que se parte del valor analitico de regimen permanente: en ejes
% sincronos  psir = Lm*is/(1 + j*wsl*Tr).  El fasor de is se extrae por
% deteccion sincrona con el angulo thetae medido.
Psir0 = fluxSteadyState(Imed, ens.th, ens.wsl, Lm, Tr);
fprintf('Psir(0) de regimen permanente: [%+.4f %+.4f] Wb  (|.| = %.4f)\n', ...
        Psir0, norm(Psir0));


%--------------------------    SIMULATION    -----------------------------%
[sim.Iab, sim.Psir, sim.Te] = SIM_IM_6Ph_2n(Imed(:,1), Psir0, Uab, ens.wm, ...
    Rs, Rr, Lls, Llr, Lm, Lx, Ly, P, Ts, met);

sim.error = sim.Iab - Imed;
sim.rmse  = sqrt(mean(sim.error.^2, 2));

% Corrientes de fase reconstruidas (z1 = z2 = 0 con dos neutros aislados)
sim.Iph = ens.invClarke*[sim.Iab; zeros(2,N)];

% DISPLAY METRICS
fprintf('\n--- AJUSTE con los parametros preliminares ---\n');
fprintf('   RMSE    : %.4f, %.4f, %.4f, %.4f  [A]\n', sim.rmse);
fprintf('   RMSE a-b: %.4f A   (rms medido %.3f A  ->  %.1f %%)\n', ...
    mean(sim.rmse(1:2)), mean(sqrt(mean(Imed(1:2,:).^2,2))), ...
    100*mean(sim.rmse(1:2))/mean(sqrt(mean(Imed(1:2,:).^2,2))));
fprintf('   RMSE x-y: %.4f A   (rms medido %.3f A  ->  %.1f %%)\n', ...
    mean(sim.rmse(3:4)), mean(sqrt(mean(Imed(3:4,:).^2,2))), ...
    100*mean(sim.rmse(3:4))/mean(sqrt(mean(Imed(3:4,:).^2,2))));
fprintf('   Par medio estimado: %.3f Nm\n', mean(sim.Te));


%-------------------------  VISUALIZATION SETUP  -------------------------%
wi = 45; % Figs size
he = 7;

xli = [ens.t(1) ens.t(end)];

load('private\COLORPALETTE_ENSAM.mat');


%---------------------------   VISUALIZATION   ---------------------------%

% Alpha-beta currents: medida vs modelo
p1 = figure('Name','alpha-beta Currents','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0.2,19,wi,he]; figure(p1)
miax = axes; hold on
    plot(ens.t, Imed(1,:),'Color',orange,'LineWidth',1.8,'LineStyle','-')
    plot(ens.t, sim.Iab(1,:),'Color',blue,'LineWidth',1.2,'LineStyle','--')
    plot(ens.t, Imed(2,:),'Color',grayligh,'LineWidth',1.8,'LineStyle','-')
    plot(ens.t, sim.Iab(2,:),'Color',blueligh,'LineWidth',1.2,'LineStyle','--')
cu4= legend({'i_{\alpha}','i_{\alpha, sim}','i_{\beta}','i_{\beta, sim}'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal');  xlim(xli)
ylabel('Current [A]','FontAngle','normal');
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
if sav == 1, exportgraphics(miax,['FIGURES\',erase(archivo,'.dat'),'_ABcurrents.pdf'],'ContentType','vector'); end
hold off

% x-y currents
% OJO AL INTERPRETARLA: la componente de bajo orden de i_x medida va en
% contrafase con la simulada. NO es un error de las transformadas (la Clarke
% de ControlProgram.c, directa e inversa, coincide con la del proyecto) ni un
% cambio de signo global (invertir i_xy arreglaria el fundamental pero
% romperia el 5o y el 7o).
%
% La clave esta en separar por armonicos. Calculando Z(h) = v_xy(h)/i_xy(h):
%    h = +5 y -7  ->  Re(Z) = +27.9 y +15.1 ohm, L = 0.0496 y 0.0423 H
%                     PASIVA y coherente: aqui la tension SI explica la
%                     corriente, y de ahi sale Lxy = 0.0447 H.
%    h = +-1, +11, +13 -> Re(Z) < 0: el plano estaria generando potencia,
%                     lo cual es imposible.
% Y esos armonicos "imposibles" son EXACTAMENTE los que la VSD asigna al
% plano alpha-beta (12k+-1), no al x-y (12k+-5). Es decir, no son corrientes
% x-y reales: son corrientes de alpha-beta coladas en la medida de x-y por
% errores de ganancia y offset de los sensores (solo se miden Ia1,Ib1,Ia2,Ib2
% y se deducen Ic1,Ic2, asi que esos errores se proyectan integros sobre x-y).
% Las fugas medidas son del 0.6 al 4 % de la fundamental, compatibles con
% errores de calibracion de pocos puntos porcentuales.
% Una corriente ficticia no obedece la ecuacion de planta del plano, y por
% eso no hay Lxy que la reproduzca. Identify_IM6Ph_2n.m lo desglosa (PASO 2).
p1 = figure('Name','x-y Currents','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0.2,10,wi,he]; figure(p1)
miax = axes; hold on
    plot(ens.t, Imed(3,:),'Color',orange,'LineWidth',1.8,'LineStyle','-')
    plot(ens.t, sim.Iab(3,:),'Color',blue,'LineWidth',1.2,'LineStyle','--')
    plot(ens.t, Imed(4,:),'Color',grayligh,'LineWidth',1.8,'LineStyle','-')
    plot(ens.t, sim.Iab(4,:),'Color',blueligh,'LineWidth',1.2,'LineStyle','--')
cu4= legend({'i_x','i_{x, sim}','i_y','i_{y, sim}'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal');  xlim(xli)
ylabel('Current [A]','FontAngle','normal');
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
if sav == 1, exportgraphics(miax,['FIGURES\',erase(archivo,'.dat'),'_XYcurrents.pdf'],'ContentType','vector'); end
hold off

% Error de ajuste
p1 = figure('Name','Error','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0.2,1,wi,he]; figure(p1)
miax = axes; hold on
    plot(ens.t, sim.error(1,:),'Color',violet,'LineWidth',1,'LineStyle','-')
    plot(ens.t, sim.error(2,:),'Color',orange,'LineWidth',1,'LineStyle','-')
    plot(ens.t, sim.error(3,:),'Color',grayligh,'LineWidth',1,'LineStyle','-')
    plot(ens.t, sim.error(4,:),'Color',blueligh,'LineWidth',1,'LineStyle','-')
cu4= legend({'e_{\alpha}','e_{\beta}','e_x','e_y'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal');  xlim(xli)
ylabel('Error [A]','FontAngle','normal');
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
if sav == 1, exportgraphics(miax,['FIGURES\',erase(archivo,'.dat'),'_error.pdf'],'ContentType','vector'); end
hold off

% Rotor flux
p1 = figure('Name','Rotor flux','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [46,19,wi,he]; figure(p1)
miax = axes; hold on
    plot(ens.t, sim.Psir(1,:),'Color',violet,'LineWidth',1,'LineStyle','-')
    plot(ens.t, sim.Psir(2,:),'Color',orange,'LineWidth',1,'LineStyle','-')
    plot(ens.t, sqrt(sim.Psir(1,:).^2 + sim.Psir(2,:).^2),'Color',blue,'LineWidth',1.6,'LineStyle','-')
cu4= legend({'\psi_{r\alpha}','\psi_{r\beta}','|\psi_r|'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal');  xlim(xli)
ylabel('Flux [Wb]','FontAngle','normal');
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
if sav == 1, exportgraphics(miax,['FIGURES\',erase(archivo,'.dat'),'_Flux.pdf'],'ContentType','vector'); end
hold off

% Phase currents, una fase de cada tripla
p1 = figure('Name','Phase Currents','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [46,10,wi,he]; figure(p1)
miax = axes; hold on
    plot(ens.t, ens.Iph(1,:),'Color',orange,'LineWidth',1.8,'LineStyle','-')
    plot(ens.t, sim.Iph(1,:),'Color',blue,'LineWidth',1.2,'LineStyle','--')
    plot(ens.t, ens.Iph(4,:),'Color',grayligh,'LineWidth',1.8,'LineStyle','-')
    plot(ens.t, sim.Iph(4,:),'Color',blueligh,'LineWidth',1.2,'LineStyle','--')
cu4= legend({'i_{a1}','i_{a1, sim}','i_{a2}','i_{a2, sim}'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal');  xlim(xli)
ylabel('Current [A]','FontAngle','normal');
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
if sav == 1, exportgraphics(miax,['FIGURES\',erase(archivo,'.dat'),'_PHcurrents.pdf'],'ContentType','vector'); end
hold off

% Voltage reference, los dos planos
% Las referencias x-y son dos ordenes de magnitud menores que las de
% alpha-beta, asi que comparten eje de tiempos pero no de ordenadas: en la
% misma escala el plano x-y seria una linea plana.
p1 = figure('Name','Voltage reference','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [46,1,wi,he]; figure(p1)
miax = axes; hold on
yyaxis left
    plot(ens.t, Uab(1,:),'Color',orange,'LineWidth',1,'LineStyle','-')
    plot(ens.t, Uab(2,:),'Color',violet,'LineWidth',1,'LineStyle','-')
    ylabel('v_{\alpha\beta} [V]','FontAngle','normal')
yyaxis right
    plot(ens.t, Uab(3,:),'Color',blue,'LineWidth',1,'LineStyle','-')
    plot(ens.t, Uab(4,:),'Color',blueligh,'LineWidth',1,'LineStyle','-')
    ylabel('v_{xy} [V]','FontAngle','normal')
cu4= legend({'v_{\alpha}^*','v_{\beta}^*','v_x^*','v_y^*'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal');  xlim(xli)
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
miax.YAxis(1).Color = violet;
miax.YAxis(2).Color = blue;
if sav == 1, exportgraphics(miax,['FIGURES\',erase(archivo,'.dat'),'_voltage.pdf'],'ContentType','vector'); end
hold off


%----------------------------  LOCAL FUNCTIONS  --------------------------%
function Psir0 = fluxSteadyState(Iab, th, wsl, Lm, Tr)
%   Flujo de rotor inicial supuesto regimen permanente.
%   En ejes sincronos  psir = Lm*is/(1 + j*wsl*Tr).  El fasor de is se
%   obtiene por minimos cuadrados sobre [cos(th) sin(th)], que es deteccion
%   sincrona exacta usando el angulo medido. Despues se devuelve al marco
%   estacionario en el instante inicial.
    B  = [cos(th); sin(th)].';
    cf = B\[Iab(1,:).' Iab(2,:).'];          % 2x2: [ca cb; sa sb]
    % Fasor directo de is (componente que gira con +th)
    Is = ((cf(1,1) + cf(2,2)) + 1i*(cf(1,2) - cf(2,1)))/2;
    Pr = Lm*Is/(1 + 1i*wsl*Tr);
    Pr0 = Pr*exp(1i*th(1));
    Psir0 = [real(Pr0); imag(Pr0)];
end
