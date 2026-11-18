%% WINDING CONNECTION MODE: 4 regular classes of a 5-phase SEW machine
% Diagramas fasoriales de corrientes y tensiones de las 4 clases regulares
% de secuencias de conexión (WCM) de una máquina de 5 fases en
% series-end winding (5 devanados en cadena abierta, 6 ramas L1..L6).
%
%   R1  AC'EB'D (WCM-II)   delta =  36 deg
%   R2  ABCDE              delta =  72 deg
%   R3  AB'CD'E            delta = 108 deg
%   R4  ACEBD   (WCM-I)    delta = 144 deg
%
% Convenios (los mismos que WCM_evaluation.m):
%   - Fases A..E en -72 deg * k, corriente de fase 1 pu.
%   - Devanado k de la cadena: fase p_k, polaridad s_k = +1 / -1 (prima ').
%   - iL1 = s1*i_p1,  iLk = s_k*i_pk - s_(k-1)*i_p(k-1),  iL6 = -s5*i_p5
%   - s_k*v_pk = vLk - vL(k+1)
%   - Tensiones de rama normalizadas a 1 pu (centro de la circunferencia
%     que pasa por los nudos de la cadena = tensión de modo común óptima).
%     Ese centro es exacto para secuencias regulares; para secuencias
%     irregulares el ajuste por mínimos cuadrados es solo aproximado.
%
% Cualquier otra WCM se puede dibujar añadiéndola a la tabla WCM.

clear; close all; clc

WCM = { 'R1', 'AC''EB''D', '(WCM-II)'
        'R2', 'ABCDE',     ''
        'R3', 'AB''CD''E', ''
        'R4', 'ACEBD',     '(WCM-I)' };

doExport = true;                                  % exportar .svg
outDir   = fileparts(mfilename('fullpath'));      % carpeta ANALYSIS/SEW_WCM

% Estilo
colPh = [0.15 0.15 0.15];      % magnitudes de fase
colI  = [0.16 0.47 0.85];      % corrientes de rama
colV  = [0.93 0.40 0.20];      % tensiones de rama
fs    = 18;                    % tamaño de fuente
fn    = 'Times New Roman';

a  = 2*pi/5;
ph = exp(-1j*a*(0:4));         % fasores unitarios a..e
phName = 'abcde';

fprintf('%-4s %-9s %8s %10s %10s %10s %7s %22s\n', 'Cls', 'WCM', 'delta', ...
        '|iL| int', '|iL| ext', 'Vph/VL', 'k', 'fp L1..L6');

for c = 1:size(WCM,1)
    cls  = WCM{c,1};
    name = WCM{c,2};
    [p, s] = parseWCM(name);

    %% Corrientes
    iw = s .* ph(p+1);                    % corriente efectiva de cada devanado
    iL = [iw(1), diff(iw), -iw(5)];       % corrientes de rama L1..L6

    %% Tensiones
    % Nudos de la cadena (vL1 = 0 provisional): N(k+1) = N(k) - s_k*v_pk
    N = [0, -cumsum(iw)];
    % Centro c0 equidistante de todos los nudos: 2*Re(conj(c0)*N) = |N|^2
    A  = [2*real(N(2:end)).', 2*imag(N(2:end)).'];
    b  = abs(N(2:end)).'.^2;
    xy = A \ b;  c0 = xy(1) + 1j*xy(2);
    R  = abs(N(1) - c0);                  % tensión de rama con fase de 1 pu
    vL  = (N - c0)/R;                     % tensiones de rama L1..L6 (1 pu)
    vph = ph/R;                           % tensiones de fase a..e

    %% Indicadores
    delta = rad2deg(angle(iw(2:5)./iw(1:4)));
    Iint  = max(abs(iL(2:5)));
    Iext  = max(abs(iL([1 6])));
    Vr    = 1/R;
    kk    = Vr / max(abs(iL));
    fp    = cos(angle(vL) - angle(iL));
    fprintf('%-4s %-9s %8.0f %10.3f %10.3f %10.3f %7.3f   %s\n', cls, name, ...
            abs(delta(1)), Iint, Iext, Vr, kk, sprintf('%5.2f', fp));
    printEquations(p, s, phName);

    %% Figura
    lim = 1.3*max([abs(iL), 1, abs(vph), 1]);

    f = figure('Color','w','Position',[60 60 1300 640],'Name',[cls ' ' name]);
    t = tiledlayout(f,1,2,'TileSpacing','compact','Padding','compact');
    title(t, {sprintf('%s  %s:  \\delta = %d°,  |i_{L,int}| = %.3f pu,  V_{ph}/V_{L} = %.3f,  k = %.3f', ...
                      cls, strtrim([name ' ' WCM{c,3}]), round(abs(delta(1))), Iint, Vr, kk), ...
              '\color[rgb]{0.4 0.4 0.4}Negro: fase (i_{ph} = 1 pu)  ·  color: rama (v_L = 1 pu)'}, ...
          'FontName', fn, 'FontSize', fs);

    % Corrientes: fases primero (se dibujan encima y dan nombre a las coincidencias)
    nexttile; hold on
    zI   = [ph, iL];
    lblI = [arrayfun(@(k) ['i_' phName(k)], 1:5, 'UniformOutput', false), ...
            arrayfun(@(k) sprintf('i_{L%d}', k), 1:6, 'UniformOutput', false)];
    colsI = [repmat(colPh,5,1); repmat(colI,6,1)];
    lwI   = [2*ones(1,5), 1.6*ones(1,6)];
    drawPanel(zI, lblI, colsI, lwI, [1, Iint], [], colI, lim, fs, fn)
    title('Corrientes', 'FontName', fn, 'FontSize', fs)

    % Tensiones
    nexttile; hold on
    zV   = [vph, vL];
    lblV = [arrayfun(@(k) ['v_' phName(k)], 1:5, 'UniformOutput', false), ...
            arrayfun(@(k) sprintf('v_{L%d}', k), 1:6, 'UniformOutput', false)];
    colsV = [repmat(colPh,5,1); repmat(colV,6,1)];
    drawPanel(zV, lblV, colsV, lwI, [1, Vr], vL, colV, lim, fs, fn)
    title('Tensiones', 'FontName', fn, 'FontSize', fs)

    if doExport
        exportSVG(f, fullfile(outDir, sprintf('WCM_%s_%s.svg', cls, strrep(name,'''','p'))))
    end
end


%% ========================================================================
function [p, s] = parseWCM(str)
% 'AC''EB''D' -> p = [0 2 4 1 3] (A=0..E=4), s = [1 -1 1 -1 1]
p = []; s = [];
for ch = str
    if ch == ''''
        s(end) = -1;
    else
        p(end+1) = upper(ch) - 'A'; %#ok<AGROW>
        s(end+1) = 1;               %#ok<AGROW>
    end
end
end

function printEquations(p, s, phName)
% Expresiones de corrientes de rama y tensiones de fase (como en WCM_evaluation.m)
sg1 = @(sg) repmat('-', 1, sg < 0);                    % signo del primer término
sg2 = @(sg) char(' + '*(sg > 0) + ' - '*(sg < 0));     % signo de los siguientes
nm  = @(k) ['i' phName(p(k)+1)];
eqI = cell(1,6);
eqI{1} = ['il1 = ' sg1(s(1)) nm(1)];
for k = 2:5
    eqI{k} = sprintf('il%d = %s%s%s%s', k, sg1(s(k)), nm(k), sg2(-s(k-1)), nm(k-1));
end
eqI{6} = ['il6 = ' sg1(-s(5)) nm(5)];
eqV = cell(1,5);
for k = 1:5
    if s(k) > 0
        eqV{k} = sprintf('v%c = vl%d - vl%d', phName(p(k)+1), k, k+1);
    else
        eqV{k} = sprintf('v%c = -vl%d + vl%d', phName(p(k)+1), k, k+1);
    end
end
fprintf('       %s\n', strjoin(eqI, ';  '));
fprintf('       %s\n\n', strjoin(eqV, ';  '));
end

function drawPanel(z, lbl, col, lw, radii, polyPts, polyCol, lim, fs, fn)
% Dibuja fasores con etiquetas, circunferencias de referencia y poligonal.
axis equal; axis off
xlim([-lim lim]); ylim([-lim lim])
th   = linspace(0, 2*pi, 400);
grey = [0.6 0.6 0.6];
hl = 0.06*lim;  hw = 0.022*lim;          % cabeza de flecha
off = 0.07*lim;                          % separación etiqueta-punta

% Circunferencias de referencia
radii = uniquetol(radii, 1e-6);
for r = radii
    plot(r*cos(th), r*sin(th), '--', 'Color', grey, 'LineWidth', 0.8)
end

% Poligonal por las puntas de las tensiones de rama (L1 -> L6)
if ~isempty(polyPts)
    plot(real(polyPts), imag(polyPts), '--', 'Color', 0.45*polyCol + 0.55, 'LineWidth', 1)
end

% Vectores: los últimos primero, para que las fases queden encima
n = numel(z);
for k = n:-1:1
    myVector(0, z(k), col(k,:), lw(k), hl, hw)
end

% Fusionar etiquetas de vectores coincidentes (p. ej. i_a = i_{L1})
show = true(1,n);  txt = lbl;
for k = 2:n
    for m = 1:k-1
        if show(m) && abs(z(k) - z(m)) < 1e-6
            txt{m} = [txt{m} ' = ' lbl{k}];
            show(k) = false;
            break
        end
    end
end

% Posición de cada etiqueta: prolongando el vector; si es colineal con otro
% más largo, al lado de la punta (desplazada en perpendicular)
ang = angle(z);  mag = abs(z);  la = ang;
idx = find(show);
side = false(1,n);
for a = idx
    for b = 1:n
        if a ~= b && abs(angle(exp(1j*(ang(a) - ang(b))))) < deg2rad(8) && mag(a) < mag(b) - 1e-6
            side(a) = true;
        end
    end
end
pos = (mag + off) .* exp(1j*la);
for a = find(side)
    pos(a) = z(a) * (1 - 0.5*off/mag(a)) + 1.3*off * exp(1j*(ang(a) + pi/2));
    la(a)  = ang(a) + pi/2;
end
% Separar etiquetas que quedan demasiado cerca
for it = 1:30
    moved = false;
    for a = idx
        for b = idx
            if a < b && abs(pos(a) - pos(b)) < 0.16*lim
                if side(a) && side(b), continue, end
                if side(a), m = b; elseif side(b), m = a;
                elseif mag(a) <= mag(b), m = a; else, m = b; end
                la(m) = la(m) + deg2rad(6);
                pos(m) = (mag(m) + off) * exp(1j*la(m));
                moved = true;
            end
        end
    end
    if ~moved, break, end
end

for k = idx
    [ha, va] = alignFor(la(k));    text(real(pos(k)), imag(pos(k)), txt{k}, 'Interpreter', 'tex', ...
         'FontSize', fs, 'FontName', fn, 'Color', col(k,:), ...
         'HorizontalAlignment', ha, 'VerticalAlignment', va)
end

% Etiquetas de radio: en la dirección más alejada de vectores y etiquetas
obst = [ang(:); angle(pos(idx)).'];
cand = deg2rad(0:2:358);
rs = sort(radii, 'descend');
for r = rs
    d = min(abs(angle(exp(1j*(cand - obst)))), [], 1);
    [~, ib] = max(d);
    tb = cand(ib);
    obst = [obst; tb]; %#ok<AGROW>
    [ha, va] = alignFor(tb);
    rr = r + 0.02*lim;
    if abs(r - 1) < 1e-6, s = '1 pu'; else, s = sprintf('%.3f pu', r); end
    text(rr*cos(tb), rr*sin(tb), s, 'Interpreter', 'tex', ...
         'FontSize', 0.8*fs, 'FontName', fn, 'Color', grey, ...
         'HorizontalAlignment', ha, 'VerticalAlignment', va)
end
end

function [ha, va] = alignFor(t)
c = cos(t);  s = sin(t);
if c > 0.35, ha = 'left'; elseif c < -0.35, ha = 'right'; else, ha = 'center'; end
if s > 0.35, va = 'bottom'; elseif s < -0.35, va = 'top'; else, va = 'middle'; end
end
