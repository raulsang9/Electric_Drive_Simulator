%% WINDING CONNECTION MODE: 5 phase machine
clear all; close all; clc
i = 1;
v = 1;
vI = 0.618;
ang = 2*pi/5;

ia = i;
ib = i*(cos(-ang)   + j*sin(-ang));
ic = i*(cos(-2*ang) + j*sin(-2*ang));
id = i*(cos(-3*ang) + j*sin(-3*ang));
ie = i*(cos(-4*ang) + j*sin(-4*ang));

va = v;
vb = v*(cos(-ang)   + j*sin(-ang));
vc = v*(cos(-2*ang) + j*sin(-2*ang));
vd = v*(cos(-3*ang) + j*sin(-3*ang));
ve = v*(cos(-4*ang) + j*sin(-4*ang));

shif = pi/2 - 2*pi/5;
angI = [-shif  -(2*ang+shif)  ang-shif  -(ang+shif)  2*ang-shif  -shif];
vl1_I = v*(cos(angI(1)) + j*sin(angI(1)));
vl2_I = v*(cos(angI(2)) + j*sin(angI(2)));
vl3_I = v*(cos(angI(3)) + j*sin(angI(3)));
vl4_I = v*(cos(angI(4)) + j*sin(angI(4)));
vl5_I = v*(cos(angI(5)) + j*sin(angI(5)));
vl6_I = v*(cos(angI(6)) + j*sin(angI(6)));

angII = [ang  1.5*ang  2*ang  pi  -2*ang  -1.5*ang  -ang];
vl1_II = v*(cos(angII(1)) + j*sin(angII(1)));
vl2_II = v*(cos(angII(2)) + j*sin(angII(2)));
vl3_II = v*(cos(angII(3)) + j*sin(angII(3)));
vl4_II = v*(cos(angII(4)) + j*sin(angII(4)));
vl5_II = v*(cos(angII(5)) + j*sin(angII(5)));
vl6_II = v*(cos(angII(6)) + j*sin(angII(6)));




% WCM: ACEBD
il1_I = ia;
il2_I = ic-ia;
il3_I = ie-ic;
il4_I = ib-ie;
il5_I = id-ib;
il6_I = -id;

va_I = vl1_I - vl2_I;
vb_I = vl4_I - vl5_I;
vc_I = vl2_I - vl3_I;
vd_I = vl5_I - vl6_I;
ve_I = vl3_I - vl4_I;



% WCM: AC'EB'D
il1_II = ia;
il2_II = -ic-ia;
il3_II = ie+ic;
il4_II = -ib-ie;
il5_II = id+ib;
il6_II = -id;

va_II = vl1_II - vl2_II;
vb_II =-vl4_II + vl5_II;
vc_II =-vl2_II + vl3_II;
vd_II = vl5_II - vl6_II;
ve_II = vl3_II - vl4_II;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Desplazamientos respecto de x = vl2
%     s1 = va;
%     s2 = 0;
%     s3 = -vc;
%     s4 = -vc - ve;
%     s5 = -vc - ve - vb;
%     s6 = -vc - ve - vb - vd;
%     S = [s1; s3; s4; s5; s6];
% 
%     % Igualdad de módulos:
%     % |x+s|^2 = |x|^2  ->  2*Re(conj(x)*s) = -|s|^2
%     A = [2*real(S), 2*imag(S)];
%     b = -abs(S).^2;
% 
%     % Resolver en mínimos cuadrados
%     sol = A \ b;
% 
%     xr = sol(1);
%     xi = sol(2);
%     x = xr + 1j*xi;   % vl2
% 
%     % Reconstrucción
%     vl2_I = x;
%     vl1_I = x + va;
%     vl3_I = x - vc;
%     vl4_I = x - vc - ve;
%     vl5_I = x - vc - ve - vb;
%     vl6_I = x - vc - ve - vb - vd;
% 
%     va_I = va;
%     vb_I = vb;
%     vc_I = vc;
%     vd_I = vd;
%     ve_I = ve;

%% CURRENT WCM-I
f = figure; hold on

hl = 0.14;   % longitud de cabeza
hw = 0.05;   % ancho de cabeza
theta = linspace(0,2*pi,400);

color1 = [0.2 0.2 0.2];
color2 = [0.2 0.6 0.8];
color3 = [1 0.5 0.17];
% Phase
myVector(ia,color1,2,hl,hw)
myVector(ib,color1,2,hl,hw)
myVector(ic,color1,2,hl,hw)
myVector(id,color1,2,hl,hw)
myVector(ie,color1,2,hl,hw)
r = 1; plot(r*cos(theta), r*sin(theta),'--','Color',[0.5 0.5 0.5],'LineWidth',1); text(r*cos(pi/5)+0.1,r*sin(pi/5),'1pu','Interpreter', 'tex','FontSize',11,'FontName','Times New Roman','Color',[0.5 0.5 0.5])

