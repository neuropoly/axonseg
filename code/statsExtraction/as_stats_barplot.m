function as_stats_barplot(axonlist,indexes,P_color)

 if ~exist('P_color','var')
     
     P_color = zeros(size(indexes,2),3);
     P_color(:,3) = [128, 128, 128];
     
 end

figure(1);
cont=0;
for i=1:size(indexes,2)
    cont=cont+1;
    diam_mean=mean(cat(1,axonlist(indexes{i}).axonEquivDiameter));
    bar(cont,diam_mean,'FaceColor',P_color(i,:)/255);
    hold on;
end

title('Axon Equivalent Diameter MEAN for each region');
xlabel('Regions');
ylabel('Axon Equivalent Diameter MEAN');

hold off;

figure(2);
cont=0;
for i=1:size(indexes,2)
    cont=cont+1;
    diam_std=std(cat(1,axonlist(indexes{i}).axonEquivDiameter));
    bar(cont,diam_std,'FaceColor',P_color(i,:)/255);
    hold on;
end

title('Axon Equivalent Diameter STD for each region');
xlabel('Regions');
ylabel('Axon Equivalent Diameter STD');

hold off;

figure(3);
cont=0;
for i=1:size(indexes,2)
    cont=cont+1;
    number=sum(indexes{i});
    bar(cont,number,'FaceColor',P_color(i,:)/255);
    hold on;
end

title('Axon Number for each region');
xlabel('Regions');
ylabel('Axon Number');

hold off;


figure(4);
cont=0;
for i=1:size(indexes,2)
    cont=cont+1;
    gRatio=mean(cat(1,axonlist(indexes{i}).gRatio));
    bar(cont,gRatio,'FaceColor',P_color(i,:)/255);
    hold on;
end

title('gRatio for each region');
xlabel('Regions');
ylabel('gRatio');

hold off;

