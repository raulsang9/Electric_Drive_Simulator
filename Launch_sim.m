%% ELECTRIC DRIVE SIMULATOR
clear all; close all; clc;

% Configuration SetUp
CtrlSchem = 'Vf';      % [MPC, MPCVV, FOCcb, FOCsv, Vf]
Machine   = 'Malaga5Ph'; % [Lille5Ph, Lille7Ph, Malaga5Ph, Malaga9Ph]
Topology  = 'SC';       % [SC:star-connected, OW, SEW]

% Test Setup
slp   = 1; % 14;
speed = 100; % [rpm] Mechanical speed reference
Tload = 1;   % [Nm] Torque load
Vdc   = 200;  % [V] DC supply

CtrlFreq = 10e3; % [Hz] Control Frequency
tsim     = 2;  % [s] Simulation time

[MOTOR, CONTROL, VSC, SENSOR] = load_parameter(Machine, Topology, CtrlSchem, CtrlFreq, Vdc);

% Simulation
DEC = 10; % Decimation data logging
tic; sim("SIMULATOR/ELECTRIC_DRIVE.slx"); elapsed = toc; disp(['Sim time: ', num2str(elapsed), ' s' ])

file = [Topology,'_',CtrlSchem,'_',num2str(Vdc),'Vdc_',num2str(CtrlFreq/1000),'kHz_',num2str(speed),'rpm_',num2str(Tload),'Nm'];
save = 0; savesim(file, Machine, CtrlSchem, save) % save = [0:OFF 1:ON]




%% ----------   TEST METRICS   ---------- %%
tinit = 0.16; ind0 = find(timeL>=tinit); 
tend  = 0.3;  ind1 = find(timeL>=tend );

data.Iphase = Iphase; data.timeL = timeL; data.Idq = Idq; data.Iab = Iab; data.Fsw = Fsw;
data.METRICS = metrics(Machine, data, ind0, ind1);
data.FFT     = myFFT(Iphase, timeL(2), ind0, ind1);

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
disp(['   Fundament  : ', num2str(data.FFT.fund), ' rad/s'])
disp(['   Switch freq: ', num2str(data.METRICS.fsw /1000), ' kHz'])
disp('_______________________________')


%% ----------   VISUALIZATION   ---------- %%
wi = 10; he = 5; col = load('COLORPALETTE_ENSAM.mat');

ind = find(timeL>0.16,1);
% THD Matlab
f_meas = 1/timeL(2);
nmax = 10e3;
data.THDmat.ia = 100*10^(thd(Iphase(ind:end,1),f_meas,nmax)/20);
data.THDmat.ib = 100*10^(thd(Iphase(ind:end,2),f_meas,nmax)/20);
data.THDmat.ic = 100*10^(thd(Iphase(ind:end,3),f_meas,nmax)/20);
data.THDmat.id = 100*10^(thd(Iphase(ind:end,4),f_meas,nmax)/20);
data.THDmat.ie = 100*10^(thd(Iphase(ind:end,5),f_meas,nmax)/20);
data.THDmat.mean = mean([data.THDmat.ia data.THDmat.ib data.THDmat.ic data.THDmat.id data.THDmat.ie]);
disp(['THD mat  : ', num2str(data.THDmat.mean), ' %'])


% dq currents
p1 = figure('Name','dq Currents','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0.2,21,wi,he]; figure(p1); miax = axes; hold on
    plot(timeL, Idq(:,1),'Color',col.orange,'LineWidth',1,'LineStyle','-')
    plot(timeL, Idq(:,2),'Color',col.violet,'LineWidth',1,'LineStyle','-')
    plot(timeL, Idq_ref(:,1),'Color',col.blueligh,'LineWidth',1,'LineStyle','-')
    plot(timeL, Idq_ref(:,2),'Color',col.gray,'LineWidth',1,'LineStyle','-')
cu4= legend({'i_{d}','i_{q}','i_{d}^*','i_{q}^*'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal'); ylabel('Current [A]','FontAngle','normal'); 
% xlim([0.2 0.24]); ylim([-5 60]);
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off

% Phase currents
p1 = figure('Name','Phase Currents','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [10,21,wi,he]; figure(p1); miax = axes; hold on
    plot(timeL, Iphase(:,1),'Color',col.orange,'LineWidth',1,'LineStyle','-')
    plot(timeL, Iphase(:,2),'Color',col.violet,'LineWidth',1,'LineStyle','-')
    plot(timeL, Iphase(:,3),'Color',col.blueligh,'LineWidth',1,'LineStyle','-')
    plot(timeL, Iphase(:,4),'Color',col.gray,'LineWidth',1,'LineStyle','-')
    plot(timeL, Iphase(:,5),'Color',col.grayligh,'LineWidth',1,'LineStyle','-')
cu4= legend({'i_{a}','i_{b}','i_{c}','i_{d}','i_{e}'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal'); ylabel('Current [A]','FontAngle','normal'); 
% xlim([0.2 0.24]); yli = 80; ylim([-yli yli]);
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off


% xy0 currents
p1 = figure('Name','xy0 Currents','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0.2,14,wi,he]; figure(p1); miax = axes; hold on
    plot(timeL, Idq(:,3),'Color',col.orange,'LineWidth',1,'LineStyle','-')
    plot(timeL, Idq(:,4),'Color',col.violet,'LineWidth',1,'LineStyle','-')
    plot(timeL, Idq(:,5),'Color',col.blueligh,'LineWidth',1,'LineStyle','-')
cu4= legend({'i_{x}','i_{y}','i_{0}'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time [s]','FontAngle','normal'); ylabel('Current [A]','FontAngle','normal'); 
ylim([-8 8]);% xlim([0.2 0.24]);
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off

% FFT
p1 = figure('Name','FFT','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [10,14,wi,he]; figure(p1); miax = axes; hold on
    plot(data.FFT.freq, data.FFT.mag,'Color',col.violet,'LineWidth',1,'LineStyle','-')
cu4= legend({'FFT_{i_a}'},'Location','NorthEast');
set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
    'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Frequency [rad/s]','FontAngle','normal'); ylabel('Amplitude [A]','FontAngle','normal'); 
xlim([0 1000]); %ylim([0 5]);
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off





