function stats=get_mean_stats(Stats_str)

stats(1)=mean(Stats_str.gRatio);
stats(2)=mean(Stats_str.axonEquivDiameter);
stats(3)=mean(Stats_str.myelinEquivDiameter);
stats(4)=mean(Stats_str.myelinThickness);
stats(5)=mean(Stats_str.myelinArea);
stats(6)=mean(Stats_str.axonArea);
stats(7)=size(cat(1,Stats_str.gRatio),1);

end
