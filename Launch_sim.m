%% ELECTRIC DRIVE SIMULATOR
clear all; close all; clc;

% Configuration SetUp
CtrlSchem = 'MPC';      % [MPC, MPCVV, FOCcb, FOCsv, Vf, Hybrid]
Machine   = 'Lille5Ph'; % [Lille5Ph, Lille7Ph, Malaga5Ph, Malaga6Ph, Malaga9Ph]
Topology  = 'OW';       % [SC:star-connected, OW, SEW]

% Test Setup
slp   = 1; % 14;
speed = 500; % [rpm] Mechanical speed reference
Tload = 3;   % [Nm] Torque load
Vdc   = 30;  % [V] DC supply

CtrlFreq = 10e3; % [Hz] Control Frequency
tsim     = 0.4;  % [s] Simulation time

[MOTOR, CONTROL, VSC, SENSOR] = load_parameter(Machine, Topology, CtrlSchem, CtrlFreq, Vdc);

% Simulation
DEC = 10; % Decimation data logging
tic; sim = sim("SIMULATOR/ELECTRIC_DRIVE.slx"); elapsed = toc; disp(['Sim time: ', num2str(elapsed), ' s' ])

file = [Topology,'_',CtrlSchem,'_',num2str(Vdc),'Vdc_',num2str(CtrlFreq/1000),'kHz_',num2str(speed),'rpm_',num2str(Tload),'Nm'];
save = 0; savesim(file, Machine, CtrlSchem, save) % save = [0:OFF 1:ON]




%% ----------   TEST METRICS   ---------- %%
tinit = 0.2; ind0 = find(sim.timeL>=tinit); 
tend  = 0.39;  ind1 = find(sim.timeL>=tend );

% data.Iphase = Iphase; data.timeL = timeL; data.Idq = Idq; data.Iab = Iab; data.Fsw = Fsw;
data.METRICS = metrics(Machine, sim, ind0, ind1);
data.Iphase.FFT     = myFFT(sim.Iphase, sim.timeL(2), ind0, ind1);
data.Vphase.FFT     = myFFT(sim.Vphase_ref, sim.timeL(2), ind0, ind1);

% DISPLAY METRICS
disp(' ')
disp([Topology,'_',CtrlSchem,'_',num2str(Vdc),'Vdc_',num2str(CtrlFreq/1000),'kHz_',num2str(speed),'rpm_',num2str(Tload),'Nm'])
disp('_______________________________')
disp(['   Phase RMS  : ', num2str(data.METRICS.RMS), ' A'])
disp(['   THD mat    : ', num2str(data.METRICS.THDmat.mean), ' %'])
disp(['   Desv. idq  : ', num2str(data.METRICS.STD.idq), ' A'])
disp(['   Desv. ixy  : ', num2str(data.METRICS.STD.ixy), ' A'])
disp(['   Desv. ih   : ', num2str(data.METRICS.STD.ih), ' A'])
% disp(['   Zero vector: ', num2str(data.METRICS.p100nulo), ' %'])
disp(['   Fundament  : ', num2str(data.Iphase.FFT.fund), ' rad/s'])
disp(['   Switch freq: ', num2str(data.METRICS.fsw /1000), ' kHz'])
disp('_______________________________')


%% ----------   VISUALIZATION   ---------- %%
wi = 10; he = 5; col = load('COLORPALETTE_ENSAM.mat');

% LIMITS
lim.on = 1; % Activate manual axis limits
lim.x = [0.2 0.25];

lim.y.Iph = [-40 40]; lim.y.Idq = [-5 30]; lim.y.Ixy = [-0.6 0.6];
lim.y.Vph = [-10 10]; lim.y.Vdq = [-10 10]; lim.y.Vxy = [-1 1];


%%% CURRENTS %%%

