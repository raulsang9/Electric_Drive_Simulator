close all; clear all; clc

n = 1000;
t = linspace(0,2*pi,n);

m = 0.85*sin(t);
p1 = (sawtooth(20*t, 0.5) + 1) / 2;
p2 = -p1;

p1f = sin((50/2)*t);

% figure; hold on
% plot(t,m)
% % plot(t,p1f)
% plot(t,y)

pwm1 = double(p1<m);
pwm2 = double(p2>m);



col = load('COLORPALETTE_ENSAM.mat');
% Carrier Base
f = figure('Name','Carrier Base OW','NumberTitle','off');
f.Units = "centimeters"; f.Position = [10,21,10,3]; figure(f); miax = axes; hold on; box on
    plot(t,m ,'Color',[0.1 0.1 0.1],'LineWidth',1,'LineStyle','-')
    plot(t,p1,'Color',[0.2 0.2 0.2],'LineWidth',0.5,'LineStyle','-')
    plot(t,p2,'Color',[0.2 0.2 0.2],'LineWidth',0.5,'LineStyle','-')
% cu4= legend({'m','p_{vsc1}','p_{vsc2}'},'Location','NorthEast');
% set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
%     'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time','FontAngle','normal'); ylabel('V [pu]','FontAngle','normal'); 
xlim([0 2*pi-0.12]); ylim([-1 1]); yticks([-1 0 1]); xticks([])
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off

% Phase currents
f = figure('Name','Carrier Base OW','NumberTitle','off');
f.Units = "centimeters"; f.Position = [10,16,10,3]; figure(f); miax = axes; hold on; box on
    plot(t,pwm1-pwm2 ,'Color',[0.1 0.1 0.1],'LineWidth',1,'LineStyle','-')
% cu4= legend({'m','p_{vsc1}','p_{vsc2}'},'Location','NorthEast');
% set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
%     'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time','FontAngle','normal'); ylabel('V [pu]','FontAngle','normal'); 
xlim([0 2*pi-0.12]); ylim([-1 1]); yticks([-1 0 1]); xticks([])
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off


f = figure('Name','VSC1','NumberTitle','off');
f.Units = "centimeters"; f.Position = [10,11,10,1.5]; figure(f); miax = axes; hold on; box on
    plot(t,pwm1 ,'Color',[0.1 0.1 0.1],'LineWidth',1,'LineStyle','-')
% cu4= legend({'m','p_{vsc1}','p_{vsc2}'},'Location','NorthEast');
% set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
%     'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time','FontAngle','normal'); ylabel('V [pu]','FontAngle','normal'); 
xlim([0 2*pi-0.12]); ylim([0 1]); yticks([0 1]); xticks([])
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off

f = figure('Name','VSC2','NumberTitle','off');
f.Units = "centimeters"; f.Position = [10,6,10,1.5]; figure(f); miax = axes; hold on; box on
    plot(t,pwm2 ,'Color',[0.1 0.1 0.1],'LineWidth',1,'LineStyle','-')
% cu4= legend({'m','p_{vsc1}','p_{vsc2}'},'Location','NorthEast');
% set(cu4,'NumColumns',6,'FontSize',8,'Orientation','Horizontal','EdgeColor','none','Color','none','FontName','Times New Roman','FontAngle','italic', ...
%     'Position',[0.4 0.8 0.6 0.16],'ItemTokenSize',[4,4])
xlabel('Time','FontAngle','normal'); ylabel('V [pu]','FontAngle','normal'); 
xlim([0 2*pi-0.12]); ylim([0 1]); yticks([0 1]); xticks([])
grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman')
hold off
