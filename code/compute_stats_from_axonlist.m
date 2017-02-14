function mask_stats=compute_stats_from_axonlist(axonlist,PixelSize,img)

mask_stats.axon_diam_mean=mean(cat(1,axonlist.axonEquivDiameter));
mask_stats.axon_diam_median=median(cat(1,axonlist.axonEquivDiameter));
mask_stats.axon_diam_std=std(cat(1,axonlist.axonEquivDiameter));

mask_stats.myelin_diam_mean=mean(cat(1,axonlist.myelinEquivDiameter));
mask_stats.myelin_diam_median=median(cat(1,axonlist.myelinEquivDiameter));
mask_stats.myelin_diam_std=std(cat(1,axonlist.myelinEquivDiameter));

mask_stats.myelin_thickness_mean=mean(cat(1,axonlist.myelinThickness));
mask_stats.myelin_thickness_median=median(cat(1,axonlist.myelinThickness));
mask_stats.myelin_thickness_std=std(cat(1,axonlist.myelinThickness));

mask_stats.gRatio_mean=mean(cat(1,axonlist.gRatio));
mask_stats.gRatio_median=median(cat(1,axonlist.gRatio));
mask_stats.gRatio_std=std(cat(1,axonlist.gRatio));
  
mask_stats.nbr_of_axons=size(axonlist,2);
    
mask_area_pix=size(img,1)*size(img,2);
mask_area_mm2=mask_area_pix*(PixelSize/1000)^2;
mask_area_um2=mask_area_pix*PixelSize^2;

mask_stats.density_per_mm2=mask_stats.nbr_of_axons/mask_area_mm2;
    
axon_area=sum(cat(1,axonlist.axonArea));
mask_stats.AVF=axon_area/mask_area_um2;

myelin_area=sum(cat(1,axonlist.myelinArea));
mask_stats.MVF=myelin_area/mask_area_um2;

mask_stats.FVF=mask_stats.MVF+mask_stats.AVF;
mask_stats.FR=mask_stats.AVF/(1-mask_stats.MVF);