function as_stats_barplot_2(mask_stats,P_color)

 if ~exist('P_color','var')
     
     P_color = zeros(size(mask_stats,2),3);
     P_color(:,3) = [128, 128, 128];
     
 end

figure(1);
cont=0;
for i=1:size(mask_stats,2)
    cont=cont+1;
    bar(cont,mask_stats(i).axon_diam_mean,'FaceColor',P_color(i,:)/255);
    hold on;
end

title('Axon Equivalent Diameter for each region');
xlabel('Regions');
ylabel('Axon Equivalent Diameter');

hold off;

% 
% bar([1 2 3],[mask_stats(1).axon_diam_mean; mask_stats(2).axon_diam_mean; mask_stats(3).axon_diam_mean],'FaceColor',P_color(i,:)/255);
% hold on
% errorbar([1 2 3],[mask_stats(1).axon_diam_mean; mask_stats(2).axon_diam_mean; mask_stats(3).axon_diam_mean]...
%     ,[mask_stats(1).axon_diam_std; mask_stats(2).axon_diam_std; mask_stats(3).axon_diam_std],'rx');
% 

figure(2);
cont=0;
for i=1:size(mask_stats,2)
    cont=cont+1;
    bar(cont,mask_stats(i).myelin_diam_mean,'FaceColor',P_color(i,:)/255);
    hold on;
end

title('Myelin Equivalent Diameter for each region');
xlabel('Regions');
ylabel('Myelin Equivalent Diameter');

hold off;

figure(3);
cont=0;
for i=1:size(mask_stats,2)
    cont=cont+1;
    bar(cont,mask_stats(i).myelin_thickness_mean,'FaceColor',P_color(i,:)/255);
    hold on;
end

title('Myelin Thickness for each region');
xlabel('Regions');
ylabel('Myelin Thickness');

hold off;

figure(4);
cont=0;
for i=1:size(mask_stats,2)
    cont=cont+1;
    bar(cont,mask_stats(i).gRatio_mean,'FaceColor',P_color(i,:)/255);
    hold on;
end

title('gRatio for each region');
xlabel('Regions');
ylabel('gRatio');

hold off;

figure(5);
cont=0;
for i=1:size(mask_stats,2)
    cont=cont+1;
    bar(cont,mask_stats(i).nbr_of_axons,'FaceColor',P_color(i,:)/255);
    hold on;
end

title('Number of Axons for each region');
xlabel('Regions');
ylabel('Number of Axons');

hold off;

figure(6);
cont=0;
for i=1:size(mask_stats,2)
    cont=cont+1;
    bar(cont,mask_stats(i).density_per_mm2,'FaceColor',P_color(i,:)/255);
    hold on;
end

title('Density per mm^2 for each region');
xlabel('Regions');
ylabel('Density per mm^2');

hold off;

figure(7);
cont=0;
for i=1:size(mask_stats,2)
    cont=cont+1;
    bar(cont,mask_stats(i).AVF,'FaceColor',P_color(i,:)/255);
    hold on;
end

title('AVF for each region');
xlabel('Regions');
ylabel('AVF');

hold off;

figure(8);
cont=0;
for i=1:size(mask_stats,2)
    cont=cont+1;
    bar(cont,mask_stats(i).MVF,'FaceColor',P_color(i,:)/255);
    hold on;
end

title('MVF for each region');
xlabel('Regions');
ylabel('MVF');

hold off;












