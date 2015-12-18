function [reg_type,myfit]=as_make_curve_fitting(reg_type,control_axon_diameters,control_gRatios)
% Example :
% [reg_type,myfit]=as_make_curve_fitting('log',cat(1,axonlist.axonEquivDiameter),cat(1,axonlist.gRatio));

if strcmp(reg_type,'log')
    myfittype = fittype('b + a*log(x)','dependent',{'y'},'independent',{'x'},'coefficients',{'b','a'});   
elseif strcmp(reg_type,'lin')
    myfittype = fittype('b + a*x','dependent',{'y'},'independent',{'x'},'coefficients',{'b','a'});
end

myfit = fit(control_axon_diameters,control_gRatios,myfittype);

end