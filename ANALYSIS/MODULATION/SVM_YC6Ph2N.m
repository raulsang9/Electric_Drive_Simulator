
%%% Space vector modulation - asymmetrical 6 phase (30 deg) with 2 isolated neutrals %%%

clear all; close all; clc
% Fases: a1 b1 c1 (primera tripla) y a2 b2 c2 (segunda tripla, desfasada 30 deg)
Phase = 6;
n = Phase;                        % 6 ramas (una por fase, VSC simple)
total_combinations = 2^n;         % Total de combinaciones posibles (64)
S = zeros(total_combinations, n); % Matriz para almacenar todas las combinaciones

% Matriz vi = Vdc*K*[Si]
% Cada tripla tiene su propio neutro aislado, por lo que la tension de fase de
% un conjunto es su tension de rama menos el valor medio de su propia tripla.
Mn = (1/3)*[ 2 -1 -1
            -1  2 -1
            -1 -1  2];
K = blkdiag(Mn, Mn);

% Switching states
for i = 0:total_combinations-1
    % Convertir el número a binario y almacenarlo en la matriz
    S(i+1, :) = bitget(i, n:-1:1);
end

% Phase voltage [a1 b1 c1 a2 b2 c2]
V_phase = zeros(Phase, total_combinations);
Vdc = 1;
for i = 1:total_combinations
    V_phase(:,i) = Vdc .* K * S(i,:)';
end


% Clarke transformation (invariante en amplitud)
% Angulos espaciales de las 6 fases [a1 b1 c1 a2 b2 c2] (grados)
theta = [0 120 240 30 150 270];
Clarke = (1/3) * [
    cosd(theta)
    sind(theta)
    cosd(5*theta)
    sind(5*theta)
    1 1 1 0 0 0
    0 0 0 1 1 1];

disp(' ')
disp('--- Matriz de Clarke: [alpha beta x y z1 z2]'' = Clarke * [a1 b1 c1 a2 b2 c2]'' ---')
disp(Clarke)


disp(' ')
disp('--- Matriz inversa Clarke: [a1 b1 c1 a2 b2 c2]'' = invClarke * [alpha beta x y z1 z2]'' ---')
disp(inv(Clarke))

% Alpha-Beta / x-y / homopolar voltage
V_abxy = zeros(Phase, total_combinations);
for i = 1:total_combinations
    V_abxy(:,i) = Clarke * V_phase(:,i);
end
% Las filas 5-6 (homopolar de cada tripla) son siempre nulas: neutros aislados

