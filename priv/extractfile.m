function TEST = extractfile(file)
%EXTRACTFILE Summary of this function goes here

% Separar por "_"
parts = split(file, '_');

% Asignar variables
TEST.Topology   = parts{1};
TEST.CtrlSchem  = parts{2};

% Extraer números eliminando texto
TEST.Vdc   = sscanf(parts{3}, '%dVdc');
TEST.Freq  = sscanf(parts{4}, '%dkHz');
TEST.speed = sscanf(parts{5}, '%drpm');
TEST.Tload = sscanf(parts{6}, '%dNm' );

end