offset = 0.16;
v = ia; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'i_a','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = ib; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'i_b','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = ic; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'i_c','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = id; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'i_d','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = ie; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'i_e','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)

% WCM-I
myVector(il1_I,color3,1.6,hl,hw)
myVector(il2_I,color3,1.6,hl,hw)
myVector(il3_I,color3,1.6,hl,hw)
myVector(il4_I,color3,1.6,hl,hw)
myVector(il5_I,color3,1.6,hl,hw)
myVector(il6_I,color3,1.6,hl,hw)
r = abs(il2_I); plot(r*cos(theta), r*sin(theta),'--','Color',[0.5 0.5 0.5],'LineWidth',1); text(r*cos(pi/5)+0.1,r*sin(pi/5),'1,9pu','Interpreter', 'tex','FontSize',11,'FontName','Times New Roman','Color',[0.5 0.5 0.5])

offset = 0.2;
v = il1_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x+0.15,y,'i_{L1,I}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color3)
v = il2_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x-0.1,y,'i_{L2,I}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color3)
v = il3_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'i_{L3,I}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color3)
v = il4_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'i_{L4,I}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color3)
v = il5_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x-0.1,y,'i_{L5,I}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color3)
v = il6_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'i_{L6,I}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color3)


axis equal; axis off
xlim([-2 2]); ylim([-2 2])

exportgraphics(gcf,'ANALYSIS/SEW/WCSI_LCS.png')


%% CURRENT WCM-II
f = figure; hold on

hl = 0.14;   % longitud de cabeza
hw = 0.05;   % ancho de cabeza
theta = linspace(0,2*pi,400);

color1 = [0.2 0.2 0.2];
color2 = [0.2 0.6 0.8];
color3 = [1 0.5 0.17];
% Phase
myVector(ia,color1,2,hl,hw)
myVector(ib,color1,2,hl,hw)
myVector(ic,color1,2,hl,hw)
myVector(id,color1,2,hl,hw)
myVector(ie,color1,2,hl,hw)
r = 1; plot(r*cos(theta), r*sin(theta),'--','Color',[0.5 0.5 0.5],'LineWidth',1); text(r*cos(pi/5)+0.1,r*sin(pi/5),'1pu','Interpreter', 'tex','FontSize',11,'FontName','Times New Roman','Color',[0.5 0.5 0.5])

offset = 0.16;
v = ia; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'i_a','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = ib; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'i_b','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = ic; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'i_c','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = id; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'i_d','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = ie; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'i_e','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)

% WCM-II
myVector(il1_II,color3,1.6,hl,hw)
myVector(il2_II,color3,1.6,hl,hw)
myVector(il3_II,color3,1.6,hl,hw)
myVector(il4_II,color3,1.6,hl,hw)
myVector(il5_II,color3,1.6,hl,hw)
myVector(il6_II,color3,1.6,hl,hw)
r = abs(il2_II); plot(r*cos(theta), r*sin(theta),'--','Color',[0.5 0.5 0.5],'LineWidth',1); text(r*cos(pi/5)+0.06,r*sin(pi/5),'0,62pu','Interpreter', 'tex','FontSize',11,'FontName','Times New Roman','Color',[0.5 0.5 0.5])

offset = 0.2;
v = il1_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x+0.15,y,'i_{L1,II}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color3)
v = il2_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x+0.05,y-0.03,'i_{L2,II}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color3)
v = il3_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x+0.1,y+0.06,'i_{L3,II}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color3)
v = il4_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x-0.1,y,'i_{L4,II}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color3)
v = il5_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x+0.35,y+0.05,'i_{L5,II}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color3)
v = il6_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'i_{L6,II}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color3)



axis equal; axis off
xlim([-2 2]); ylim([-2 2])

exportgraphics(gcf,'ANALYSIS/SEW/WCSII_LCS.png')




%% VOLTAGE WCM-I
f = figure; hold on

hl = 0.14;   % longitud de cabeza
hw = 0.05;   % ancho de cabeza
theta = linspace(0,2*pi,400);

color1 = [0.2 0.2 0.2];
color2 = [0.2 0.6 0.8];
color3 = [1 0.5 0.17];
% Phase
myVector(va_I,color1,2,hl,hw)
myVector(vb_I,color1,2,hl,hw)
myVector(vc_I,color1,2,hl,hw)
myVector(vd_I,color1,2,hl,hw)
myVector(ve_I,color1,2,hl,hw)
r = abs(va_I); plot(r*cos(theta), r*sin(theta),'--','Color',[0.5 0.5 0.5],'LineWidth',1);text(r*cos(pi/5)+0.1,r*sin(pi/5),'1,9pu','Interpreter', 'tex','FontSize',11,'FontName','Times New Roman','Color',[0.5 0.5 0.5])

