function plot_mask_stat(mask_stats,stat_name,P_color)
 
figure();
cont=0;
for i=1:size(mask_stats,2)
    cont=cont+1;
    
    bar(cont,stat_name,'FaceColor',P_color(i,:)/255);
    hold on;
end

title('stat_name');
xlabel('Regions');
ylabel('stat_name');

hold off;








