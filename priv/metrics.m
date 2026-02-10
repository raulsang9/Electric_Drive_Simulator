function METRICS = metrics(Machine, data, ind1, ind2)
%METRICS Summary of this function goes here
%  

if strcmp(Machine, 'Lille5Ph')

    % RMS Matlab
    METRICS.RMS = mean([rms(data.Iphase(ind1:ind2,1)) rms(data.Iphase(ind1:ind2,2)) rms(data.Iphase(ind1:ind2,3)) rms(data.Iphase(ind1:ind2,4)) rms(data.Iphase(ind1:ind2,5))]);

    % THD Matlab
    f_meas = 1/data.timeL(2); nmax = 10e3;
    METRICS.THDmat.ia = 100*10^(thd(data.Iphase(ind1:ind2,1),f_meas,nmax)/20);
    METRICS.THDmat.ib = 100*10^(thd(data.Iphase(ind1:ind2,2),f_meas,nmax)/20);
    METRICS.THDmat.ic = 100*10^(thd(data.Iphase(ind1:ind2,3),f_meas,nmax)/20);
    METRICS.THDmat.id = 100*10^(thd(data.Iphase(ind1:ind2,4),f_meas,nmax)/20);
    METRICS.THDmat.ie = 100*10^(thd(data.Iphase(ind1:ind2,5),f_meas,nmax)/20);
    METRICS.THDmat.mean = mean([METRICS.THDmat.ia METRICS.THDmat.ib METRICS.THDmat.ic METRICS.THDmat.id METRICS.THDmat.ie]);
    
    % STANDARD DESVIATION
    METRICS.STD.idq = mean([std(data.Idq(:,1)) std(data.Idq(:,2))]);
    METRICS.STD.ixy = mean([std(data.Iab(:,3)) std(data.Iab(:,4))]);
    METRICS.STD.ih  = std(data.Iab(:,5));
    
    % SWITCHING FREQUENCY
    METRICS.fsw = data.Fsw(end);
    
    % % NULL VECTORS
    % count = sum(data.vectores == 1);
    % METRICS.p100nulo = 100*count/length(data.vectores);
end

end

