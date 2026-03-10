%% ELECTRIC DRIVE SIMULATOR
clear all; close all; clc;

% Configuration SetUp
Machine   = 'Lille5Ph'; % [Lille5Ph, Lille7Ph, Malaga5Ph, Malaga9Ph]
file = 'OW_MPC_30Vdc_10kHz_500rpm_3Nm';

% Data load
data = load(['RESULTS\',Machine,'\',file,'.mat']);
data.TEST = extractfile(file);

% Data Processing
tinit = 0.16; ind0 = find(data.timeL>=tinit); 
tend  = 0.3;  ind1 = find(data.timeL>=tend );

data.METRICS = metrics(Machine, data, ind0, ind1);
data.FFT     = myFFT(data.Iphase, data.timeL(2), ind0, ind1);

% DISPLAY METRICS
disp(' ')
disp([Topology,'_',CtrlSchem,'_',num2str(Vdc),'Vdc_',num2str(Freq/1000),'kHz_',num2str(speed),'rpm_',num2str(Tload),'Nm'])
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

%%
% ----------   VISUALIZATION   ---------- %
wi = 10; he = 5; col = load('COLORPALETTE_ENSAM.mat');

% dq currents
p1 = figure('Name','dq Currents','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0.2,21,wi,he]; figure(p1); miax = axes; hold on
    plot(data.timeL, data.Idq(:,1),'Color',col.orange,'LineWidth',1,'LineStyle','-')
    plot(data.timeL, data.Idq(:,2),'Color',col.violet,'LineWidth',1,'LineStyle','-')
    plot(data.timeL, data.Idq_ref(:,1),'Color',col.blueligh,'LineWidth',1,'LineStyle','-')
    plot(data.timeL, data.Idq_ref(:,2),'Color',col.gray,'LineWidth',1,'LineStyle','-')
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
    plot(data.timeL, data.Iphase(:,1),'Color',col.orange,'LineWidth',1,'LineStyle','-')
    plot(data.timeL, data.Iphase(:,2),'Color',col.violet,'LineWidth',1,'LineStyle','-')
    plot(data.timeL, data.Iphase(:,3),'Color',col.blueligh,'LineWidth',1,'LineStyle','-')
    plot(data.timeL, data.Iphase(:,4),'Color',col.gray,'LineWidth',1,'LineStyle','-')
    plot(data.timeL, data.Iphase(:,5),'Color',col.grayligh,'LineWidth',1,'LineStyle','-')
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
    plot(data.timeL, data.Idq(:,3),'Color',col.orange,'LineWidth',1,'LineStyle','-')
    plot(data.timeL, data.Idq(:,4),'Color',col.violet,'LineWidth',1,'LineStyle','-')
    plot(data.timeL, data.Idq(:,5),'Color',col.blueligh,'LineWidth',1,'LineStyle','-')
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



