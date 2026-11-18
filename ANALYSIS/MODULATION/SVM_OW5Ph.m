
%%% Space vector modulation - Open-end Winding 5phase %%%

clear all; close all; clc
Phase = 5;
n = 2*Phase;
total_combinations = 2^n; % Total de combinaciones posibles
S = zeros(total_combinations, n); % Matriz para almacenar todas las combinaciones
K = [1  0  0  0  0 -1  0  0  0  0 
     0  1  0  0  0  0 -1  0  0  0
     0  0  1  0  0  0  0 -1  0  0
     0  0  0  1  0  0  0  0 -1  0
     0  0  0  0  1  0  0  0  0 -1]; % Matriz vaa'=vdc·K·[Si] % Matriz vi=vdc·K·[Si]

% Switching states
for i = 0:total_combinations-1
    % Convertir el número a binario y almacenarlo en la matriz
    S(i+1, :) = bitget(i, n:-1:1);
end

% Phase voltage
V_abcde = zeros(Phase, length(S));
Vdc = 1;
for i = 1:length(S)
    V_abcde(:,i) = Vdc .* K * S(i,:)';
end


% Clarke transformation 
ang = 2*pi/5;
Clarke=(2/5)*...
   [1	       cos(ang)	    cos(2*ang)	cos(3*ang)	cos(4*ang)  ;
    0 		   sin(ang)	    sin(2*ang)	sin(3*ang)	sin(4*ang)  ;
    1	       cos(3*ang)	cos(6*ang)  cos(9*ang)	cos(12*ang) ;
    0  		   sin(3*ang)	sin(6*ang)	sin(9*ang)	sin(12*ang) ;
    1/(2)      1/(2)        1/(2)       1/(2)       1/(2)]	 ;
% Alpha-Beta voltage
V_abxy = zeros(Phase,length(S));
for i = 1:length(S)
    V_abxy(:,i) = Clarke * V_abcde(:,i);
end