% FFT Iphase order
p1 = figure('Name','FFT ia','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0,21,wi,he]; figure(p1); miax = axes; hold on
    plot(data.Iphase.FFT.order, data.Iphase.FFT.mag,'Color',col.violet,'LineWidth',1,'LineStyle','-')
xlabel('Harmonic order','FontAngle','normal'); ylabel('Amplitude [A]','FontAngle','normal'); xlim([0 50]); %ylim([0 5]);
    ax_zoom = [0.33 0.4 0.58 0.52];
    ax_inset = axes('Position', ax_zoom); % [X Y Width Height] en escala 0-1
    plot2=plot(ax_inset, data.Iphase.FFT.order, data.Iphase.FFT.mag,'LineWidth',1, 'Color', col.violet); % Graficar en el eje inset
    cu4= legend({'FFT i_a'},'Location','NorthEast'); set(cu4,'FontSize',9,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic',...
    'Position',[0.48 0.68 0.568904593639576 0.225352112676056],'ItemTokenSize',[5,4])
    set(ax_inset,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
    xlim(ax_inset, [0 10]); xticks(ax_inset,[ 1  3  5  7  9 ]);  % Definir zoom en X
    ylim(ax_inset, [0 3]); % Definir zoom en Y
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off

% Phase currents
p1 = figure('Name','Phase Currents','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0,14,wi,he]; figure(p1); miax = axes; hold on
    plot(sim.timeL, sim.Iphase(:,1),'Color',col.orange,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Iphase(:,2),'Color',col.violet,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Iphase(:,3),'Color',col.blueligh,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Iphase(:,4),'Color',col.gray,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Iphase(:,5),'Color',col.grayligh,'LineWidth',1,'LineStyle','-')
cu4= legend({'i_{a}','i_{b}','i_{c}','i_{d}','i_{e}'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal'); ylabel('Current [A]','FontAngle','normal'); 
if lim.on==1,xlim(lim.x); ylim(lim.y.Iph); end
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off

% dq currents
p1 = figure('Name','dq Currents','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0,7,wi,he]; figure(p1); miax = axes; hold on
    plot(sim.timeL, sim.Idq(:,1),'Color',col.orange,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Idq(:,2),'Color',col.violet,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Idq_ref(:,1),'Color',col.blueligh,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Idq_ref(:,2),'Color',col.gray,'LineWidth',1,'LineStyle','-')
cu4= legend({'i_{d}','i_{q}','i_{d}^*','i_{q}^*'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal'); ylabel('Current [A]','FontAngle','normal'); 
if lim.on==1,xlim(lim.x); ylim(lim.y.Idq); end
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off



% xy0 currents
p1 = figure('Name','xy0 Currents','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0,0.5,wi,he]; figure(p1); miax = axes; hold on
    plot(sim.timeL, sim.Idq(:,3),'Color',col.orange,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Idq(:,4),'Color',col.violet,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Idq(:,5),'Color',col.blueligh,'LineWidth',1,'LineStyle','-')
cu4= legend({'i_{x}','i_{y}','i_{0}'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal'); ylabel('Current [A]','FontAngle','normal'); 
if lim.on==1,xlim(lim.x); ylim(lim.y.Ixy); end
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off

% FFT IphaseHz
p1 = figure('Name','FFT ia','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [10,21,wi,he]; figure(p1); miax = axes; hold on
    plot(data.Iphase.FFT.freq, data.Iphase.FFT.mag,'Color',col.violet,'LineWidth',1,'LineStyle','-')
cu4= legend({'FFT_{i_a}'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Frequency [Hz]','FontAngle','normal'); ylabel('Amplitude [A]','FontAngle','normal'); 
xlim([0 4000]); %ylim([0 5]);
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off


%%% VOLTAGE %%%

% FFT Vphase order
p1 = figure('Name','FFT ia','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [20,21,wi,he]; figure(p1); miax = axes; hold on
    plot(data.Vphase.FFT.order, data.Vphase.FFT.mag,'Color',col.violet,'LineWidth',1,'LineStyle','-')
xlabel('Harmonic order','FontAngle','normal'); ylabel('Amplitude [A]','FontAngle','normal'); xlim([0 50]); %ylim([0 5]);
    ax_zoom = [0.33 0.4 0.58 0.52];
    ax_inset = axes('Position', ax_zoom); % [X Y Width Height] en escala 0-1
    plot2=plot(ax_inset, data.Vphase.FFT.order, data.Vphase.FFT.mag,'LineWidth',1, 'Color', col.violet); % Graficar en el eje inset
    cu4= legend({'FFT v_a'},'Location','NorthEast'); set(cu4,'FontSize',9,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic',...
    'Position',[0.48 0.68 0.568904593639576 0.225352112676056],'ItemTokenSize',[5,4])
    set(ax_inset,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
    xlim(ax_inset, [0 10]); xticks(ax_inset,[ 1  3  5  7  9 ]);  % Definir zoom en X
    ylim(ax_inset, [0 3]); % Definir zoom en Y
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off

% Voltage phase
p1 = figure('Name','Phase Volt','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [20,14,wi,he]; figure(p1); miax = axes; hold on
    plot(sim.timeL, sim.Vphase_ref(:,1),'Color',col.orange,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Vphase_ref(:,2),'Color',col.violet,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Vphase_ref(:,3),'Color',col.blueligh,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Vphase_ref(:,4),'Color',col.gray,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Vphase_ref(:,5),'Color',col.grayligh,'LineWidth',1,'LineStyle','-')
cu4= legend({'v_{a}','v_{b}','v_{c}','v_{d}','v_{e}'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal'); ylabel('Voltage [V]','FontAngle','normal'); 
if lim.on==1,xlim(lim.x); ylim(lim.y.Vph); end
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off

% Voltage dq 
p1 = figure('Name','dq Volt','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [20,7,wi,he]; figure(p1); miax = axes; hold on
    plot(sim.timeL, sim.Vdq_ref(:,1),'Color',col.orange,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Vdq_ref(:,2),'Color',col.violet,'LineWidth',1,'LineStyle','-')
cu4= legend({'v_{d}','v_{q}'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal'); ylabel('Current [A]','FontAngle','normal'); 
if lim.on==1,xlim(lim.x); ylim(lim.y.Vdq); end
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off

% Voltage xy0
p1 = figure('Name','xy0 Volt','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [20,0.5,wi,he]; figure(p1); miax = axes; hold on
    plot(sim.timeL, sim.Vdq_ref(:,3),'Color',col.orange,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Vdq_ref(:,4),'Color',col.violet,'LineWidth',1,'LineStyle','-')
    plot(sim.timeL, sim.Vdq_ref(:,5),'Color',col.blueligh,'LineWidth',1,'LineStyle','-')
cu4= legend({'v_{d3}','v_{q3}','v_0'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal'); ylabel('Voltage [V]','FontAngle','normal'); 
if lim.on==1,xlim(lim.x); ylim(lim.y.Vxy); end
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off



