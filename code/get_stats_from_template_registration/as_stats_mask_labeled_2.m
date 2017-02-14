function [indexes,mask_stats]=as_stats_mask_labeled_2(axonlist, mask_reg_labeled,PixelSize)


max_regions = max(max(mask_reg_labeled));
Centroid=cat(1,axonlist.Centroid);

for i=1:max_regions
    P=mask2poly(mask_reg_labeled==i,'Inner','CW');

    Centroidx=Centroid(:,1);
    Centroidy=Centroid(:,2);

    Px=P(:,1);
    Py=P(:,2);

Px=downsample(Px,100);
Py=downsample(Py,100);

indexes{i}=inpolygon(Centroidx,Centroidy,Px,Py);
mask_area_pix{i}=nnz(mask_reg_labeled==i);
mask_area_mm2{i}=mask_area_pix{i}*(PixelSize/1000)^2;
mask_area_um2{i}=mask_area_pix{i}*PixelSize^2;
% indexes{i}=inpolygon(Centroidx,Centroidy,Px*reduced,Py*reduced);

end

mask_stats(size(indexes,2))=struct();

for i=1:size(indexes,2)
    
    mask_stats(i).axon_diam_mean=mean(cat(1,axonlist(indexes{i}).axonEquivDiameter));
    mask_stats(i).axon_diam_median=median(cat(1,axonlist(indexes{i}).axonEquivDiameter));
    mask_stats(i).axon_diam_std=std(cat(1,axonlist(indexes{i}).axonEquivDiameter));
    
    mask_stats(i).myelin_diam_mean=mean(cat(1,axonlist(indexes{i}).myelinEquivDiameter));
    mask_stats(i).myelin_diam_median=median(cat(1,axonlist(indexes{i}).myelinEquivDiameter));
    mask_stats(i).myelin_diam_std=std(cat(1,axonlist(indexes{i}).myelinEquivDiameter));

    mask_stats(i).myelin_thickness_mean=mean(cat(1,axonlist(indexes{i}).myelinThickness));
    mask_stats(i).myelin_thickness_median=median(cat(1,axonlist(indexes{i}).myelinThickness));
    mask_stats(i).myelin_thickness_std=std(cat(1,axonlist(indexes{i}).myelinThickness));

    mask_stats(i).gRatio_mean=mean(cat(1,axonlist(indexes{i}).gRatio));
    mask_stats(i).gRatio_median=median(cat(1,axonlist(indexes{i}).gRatio));
    mask_stats(i).gRatio_std=std(cat(1,axonlist(indexes{i}).gRatio));
    
    mask_stats(i).axon_diam_distribution=cat(1,axonlist(indexes{i}).axonEquivDiameter);
    mask_stats(i).myelin_diam_distribution=cat(1,axonlist(indexes{i}).myelinEquivDiameter);
    mask_stats(i).myelin_thickness_distribution=cat(1,axonlist(indexes{i}).myelinThickness);
    mask_stats(i).gRatio_distribution=cat(1,axonlist(indexes{i}).gRatio);
    
    mask_stats(i).nbr_of_axons=sum(indexes{i});
    
    mask_stats(i).density_per_mm2=mask_stats(i).nbr_of_axons/mask_area_mm2{i};
    
    axon_area=sum(cat(1,axonlist(indexes{i}).axonArea));
    mask_stats(i).AVF=axon_area/mask_area_um2{i};

    myelin_area=sum(cat(1,axonlist(indexes{i}).myelinArea));
    mask_stats(i).MVF=myelin_area/mask_area_um2{i};
    
    mask_stats(i).FVF=mask_stats(i).MVF+mask_stats(i).AVF;
    mask_stats(i).FR=mask_stats(i).AVF/(1-mask_stats(i).MVF);
        
end
