% Indices vectores unicos (49 vectores distintos de los 64 estados)
[~, uni] = unique(V_abxy.', 'rows');

modulo_ab = sqrt(V_abxy(1,uni).^2 + V_abxy(2,uni).^2);

% Grupos de vectores: 0 - 0.1725 - 0.3333 - 0.4714 - 0.6440 pu
% La modulacion solo emplea los largos y el nulo
ind_LV = find(modulo_ab > 0.60);   % 12 vectores largos (0.6440 pu)

% Vectores largos ordenados por angulo (12 vectores, cada 30 deg, el 1º a 15 deg)
ang_LV = mod(atan2d(V_abxy(2,uni(ind_LV)), V_abxy(1,uni(ind_LV))), 360);
[ang_LV, ord] = sort(ang_LV);
ind_LV = ind_LV(ord);

%%% REFERENCE VOLTAGE %%% [alpha beta x y]
% 0.531pu a 33 deg: dentro del circulo lineal (0.577pu) y en posicion generica
v_ref = [0.445 0.29 0 0]';

% Sector de v_ref y seleccion de los 4 vectores largos (2 a cada lado)
ang_ref = mod(atan2d(v_ref(2), v_ref(1)), 360);
k = find(ang_LV <= ang_ref, 1, 'last');
if isempty(k), k = numel(ind_LV); end
sel = mod([k-1 k k+1 k+2] - 1, numel(ind_LV)) + 1;

% 4 vectores largos + vector nulo -> 5 incognitas
% 5 ecuaciones: alpha, beta, x, y y suma de tiempos unitaria
ind_sv = ind_LV(sel);
Msv = [V_abxy(1:4,uni(ind_sv)) zeros(4,1)
       ones(1,numel(ind_sv)+1)];

% Tiempos en funcion de la referencia: t = Tsv*[v_alpha v_beta v_x v_y 1]'
Tsv = inv(Msv);
t = Tsv * [v_ref(1:4); 1];   % [t(1) t(2) t(3) t(4) t(5)=t0]

% Estados de conmutacion aplicados (una fila por vector)
S_sv = S(uni(ind_sv),:);

%%%------------------------- Command window --------------------------%%%
fprintf('--- Tiempos de aplicacion en funcion de [v_alpha v_beta v_x v_y] ---\n')
v_name = {'v_alpha','v_beta ','v_x    ','v_y    '};
for q = 1:size(Tsv,1)
    fprintf('  t(%d) = ', q);
    for c = 1:4
        fprintf('%+7.4f*%s ', Tsv(q,c), v_name{c});
    end
    fprintf('%+7.4f\n', Tsv(q,5));
end

fprintf('\n--- Tiempos para v_ref = [%s ] pu ---\n', num2str(v_ref(1:4)','%8.4f'))
for q = 1:numel(t)-1
    fprintf('  t(%d) = %7.4f   vector largo a %5.1f deg   estado [%d %d %d %d %d %d]\n', ...
        q, t(q), ang_LV(sel(q)), S_sv(q,:))
end
fprintf('  t(%d) = %7.4f   vector nulo\n', numel(t), t(end))
fprintf('  suma  = %7.4f\n\n', sum(t))

% Vectores aplicados (alpha-beta y x-y) ya escalados por su tiempo
sv_ab = (V_abxy(1,uni(ind_sv)) + j*V_abxy(2,uni(ind_sv))) .* t(1:end-1).';
sv_xy = (V_abxy(3,uni(ind_sv)) + j*V_abxy(4,uni(ind_sv))) .* t(1:end-1).';

sav = 1;
wi = 6;
he = 6;

textsize = 16;

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

font = 11;

r_LV = max(modulo_ab); % radio de los vectores largos (0.6440 pu)



%%%---------------- Figure Space Vector 6phase 2N (full) ----------------%%%
p1 = figure('Name','Space Vector','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0,18,wi,he]; figure(p1); miax = axes; hold on

% Parámetros para ejes personalizados
maxR = 0.85; set(gca, 'XColor', 'none', 'YColor', 'none') % Oculta los ejes nativos
axis equal; axis([-maxR maxR -maxR maxR]);

hl = 0.11*maxR;   % longitud de cabeza
hw = 0.04*maxR;   % ancho de cabeza

% Parámetros para que "sobresalgan"
extra = 0.11*maxR; x_start = -maxR - extra;  x_end =  maxR + extra; y_start = -maxR - extra;  y_end =  maxR + extra;

% Flecha eje X
hx = quiver(miax, x_start, 0, (x_end - x_start), 0, 0, 'Color',[0.1 0.1 0.1], 'LineWidth',0.6, 'MaxHeadSize',0.1, 'Clipping','off');

% Flecha eje Y
hy = quiver(miax, 0, y_start, 0, (y_end - y_start), 0, 'Color',[0.1 0.1 0.1], 'LineWidth',0.6, 'MaxHeadSize',0.1, 'Clipping','off');

% (opcional) asegurarlas al fondo de la pila del axes
uistack([hx hy],'bottom');

% Círculo de los vectores largos (grid radial)
theta_c = linspace(0, 2*pi, 300);
plot(r_LV*cos(theta_c), r_LV*sin(theta_c), ':', 'Color', [0.7 0.7 0.7]);

% Mostrar valor del radio (a 330 deg, en el hueco entre vectores)
text((r_LV+0.10)*cosd(330), (r_LV+0.10)*sind(330), [num2str(r_LV,'%.2f') 'pu'], 'FontSize', font, ...
    'FontName', 'Times New Roman', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
    'Color', [0.4 0.4 0.4], 'FontAngle','normal');

% Etiquetas
text(0.77*maxR, -0.08*maxR, '\alpha [pu]','FontSize',font, 'FontName','Times New Roman')
text(-0.23*maxR, 0.96*maxR, '\beta [pu]',  'FontSize',font, 'FontName','Times New Roman', ...
    'HorizontalAlignment','center', 'VerticalAlignment','bottom')

% PLOTS
    myVector(0,[v_ref(1) + j*v_ref(2)],color0,1,hl,hw)
    for i=1:length(ind_LV), myVector(0,[V_abxy(1,uni(ind_LV(i))) + j*V_abxy(2,uni(ind_LV(i)))],color8,1,hl,hw); end
        for i=1:length(ind_sv), myVector(0,[V_abxy(1,uni(ind_sv(i))) + j*V_abxy(2,uni(ind_sv(i)))],color5,1,hl,hw); end
axis equal
    % Etiqueta de v_ref desplazada a su izquierda para no pisar el vector v3
    v_txt = (v_ref(1) + j*v_ref(2)) + 0.14*maxR*j*(v_ref(1) + j*v_ref(2))/norm(v_ref(1:2));
    text(real(v_txt), imag(v_txt), '$v_{ref}$', 'FontSize',font,'Color',color0,'FontName','Times New Roman', ...
        'FontAngle','italic','Interpreter','latex','HorizontalAlignment','center','VerticalAlignment','middle')

    for i=1:length(ind_sv)
        text(V_abxy(1,uni(ind_sv(i)))*1.15, V_abxy(2,uni(ind_sv(i)))*1.15, ['$v_{' num2str(i) '}$'], ...
            'FontSize',font,'Color',color0,'FontName','Times New Roman','FontAngle','italic','Interpreter','latex', ...
            'HorizontalAlignment','center','VerticalAlignment','middle')
    end

% Save
set(miax,'FontSize',8,'FontName','Times New Roman')
if sav==1, exportSVG(miax,'ANALYSIS\MODULATION\SV6_full.svg'); end
hold off






%%%------------------ Figure Space Vector Alpha-beta -------------------%%%
p1 = figure('Name','Vref ab','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0,8,wi,he]; figure(p1); miax = axes; hold on

% Parámetros para ejes personalizados
maxR = 0.85; set(gca, 'XColor', 'none', 'YColor', 'none') % Oculta los ejes nativos
axis equal; axis([-maxR maxR -maxR maxR]);

hl2 = 0.08*maxR;   % longitud de cabeza
hw2 = 0.04*maxR;   % ancho de cabeza

% Parámetros para que "sobresalgan"
extra = 0.11*maxR; x_start = -maxR - extra;  x_end =  maxR + extra; y_start = -maxR - extra;  y_end =  maxR + extra;

% Flecha eje X
hx = quiver(miax, x_start, 0, (x_end - x_start), 0, 0, 'Color',[0.1 0.1 0.1], 'LineWidth',0.6, 'MaxHeadSize',0.1, 'Clipping','off');

% Flecha eje Y
hy = quiver(miax, 0, y_start, 0, (y_end - y_start), 0, 'Color',[0.1 0.1 0.1], 'LineWidth',0.6, 'MaxHeadSize',0.1, 'Clipping','off');

% (opcional) asegurarlas al fondo de la pila del axes
uistack([hx hy],'bottom');

% Círculo de los vectores largos (grid radial)
theta_c = linspace(0, 2*pi, 300);
plot(r_LV*cos(theta_c), r_LV*sin(theta_c), ':', 'Color', [0.7 0.7 0.7]);

% Etiquetas
text(0.77*maxR, -0.08*maxR, '\alpha [pu]','FontSize',font, 'FontName','Times New Roman')
text(-0.23*maxR, 0.96*maxR, '\beta [pu]',  'FontSize',font, 'FontName','Times New Roman', ...
    'HorizontalAlignment','center', 'VerticalAlignment','bottom')

% PLOTS
    % Centroide del camino, usado para sacar las etiquetas hacia fuera
    v_cen = mean([0 cumsum(sv_ab)]);
    v_ant = 0; pos = zeros(1,length(sv_ab)+1); lab = cell(1,length(sv_ab)+1);
    for i=1:length(sv_ab)
        myVector(v_ant,sv_ab(i),color6,1,hl2,hw2)
        % Etiqueta en el punto medio del segmento, desplazada perpendicularmente
        v_mid = v_ant + sv_ab(i)/2;
        nrm = j*sv_ab(i)/abs(sv_ab(i));
        if real(nrm)*real(v_mid-v_cen) + imag(nrm)*imag(v_mid-v_cen) < 0, nrm = -nrm; end
        % Los segmentos cortos necesitan mas separacion para no solaparse
        pos(i) = v_mid + 0.11*maxR*(2 - abs(sv_ab(i))/max(abs(sv_ab)))*nrm;
        lab{i} = ['$t_' num2str(i) 'v_{' num2str(i) '}$'];
        v_ant = v_ant + sv_ab(i);
    end
    myVector(0,[v_ref(1) + j*v_ref(2)],color0,1,hl2,hw2)
    pos(end) = (v_ref(1) + j*v_ref(2)) + 0.14*maxR*j*(v_ref(1) + j*v_ref(2))/norm(v_ref(1:2));
    lab{end} = '$v_{ref}$';
axis equal
    pos = spreadLabels(pos, 0.26*maxR);
    for i=1:numel(pos)
        text(real(pos(i)), imag(pos(i)), lab{i}, 'FontSize',font,'Color',color0, ...
            'FontName','Times New Roman','FontAngle','italic','Interpreter','latex', ...
            'HorizontalAlignment','center','VerticalAlignment','middle')
    end

% Save
set(miax,'FontSize',8,'FontName','Times New Roman')
if sav==1, exportSVG(miax,['ANALYSIS\MODULATION\SV6_ab.svg']); end
hold off












%%%--------------------- Figure Space Vector x-y -----------------------%%%
p1 = figure('Name','Vref xy','NumberTitle','off');
p1.Units = "centimeters"; p1.Position = [0,0,wi,he]; figure(p1); miax = axes; hold on

% Parámetros para ejes personalizados
% Los vectores largos solo dejan 0.1725pu en x-y, por eso la escala es menor
maxR = 0.06; set(gca, 'XColor', 'none', 'YColor', 'none') % Oculta los ejes nativos
axis equal; axis([-maxR maxR -maxR maxR]);

hl3 = 0.10*maxR;   % longitud de cabeza
hw3 = 0.04*maxR;   % ancho de cabeza

% Parámetros para que "sobresalgan"
extra = 0.11*maxR; x_start = -maxR - extra;  x_end =  maxR + extra; y_start = -maxR - extra;  y_end =  maxR + extra;

% Flecha eje X
hx = quiver(miax, x_start, 0, (x_end - x_start), 0, 0, 'Color',[0.1 0.1 0.1], 'LineWidth',0.6, 'MaxHeadSize',0.1, 'Clipping','off');

% Flecha eje Y
hy = quiver(miax, 0, y_start, 0, (y_end - y_start), 0, 'Color',[0.1 0.1 0.1], 'LineWidth',0.6, 'MaxHeadSize',0.1, 'Clipping','off');

% (opcional) asegurarlas al fondo de la pila del axes
uistack([hx hy],'bottom');

% Etiquetas
text(0.77*maxR, -0.08*maxR, '$x$','FontSize',font, 'FontName','Times New Roman', 'Interpreter','latex')
text(0.91*maxR, -0.08*maxR, '[pu]','FontSize',font, 'FontName','Times New Roman')

text(-0.36*maxR, 0.96*maxR, ['$y$'],  'FontSize',font, 'FontName','Times New Roman', ...
    'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'Interpreter','latex')
text(-0.17*maxR, 0.96*maxR, ['[pu]'],  'FontSize',font, 'FontName','Times New Roman', ...
    'HorizontalAlignment','center', 'VerticalAlignment','bottom')

% PLOTS
    % Centroide del camino, usado para sacar las etiquetas hacia fuera
    v_cen = mean([0 cumsum(sv_xy)]);
    v_ant = 0; pos = zeros(1,length(sv_xy)); lab = cell(1,length(sv_xy));
    for i=1:length(sv_xy)
        myVector(v_ant,sv_xy(i),color6,1,hl3,hw3)
        % Etiqueta en el punto medio del segmento, desplazada perpendicularmente
        v_mid = v_ant + sv_xy(i)/2;
        nrm = j*sv_xy(i)/abs(sv_xy(i));
        if real(nrm)*real(v_mid-v_cen) + imag(nrm)*imag(v_mid-v_cen) < 0, nrm = -nrm; end
        % Los segmentos cortos necesitan mas separacion para no solaparse
        pos(i) = v_mid + 0.13*maxR*(2 - abs(sv_xy(i))/max(abs(sv_xy)))*nrm;
        lab{i} = ['$t_' num2str(i) 'v_{' num2str(i) '}$'];
        v_ant = v_ant + sv_xy(i);
    end
    % El lazo se cierra en el origen: v_ref(3) = v_ref(4) = 0
    scatter(0,0,20,"black", "filled")
axis equal
    pos = spreadLabels(pos, 0.26*maxR);
    for i=1:numel(pos)
        text(real(pos(i)), imag(pos(i)), lab{i}, 'FontSize',font,'Color',color0, ...
            'FontName','Times New Roman','FontAngle','italic','Interpreter','latex', ...
            'HorizontalAlignment','center','VerticalAlignment','middle')
    end

% Save
set(miax,'FontSize',8,'FontName','Times New Roman')
if sav==1, exportSVG(miax,['ANALYSIS\MODULATION\SV6_xy.svg']); end
hold off




%%%--------------------------------------------------------------------%%%
function pos = spreadLabels(pos, dmin)
%SPREADLABELS Separa las etiquetas que queden a menos de dmin unas de otras
for it = 1:200
    moved = false;
    for a = 1:numel(pos)-1
        for b = a+1:numel(pos)
            d = pos(b) - pos(a);
            if abs(d) < 1e-12, d = 1e-9*(1 + 1i); end
            if abs(d) < dmin
                push = (dmin - abs(d))/2 * d/abs(d);
                pos(a) = pos(a) - push;
                pos(b) = pos(b) + push;
                moved = true;
            end
        end
    end
    if ~moved, break; end
end
end
