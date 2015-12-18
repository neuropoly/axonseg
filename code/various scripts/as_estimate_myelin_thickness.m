function Estimated_MyelinThickness=as_estimate_myelin_thickness(reg_type,myfit,axon_diameters)
% Example :
% Estimated_MyelinThickness=as_estimate_myelin_thickness(reg_type,myfit,cat(1,axonlist.axonEquivDiameter));

a=myfit.a;
b=myfit.b;

if strcmp(reg_type,'log')
    Estimated_gRatios=a*log(axon_diameters)+b;    
elseif strcmp(reg_type,'lin')
    Estimated_gRatios=a*axon_diameters+b;
end

Estimated_MyelinThickness=(axon_diameters./Estimated_gRatios)-axon_diameters;

end
