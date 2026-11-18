function exportSVG(miax,fil)
%EXPORTSVG Summary of this function goes here
%   
fig = ancestor(miax,'figure');

% Guardar estado original
figColor = fig.Color;
invHC = fig.InvertHardcopy;
renderer0 = fig.Renderer;

ax = findall(fig,'Type','axes');
axColors = cell(numel(ax),1);

for k = 1:numel(ax)
    axColors{k} = ax(k).Color;
end

% Preparar para SVG transparente
set(fig,'Renderer','painters');
set(fig,'Color','none');
set(fig,'InvertHardcopy','off');

for k = 1:numel(ax)
    ax(k).Color = 'none';
end

% Exportar
file = fullfile(fil);
print(fig, file, '-dsvg', '-painters');

% Restaurar estado original
fig.Color = figColor;
fig.InvertHardcopy = invHC;
fig.Renderer = renderer0;

for k = 1:numel(ax)
    ax(k).Color = axColors{k};
end

end

