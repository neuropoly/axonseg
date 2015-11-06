


DA_type = {'linear','quadratic'};


% bar_names={'gRatio','axonEquivDiameter','myelinEquivDiameter','myelinThickness','myelinArea','axonArea'};
% bar_names=cell2mat(bar_names);

bar_names=[1 2 3 4 5 6];


[Index_noDA, Stats_noDA] = as_stats_Roi(axonlist, img);
[Index_DA_L Stats_DA_L] = as_stats_Roi(axonlist, img);
[Index_DA_Q Stats_DA_Q] = as_stats_Roi(axonlist, img);


stats1=get_mean_stats(Stats_noDA);
stats2=get_mean_stats(Stats_DA_L);
stats3=get_mean_stats(Stats_DA_Q);

bar(bar_names,[stats1(1) stats2(1) stats3(1) ; stats1(2) stats2(2) stats3(2) ; stats1(3) stats2(3) stats3(3);stats1(4) stats2(4) stats3(4) ;...
    stats1(5) stats2(5) stats3(5); stats1(6) stats2(6) stats3(6)]);

legend('no DA','DA linear','DA quadratic');