% Indices vectores unicos
[~, uni] = unique(V_abxy.', 'rows');

modulo_ab = sqrt(V_abxy(1,uni).^2 + V_abxy(2,uni).^2);
ind_LV = find(modulo_ab>1.2);
ind_LV1 = find(modulo_ab>1.28);
ind_LV2 = find(modulo_ab>1.2 & modulo_ab<1.28);
ind_LV3 = find(modulo_ab>0.76 & modulo_ab<0.765);
ind_cmv = find(V_abxy(5,uni)<0.01);

%%% REFERENCE VOLTAGE %%%
v_ref = [0.8 0.7 0 0 0]';

sav = 1;
wi = 6;
he = 6;

hl = 0.14;   % longitud de cabeza
hw = 0.05;   % ancho de cabeza
hl2 = 0.10;   % longitud de cabeza
hw2 = 0.05;   % ancho de cabeza
hl3 = 0.06;   % longitud de cabeza
hw3 = 0.02;   % ancho de cabeza
textsize = 16;
theta = linspace(0,2*pi,400);

color0 = [0.0 0.0 0.0];
color1 = [0.1 0.1 0.1];
color2 = [0.2 0.2 0.2];
color3 = [0.3 0.3 0.3];
color4 = [0.4 0.4 0.4];
color5 = [0.5 0.5 0.5];
color6 = [0.6 0.6 0.6];
color7 = [0.7 0.7 0.7];
color8 = [0.8 0.8 0.8];
color9 = [0.9 0.9 0.9];
color10= [1.0 1.0 1.0];

% color2 = [0.2 0.6 0.8];
% color3 = [1 0.5 0.17];
% color4 = [0.4 0.4 0.4];

% figure; hold on
% scatter(V_abxy(1,uni), V_abxy(2,uni))
% axis equal
% 
ind_sv_m = [8 10]; % Inside 'uni(ind_LV3())'
ind_sv_l = [8 10]; % Inside 'uni(ind_LV2())'
% figure; hold on
% scatter(V_abxy(1,uni([ind_LV2 ind_LV3])), V_abxy(2,uni([ind_LV2 ind_LV3])))
% t = 8; scatter(V_abxy(1,uni(ind_LV2(t))), V_abxy(2,uni(ind_LV2(t))), 'filled')
% for i=1:length(ind_LV1), myVector(0,[V_abxy(1,uni(ind_LV1(i))) + j*V_abxy(2,uni(ind_LV1(i)))],color4,1.6,hl,hw); end
% for i=1:length(ind_LV2), myVector(0,[V_abxy(1,uni(ind_LV2(i))) + j*V_abxy(2,uni(ind_LV2(i)))],color1,1.6,hl,hw); end
% axis equal



ind_sv = [1 ind_LV3(ind_sv_m) ind_LV2(ind_sv_l)];
Msv = [V_abxy(:,uni(ind_sv)) zeros(5,1)
         ones(1,6)]
t = Msv \ [v_ref; 1]% inv(Msv) * [v_ref; 1]

% Relation between ind_sv index and drawing index:
% indx  2  3  4  5
% draw v3 v4 v1 v2

% %%%------------------- Figure Space Vector 5phase OW -------------------%%%
% p1 = figure('Name','Space Vector','NumberTitle','off');
% p1.Units = "centimeters"; p1.Position = [0,18,wi,he]; figure(p1); miax = axes; hold on
%     myVector(0,[v_ref(1) + j*v_ref(2)],color0,1.6,hl,hw)
%     for i=1:length(ind_LV2), myVector(0,[V_abxy(1,uni(ind_LV2(i))) + j*V_abxy(2,uni(ind_LV2(i)))],color8,1.6,hl,hw); end
%         for i=1:length(ind_sv_l), myVector(0,[V_abxy(1,uni(ind_LV2(ind_sv_l(i)))) + j*V_abxy(2,uni(ind_LV2(ind_sv_l(i))))],color5,1.6,hl,hw); end
%     for i=1:length(ind_LV3), myVector(0,[V_abxy(1,uni(ind_LV3(i))) + j*V_abxy(2,uni(ind_LV3(i)))],color9,1.6,hl,hw); end
%         for i=1:length(ind_sv_m), myVector(0,[V_abxy(1,uni(ind_LV3(ind_sv_m(i)))) + j*V_abxy(2,uni(ind_LV3(ind_sv_m(i))))],color7,1.6,hl,hw); end
% axis equal
%     text(v_ref(1),v_ref(2), '$v_{ref}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
% 
%     text(V_abxy(1,uni(ind_sv(4)))-0.12,V_abxy(2,uni(ind_sv(4)))+0.06, '$v_{1}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
%     text(V_abxy(1,uni(ind_sv(5)))-0.05,V_abxy(2,uni(ind_sv(5)))-0.1, '$v_{2}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
%     text(V_abxy(1,uni(ind_sv(2)))-0.15,V_abxy(2,uni(ind_sv(2)))+0.08, '$v_{3}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
%     text(V_abxy(1,uni(ind_sv(3))),V_abxy(2,uni(ind_sv(3)))-0.08, '$v_{4}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
% 
% 
%     xlabel('Time [s]','FontAngle','normal'); ylabel('Torque [Nm]','FontAngle','normal'); % xlim(lim.x); ylim(lim.y.T);
% grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman'); hold off
% if sav==1, exportgraphics(p1,['ANALYSIS\MODULARION\SV_full.pdf']); end










% %%%------------------ Figure Space Vector Alpha-beta -------------------%%%
% p1 = figure('Name','Vref ab','NumberTitle','off');
% p1.Units = "centimeters"; p1.Position = [0,8,wi,he]; figure(p1); miax = axes; hold on
%     % myVector(0,[V_abxy(1,uni(ind_sv(1)))*t(1) + j*V_abxy(2,uni(ind_sv(1)))*t(1)],color6,1.6,hl2,hw2)
%     v_ant = [V_abxy(1,uni(ind_sv(1)))*t(1) + j*V_abxy(2,uni(ind_sv(1)))*t(1)];
%     for i=2:length(ind_sv)
%         myVector(v_ant,[V_abxy(1,uni(ind_sv(i)))*t(i) + j*V_abxy(2,uni(ind_sv(i)))*t(i)],color6,1.6,hl2,hw2)
%         v_ant = v_ant + V_abxy(1,uni(ind_sv(i)))*t(i) + j*V_abxy(2,uni(ind_sv(i)))*t(i);
%     end
%     myVector(0,[v_ref(1) + j*v_ref(2)],color0,1.6,hl2,hw2)
% axis equal
%     text(v_ref(1),v_ref(2), '$v_{ref}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
% 
%     text(0.0, 0.17, '$t_3v_{3}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
%     text(0.1, 0.23, '$t_4v_{4}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
%     text(0.4, 0.6 , '$t_1v_{1}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
%     text(0.64, 0.72, '$t_2v_{2}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
% 
% 
%     xlabel('Time [s]','FontAngle','normal'); ylabel('Torque [Nm]','FontAngle','normal'); % xlim(lim.x); ylim(lim.y.T);
% grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman'); hold off
% if sav==1, exportgraphics(p1,['ANALYSIS\MODULARION\SV_ab.pdf']); end







% %%%--------------------- Figure Space Vector x-y -----------------------%%%
% p1 = figure('Name','Vref xy','NumberTitle','off');
% p1.Units = "centimeters"; p1.Position = [0,0,wi,he]; figure(p1); miax = axes; hold on
%     % myVector(0,[V_abxy(3,uni(ind_sv(1)))*t(1) + j*V_abxy(4,uni(ind_sv(1)))*t(1)],color6,1.6,hl3,hw3)
%     v_ant = [V_abxy(3,uni(ind_sv(1)))*t(1) + j*V_abxy(4,uni(ind_sv(1)))*t(1)];
%     for i=2:length(ind_sv)
%         myVector(v_ant,[V_abxy(3,uni(ind_sv(i)))*t(i) + j*V_abxy(4,uni(ind_sv(i)))*t(i)],color6,1.6,hl3,hw3)
%         v_ant = v_ant + V_abxy(3,uni(ind_sv(i)))*t(i) + j*V_abxy(4,uni(ind_sv(i)))*t(i);
%     end
%     % myVector(0,[v_ref(3) + j*v_ref(4)],color0,1.6,hl3,hw3)
%     scatter(0,0,20,"black", "filled")
% axis equal
%     text(v_ref(1),v_ref(2), '$v_{ref}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
% 
%     text(-0.11, 0.02, '$t_3v_{3}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
%     text(-0.1, 0.1, '$t_4v_{4}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
%     text(0.03, 0.07 , '$t_1v_{1}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
%     text(0.01, 0, '$t_2v_{2}$', 'FontSize',10,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
% 
%     xlabel('Time [s]','FontAngle','normal'); ylabel('Torque [Nm]','FontAngle','normal'); % xlim(lim.x); ylim(lim.y.T);
% grid on; set(miax,'FontSize',9,'GridLineStyle',':','FontName','Times New Roman'); hold off
% if sav==1, exportgraphics(p1,['ANALYSIS\MODULARION\SV_xy.pdf']); end








font = 11;



%%%------------------- Figure Space Vector 5phase OW -------------------%%%
p1 = figure('Name','Space Vector','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0,18,wi,he]; figure(p1); miax = axes; hold on

% Parámetros para ejes personalizados
maxR = 1.3; set(gca, 'XColor', 'none', 'YColor', 'none') % Oculta los ejes nativos
axis equal; axis([-maxR maxR -maxR maxR]);

% Parámetros para que "sobresalgan"
extra = 0.14; x_start = -maxR - extra;  x_end =  maxR + extra; y_start = -maxR - extra;  y_end =  maxR + extra;

% Flecha eje X
hx = quiver(miax, x_start, 0, (x_end - x_start), 0, 0, 'Color',[0.1 0.1 0.1], 'LineWidth',0.6, 'MaxHeadSize',0.1, 'Clipping','off');

% Flecha eje Y
hy = quiver(miax, 0, y_start, 0, (y_end - y_start), 0, 'Color',[0.1 0.1 0.1], 'LineWidth',0.6, 'MaxHeadSize',0.1, 'Clipping','off');

% (opcional) asegurarlas al fondo de la pila del axes
uistack([hx hy],'bottom');

% Círculos concéntricos (grid radial)
radii = [0.76 1.23];
theta = linspace(0, 2*pi, 300);
for r = radii
    x_circle = r*cos(theta);
    y_circle = r*sin(theta);
    plot(x_circle, y_circle, ':', 'Color', [0.7 0.7 0.7]);
end
% Mostrar valor del último radio (último círculo)
r_label = radii(end);
theta_label = pi/16;  % ángulo para ubicar el texto (45 grados)

text(0.76, -0.46, '0.76pu', 'FontSize', font, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
    'Color', [0.4 0.4 0.4], 'FontAngle','normal');

text(1.1, -0.74, '1.23pu', 'FontSize', font, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
    'Color', [0.4 0.4 0.4], 'FontAngle','normal');

% Etiquetas
text(maxR*1.02-0.33, -0.1, '\alpha [pu]','FontSize',font, 'FontName','Times New Roman')
text(-0.3, maxR*1.04-0.1, '\beta [pu]',  'FontSize',font, 'FontName','Times New Roman', ...
    'HorizontalAlignment','center', 'VerticalAlignment','bottom')

% PLOTS
    myVector(0,[v_ref(1) + j*v_ref(2)],color0,1,hl,hw)
    for i=1:length(ind_LV2), myVector(0,[V_abxy(1,uni(ind_LV2(i))) + j*V_abxy(2,uni(ind_LV2(i)))],color8,1,hl,hw); end
        for i=1:length(ind_sv_l), myVector(0,[V_abxy(1,uni(ind_LV2(ind_sv_l(i)))) + j*V_abxy(2,uni(ind_LV2(ind_sv_l(i))))],color5,1,hl,hw); end
    for i=1:length(ind_LV3), myVector(0,[V_abxy(1,uni(ind_LV3(i))) + j*V_abxy(2,uni(ind_LV3(i)))],color9,1,hl,hw); end
        for i=1:length(ind_sv_m), myVector(0,[V_abxy(1,uni(ind_LV3(ind_sv_m(i)))) + j*V_abxy(2,uni(ind_LV3(ind_sv_m(i))))],color7,1,hl,hw); end
axis equal
    text(v_ref(1),v_ref(2), '$v_{ref}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
    
    text(V_abxy(1,uni(ind_sv(4)))-0.12,V_abxy(2,uni(ind_sv(4)))+0.1, '$v_{1}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
    text(V_abxy(1,uni(ind_sv(5)))-0.05,V_abxy(2,uni(ind_sv(5)))-0.1, '$v_{2}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
    text(V_abxy(1,uni(ind_sv(2)))-0.2,V_abxy(2,uni(ind_sv(2)))+0.08, '$v_{3}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
    text(V_abxy(1,uni(ind_sv(3))),V_abxy(2,uni(ind_sv(3)))-0.08, '$v_{4}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')

% Save
set(miax,'FontSize',8,'FontName','Times New Roman')
if sav==1, exportSVG(miax,'ANALYSIS\MODULATION\SV_full.svg'); end
hold off






%%%------------------ Figure Space Vector Alpha-beta -------------------%%%
p1 = figure('Name','Vref ab','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0,8,wi,he]; figure(p1); miax = axes; hold on

% Parámetros para ejes personalizados
maxR = 1.3; set(gca, 'XColor', 'none', 'YColor', 'none') % Oculta los ejes nativos
axis equal; axis([-maxR maxR -maxR maxR]);

% Parámetros para que "sobresalgan"
extra = 0.14; x_start = -maxR - extra;  x_end =  maxR + extra; y_start = -maxR - extra;  y_end =  maxR + extra;

% Flecha eje X
hx = quiver(miax, x_start, 0, (x_end - x_start), 0, 0, 'Color',[0.1 0.1 0.1], 'LineWidth',0.6, 'MaxHeadSize',0.1, 'Clipping','off');

% Flecha eje Y
hy = quiver(miax, 0, y_start, 0, (y_end - y_start), 0, 'Color',[0.1 0.1 0.1], 'LineWidth',0.6, 'MaxHeadSize',0.1, 'Clipping','off');

% (opcional) asegurarlas al fondo de la pila del axes
uistack([hx hy],'bottom');

% Círculos concéntricos (grid radial)
radii = [0.76 1.23];
theta = linspace(0, 2*pi, 300);
for r = radii
    x_circle = r*cos(theta);
    y_circle = r*sin(theta);
    plot(x_circle, y_circle, ':', 'Color', [0.7 0.7 0.7]);
end

% Etiquetas
text(maxR*1.02-0.33, -0.1, '\alpha [pu]','FontSize',font, 'FontName','Times New Roman')
text(-0.3, maxR*1.04-0.1, '\beta [pu]',  'FontSize',font, 'FontName','Times New Roman', ...
    'HorizontalAlignment','center', 'VerticalAlignment','bottom')

% PLOTS
% myVector(0,[V_abxy(1,uni(ind_sv(1)))*t(1) + j*V_abxy(2,uni(ind_sv(1)))*t(1)],color6,1.6,hl2,hw2)
    v_ant = [V_abxy(1,uni(ind_sv(1)))*t(1) + j*V_abxy(2,uni(ind_sv(1)))*t(1)];
    for i=2:length(ind_sv)
        myVector(v_ant,[V_abxy(1,uni(ind_sv(i)))*t(i) + j*V_abxy(2,uni(ind_sv(i)))*t(i)],color6,1,hl2,hw2)
        v_ant = v_ant + V_abxy(1,uni(ind_sv(i)))*t(i) + j*V_abxy(2,uni(ind_sv(i)))*t(i);
    end
    myVector(0,[v_ref(1) + j*v_ref(2)],color0,1,hl2,hw2)
axis equal
    text(v_ref(1)+0.03,v_ref(2)-0.08, '$v_{ref}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')

    text(-0.4, 0.13, '$t_3v_{3}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
    text(0.26, 0.12, '$t_4v_{4}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
    text(0.08, 0.6 , '$t_1v_{1}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
    text(0.4, 0.8, '$t_2v_{2}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
   
% Save
set(miax,'FontSize',8,'FontName','Times New Roman')
if sav==1, exportSVG(miax,['ANALYSIS\MODULATION\SV_ab.svg']); end
hold off













%%%--------------------- Figure Space Vector x-y -----------------------%%%
p1 = figure('Name','Vref xy','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0,0,wi,he]; figure(p1); miax = axes; hold on

% Parámetros para ejes personalizados
maxR = 1.3; set(gca, 'XColor', 'none', 'YColor', 'none') % Oculta los ejes nativos
axis equal; axis([-maxR maxR -maxR maxR]);

% Parámetros para que "sobresalgan"
extra = 0.14; x_start = -maxR - extra;  x_end =  maxR + extra; y_start = -maxR - extra;  y_end =  maxR + extra;

% Flecha eje X
hx = quiver(miax, x_start, 0, (x_end - x_start), 0, 0, 'Color',[0.1 0.1 0.1], 'LineWidth',0.6, 'MaxHeadSize',0.1, 'Clipping','off');

% Flecha eje Y
hy = quiver(miax, 0, y_start, 0, (y_end - y_start), 0, 'Color',[0.1 0.1 0.1], 'LineWidth',0.6, 'MaxHeadSize',0.1, 'Clipping','off');

% (opcional) asegurarlas al fondo de la pila del axes
uistack([hx hy],'bottom');

% Círculos concéntricos (grid radial)
radii = [0.76 1.23];
theta = linspace(0, 2*pi, 300);
for r = radii
    x_circle = r*cos(theta);
    y_circle = r*sin(theta);
    plot(x_circle, y_circle, ':', 'Color', [0.7 0.7 0.7]);
end
% Mostrar valor del último radio (último círculo)
r_label = radii(end);
theta_label = pi/16;  % ángulo para ubicar el texto (45 grados)

% Etiquetas
text(maxR*1.02-0.33, -0.1, '$x$','FontSize',font, 'FontName','Times New Roman', 'Interpreter','latex')
text(maxR*1.02-0.15, -0.1, '[pu]','FontSize',font, 'FontName','Times New Roman')

text(-0.47, maxR*1.04-0.1, ['$y$'],  'FontSize',font, 'FontName','Times New Roman', ...
    'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'Interpreter','latex')
text(-0.22, maxR*1.04-0.1, ['[pu]'],  'FontSize',font, 'FontName','Times New Roman', ...
    'HorizontalAlignment','center', 'VerticalAlignment','bottom')

% PLOTS
    % myVector(0,[V_abxy(3,uni(ind_sv(1)))*t(1) + j*V_abxy(4,uni(ind_sv(1)))*t(1)],color6,1.6,hl3,hw3)
    v_ant = [V_abxy(3,uni(ind_sv(1)))*t(1) + j*V_abxy(4,uni(ind_sv(1)))*t(1)];
    for i=2:length(ind_sv)
        myVector(v_ant,[V_abxy(3,uni(ind_sv(i)))*t(i) + j*V_abxy(4,uni(ind_sv(i)))*t(i)],color6,1,hl3,hw3)
        v_ant = v_ant + V_abxy(3,uni(ind_sv(i)))*t(i) + j*V_abxy(4,uni(ind_sv(i)))*t(i);
    end
    % myVector(0,[v_ref(3) + j*v_ref(4)],color0,1.6,hl3,hw3)
    scatter(0,0,20,"black", "filled")
axis equal

    text(-0.4, -0.1, '$t_3v_{3}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
    text(-0.38, 0.2, '$t_4v_{4}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
    text(0.05, 0.15 , '$t_1v_{1}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
    text(0.03, -0.1, '$t_2v_{2}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex')
   
% xlim([-0.1 1.2]); ylim([-0.1 1.2]);
% Save
set(miax,'FontSize',8,'FontName','Times New Roman')
if sav==1, exportSVG(miax,['ANALYSIS\MODULATION\SV_xy.svg']); end
hold off