offset = 0.16;
v = va_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'v_a','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = vb_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'v_b','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = vc_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'v_c','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = vd_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'v_d','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = ve_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'v_e','Interpreter', 'tex','FontSize',12,'FontName','Times New Roman','Color',color1)

% WCM-I
myVector(vl1_I,color2,1.6,hl,hw)
myVector(vl2_I,color2,1.6,hl,hw)
myVector(vl3_I,color2,1.6,hl,hw)
myVector(vl4_I,color2,1.6,hl,hw)
myVector(vl5_I,color2,1.6,hl,hw)
myVector(vl6_I,color2,1.6,hl,hw)
r = abs(vl2_I); plot(r*cos(theta), r*sin(theta),'--','Color',[0.5 0.5 0.5],'LineWidth',1); text(r*cos(pi/5)+0.1,r*sin(pi/5),'1pu','Interpreter', 'tex','FontSize',11,'FontName','Times New Roman','Color',[0.5 0.5 0.5])

offset = 0.2;
v = vl1_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y+0.1,'v_{L1,I}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color2)
v = vl2_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'v_{L2,I}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color2)
v = vl3_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'v_{L3,I}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color2)
v = vl4_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'v_{L4,I}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color2)
v = vl5_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'v_{L5,I}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color2)
v = vl6_I; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y-0.1,'v_{L6,I}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color2)

axis equal; axis off
xlim([-2 2]); ylim([-2 2])

exportgraphics(gcf,'ANALYSIS/SEW/WCSI_DLU.png')





%% VOLTAGE WCM-II
f = figure; hold on

hl = 0.14;   % longitud de cabeza
hw = 0.05;   % ancho de cabeza
theta = linspace(0,2*pi,400);

color1 = [0.2 0.2 0.2];
color2 = [0.2 0.6 0.8];
color3 = [1 0.5 0.17];
% Phase
myVector(va_II,color1,2,hl,hw)
myVector(vb_II,color1,2,hl,hw)
myVector(vc_II,color1,2,hl,hw)
myVector(vd_II,color1,2,hl,hw)
myVector(ve_II,color1,2,hl,hw)
r = abs(va_II); plot(r*cos(theta), r*sin(theta),'--','Color',[0.5 0.5 0.5],'LineWidth',1); text(r*cos(pi/5)+0.1,r*sin(pi/5),'0,62pu','Interpreter', 'tex','FontSize',11,'FontName','Times New Roman','Color',[0.5 0.5 0.5])

offset = 0.16;
v = va_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'v_a','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = vb_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'v_b','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = vc_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x+0.15,y-0.04,'v_c','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = vd_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x+0.13,y+0.06,'v_d','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color1)
v = ve_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x+0.07,y-0.1,'v_e','Interpreter', 'tex','FontSize',12,'FontName','Times New Roman','Color',color1)

% WCM-II
myVector(vl1_II,color2,1.6,hl,hw)
myVector(vl2_II,color2,1.6,hl,hw)
myVector(vl3_II,color2,1.6,hl,hw)
myVector(vl4_II,color2,1.6,hl,hw)
myVector(vl5_II,color2,1.6,hl,hw)
myVector(vl6_II,color2,1.6,hl,hw)
r = abs(vl2_II); plot(r*cos(theta), r*sin(theta),'--','Color',[0.5 0.5 0.5],'LineWidth',1); text(r*cos(pi/5)+0.1,r*sin(pi/5),'1pu','Interpreter', 'tex','FontSize',11,'FontName','Times New Roman','Color',[0.5 0.5 0.5])

offset = 0.2;
v = vl1_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y,'v_{L1,II}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color2)
v = vl2_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x-0.06,y,'v_{L2,II}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color2)
v = vl3_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x-0.2,y,'v_{L3,II}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color2)
v = vl4_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x-0.2,y,'v_{L4,II}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color2)
v = vl5_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x-0.1,y,'v_{L5,II}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color2)
v = vl6_II; alpha = atan2(imag(v),real(v)); x = real(v) + offset*cos(alpha) - offset/3; y = imag(v) + offset*sin(alpha);
text(x,y+0.05,'v_{L6,II}','Interpreter','tex','FontSize',12,'FontName','Times New Roman','Color',color2)

axis equal; axis off
xlim([-2 2]); ylim([-2 2])

exportgraphics(gcf,'ANALYSIS/SEW/WCSII_DLU.png')








