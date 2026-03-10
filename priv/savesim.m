function savesim(file, Machine, CtrlSchem, activate)

if activate == 1
    vars = {'CONTROL','timeL','Iphase','Idq','Idq_ref','Iab','Iab_ref','Speed','Te_ref','Fsw'};
    for k = 1:numel(vars), eval([vars{k} ' = evalin(''base'', vars{k});']); end
    
    
    if strcmp(Machine, 'Lille5Ph') && strcmp(CtrlSchem, 'MPC')
        vars = {'Kd','Kx','Ky','Kh'};
        for k = 1:numel(vars), PARAM.CF.(vars{k}) = CONTROL.(vars{k}); end
        vars = {'Rs','Ld','Lq','Lx','Ly','Lh','P','Phase','Lambda','Lambda3','Lambda5'};
        for k = 1:numel(vars), PARAM.MOTOR.(vars{k}) = CONTROL.(vars{k}); end
        PARAM.VEl = CONTROL.VEL;
        PARAM.KALMAN = CONTROL.KALMAN;
    end
    
    var = {'PARAM','timeL','Iphase','Idq','Idq_ref','Iab','Iab_ref','Speed','Te_ref','Fsw'};
    save(['RESULTS\',Machine,'\',file], var{:})
    
    disp(['Sim save: ',file])



else
    disp('Simulation data not saved.')
end
end

