% script_stat_analysis by axon population (true (small or big) vs false)


img_path_1 = uigetimagefile;
TRUE = imread(img_path_1);

img_path_2 = uigetimagefile;
FALSE = imread(img_path_2);

img_path_3 = uigetimagefile;
gray = imread(img_path_3);


Stats_true=as_stats_axons(TRUE,gray);
Stats_false=as_stats_axons(FALSE,gray);

Stats_true=table2array(struct2table(Stats_true));
Stats_false=table2array(struct2table(Stats_false));

means_true=mean(Stats_true,1);
std_true=std(Stats_true,1);

means_false=mean(Stats_false,1);
std_false=std(Stats_false,1);


figure;

for i=1:18
    
subplot(3,6,i);
bar([means_true(i) means_false(i)]);
hold on
errorbar([means_true(i) means_false(i)],[std_true(i) std_false(i)],'rx');
     
end


% Make 2 clusters for true axons

[true_cluster1,true_cluster2]=as_clustering(TRUE);
subplot(121);
imshow(true_cluster1);
subplot(122);
imshow(true_cluster2);

true_cluster1=TRUE;

[false_cluster1,false_cluster2]=as_clustering(FALSE);
subplot(121);
imshow(false_cluster1);
subplot(122);
imshow(false_cluster2);


imshow(imfuse(false_cluster1,false_cluster2));
imshow(imfuse(true_cluster1,true_cluster2));

% stats for each cluster

Stats_true_1=as_stats_axons(true_cluster1,gray);
% Stats_true_2=as_stats_axons(true_cluster2,gray);
Stats_false_1=as_stats_axons(false_cluster1,gray);
Stats_false_2=as_stats_axons(false_cluster2,gray);

Stats_true_1=table2array(struct2table(Stats_true_1));
% Stats_true_2=table2array(struct2table(Stats_true_2));
Stats_false_1=table2array(struct2table(Stats_false_1));
Stats_false_2=table2array(struct2table(Stats_false_2));

means_true_1=mean(Stats_true_1,1);
std_true_1=std(Stats_true_1,1);

% means_true_2=mean(Stats_true_2,1);
% std_true_2=std(Stats_true_2,1);

means_false_1=mean(Stats_false_1,1);
std_false_1=std(Stats_false_1,1);

means_false_2=mean(Stats_false_2,1);
std_false_2=std(Stats_false_2,1);

figure;

for i=1:22
    
subplot(4,6,i);
bar([1 2 3],[means_true_1(i); means_false_1(i); means_false_2(i)]);
hold on
errorbar([1 2 3],[means_true_1(i); means_false_1(i); means_false_2(i)],[std_true_1(i); std_false_1(i); std_false_2(i)],'rx');
   
    
    
end


%% FIGURE FINALE shapes

figure(1);


% equiv diam    
subplot(1,6,1);
b=bar([1 2 3],[means_true_1(4); means_false_1(4); means_false_2(4)],'hist');
hold on
errorbar([1 2 3],[means_true_1(4); means_false_1(4); means_false_2(4)],[std_true_1(4); std_false_1(4); std_false_2(4)],'rx');
set(b(1),'facecolor','black');


% circularity
subplot(1,6,2);
bar([1 2 3],[means_true_1(3); means_false_1(3); means_false_2(3)]);
hold on
errorbar([1 2 3],[means_true_1(3); means_false_1(3); means_false_2(3)],[std_true_1(3); std_false_1(3); std_false_2(3)],'rx');
    
% solidity
subplot(1,6,3);
bar([1 2 3],[means_true_1(5); means_false_1(5); means_false_2(5)]);
hold on
errorbar([1 2 3],[means_true_1(5); means_false_1(5); means_false_2(5)],[std_true_1(5); std_false_1(5); std_false_2(5)],'rx');

% ellipticity
subplot(1,6,4);
bar([1 2 3],[means_true_1(8); means_false_1(8); means_false_2(8)]);
hold on
errorbar([1 2 3],[means_true_1(8); means_false_1(8); means_false_2(8)],[std_true_1(8); std_false_1(8); std_false_2(8)],'rx');

% ppchratio
subplot(1,6,5);
bar([1 2 3],[means_true_1(15); means_false_1(15); means_false_2(15)]);
hold on
errorbar([1 2 3],[means_true_1(15); means_false_1(15); means_false_2(15)],[std_true_1(15); std_false_1(15); std_false_2(15)],'rx');

% aachratio
subplot(1,6,6);
bar([1 2 3],[means_true_1(16); means_false_1(16); means_false_2(16)]);
hold on
errorbar([1 2 3],[means_true_1(16); means_false_1(16); means_false_2(16)],[std_true_1(16); std_false_1(16); std_false_2(16)],'rx');



%% figure intensities

figure(2);

% object mean
subplot(1,5,1);
bar([1 2 3],[means_true_1(17); means_false_1(17); means_false_2(17)]);
hold on
errorbar([1 2 3],[means_true_1(17); means_false_1(17); means_false_2(17)],[std_true_1(17); std_false_1(17); std_false_2(17)],'rx');
    
% object std
subplot(1,5,2);
bar([1 2 3],[means_true_1(18); means_false_1(18); means_false_2(18)]);
hold on
errorbar([1 2 3],[means_true_1(18); means_false_1(18); means_false_2(18)],[std_true_1(18); std_false_1(18); std_false_2(18)],'rx');

% neighbour mean
subplot(1,5,3);
bar([1 2 3],[means_true_1(19); means_false_1(19); means_false_2(19)]);
hold on
errorbar([1 2 3],[means_true_1(19); means_false_1(19); means_false_2(19)],[std_true_1(19); std_false_1(19); std_false_2(19)],'rx');

% neighbour std
subplot(1,5,4);
bar([1 2 3],[means_true_1(20); means_false_1(20); means_false_2(20)]);
hold on
errorbar([1 2 3],[means_true_1(20); means_false_1(20); means_false_2(20)],[std_true_1(20); std_false_1(20); std_false_2(20)],'rx');

% contrast between neighbour & axon candidate
subplot(1,5,5);
bar([1 2 3],[means_true_1(22); means_false_1(22); means_false_2(22)]);
hold on
errorbar([1 2 3],[means_true_1(22); means_false_1(22); means_false_2(22)],[std_true_1(22); std_false_1(22); std_false_2(22)],'rx');


%% graph circularity, solidity, ellipticity


model_series = [means_true_1(3) means_false_1(3) means_false_2(3); means_true_1(5) means_false_1(5) means_false_2(5); means_true_1(8) means_false_1(8) means_false_2(8)];
model_error = [std_true_1(3) std_false_1(3) std_false_2(3); std_true_1(5) std_false_1(5) std_false_2(5); std_true_1(8) std_false_1(8) std_false_2(8)];
h = bar(model_series);
set(h,'BarWidth',1);    % The bars will now touch each other
set(gca,'YGrid','on')
set(gca,'GridLineStyle','--')
set(gca,'XTicklabel','Circularity|Solidity|Ellipticity','FontSize', 14)
set(get(gca,'YLabel'),'String','Ratio Metric','FontSize', 14)
lh = legend('True Axons','False Axons 1','False Axons 2');
set(lh,'Location','Best')
hold on;
numgroups = size(model_series, 1); 
numbars = size(model_series, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none');
end

set(h(1),'facecolor','green');
set(h(2),'facecolor','red');
set(h(3),'facecolor','blue');


%% graph equiv diameter


model_series = [means_true_1(4) means_false_1(4) means_false_2(4)];
model_error = [std_true_1(4) std_false_1(4) std_false_2(4)];
h = bar(model_series);
set(h,'BarWidth',1);    % The bars will now touch each other
set(gca,'YGrid','on')
set(gca,'GridLineStyle','--')
set(gca,'XTicklabel','Equivalent Diameter','FontSize', 14)
set(get(gca,'YLabel'),'String','Number of pixels','FontSize', 14)
lh = legend('True Axons','False Axons 1','False Axons 2');
set(lh,'Location','Best')
hold on;
numgroups = size(model_series, 1); 
numbars = size(model_series, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none');
end

set(h(1),'facecolor','green');
set(h(2),'facecolor','red');
set(h(3),'facecolor','blue');


%% graph intensity based - means


model_series = [means_true_1(17) means_false_1(17) means_false_2(17); means_true_1(19) means_false_1(19) means_false_2(19); means_true_1(22) means_false_1(22) means_false_2(22)];
model_error = [std_true_1(17) std_false_1(17) std_false_2(17); std_true_1(19) std_false_1(19) std_false_2(19); std_true_1(22) std_false_1(22) std_false_2(22)];
h = bar(model_series);
set(h,'BarWidth',1);    % The bars will now touch each other
set(gca,'YGrid','on')
set(gca,'GridLineStyle','--')
set(gca,'XTicklabel','Axon candidate mean|Neighbourhood mean|Contrast','FontSize', 14)
set(get(gca,'YLabel'),'String','Intensity values (normalized between 0 and 1)','FontSize', 14)
lh = legend('True Axons','False Axons 1','False Axons 2');
set(lh,'Location','Best')
hold on;
numgroups = size(model_series, 1); 
numbars = size(model_series, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none');
end

set(h(1),'facecolor','green');
set(h(2),'facecolor','red');
set(h(3),'facecolor','blue');

%% graph intensity based - stds

model_series = [means_true_1(18) means_false_1(18) means_false_2(18); means_true_1(20) means_false_1(20) means_false_2(20)];
model_error = [std_true_1(18) std_false_1(18) std_false_2(18); std_true_1(20) std_false_1(20) std_false_2(20)];
h = bar(model_series);
set(h,'BarWidth',1);    % The bars will now touch each other
set(gca,'YGrid','on')
set(gca,'GridLineStyle','--')
set(gca,'XTicklabel','Axon candidate std|Neighbourhood std','FontSize', 14)
set(get(gca,'YLabel'),'String','Intensity values (normalized between 0 and 1)','FontSize', 14)
lh = legend('True Axons','False Axons 1','False Axons 2');
set(lh,'Location','Best')
hold on;
numgroups = size(model_series, 1); 
numbars = size(model_series, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none');
end

set(h(1),'facecolor','green');
set(h(2),'facecolor','red');
set(h(3),'facecolor','blue');




%%



figure;

for i=1:18
    
subplot(3,6,i);
bar([means_true(i) means_false(i)]);
hold on
errorbar([means_true(i) means_false(i)],[std_true(i) std_false(i)],'rx');
   
    
    
end



% subplot(241);
% bar([means_true(1) means_false(1)]);
% hold on
% errorbar([means_true(1) means_false(1)],[std_true(1) std_false(1)],'rx');
% 
% subplot(242);
% bar([means_true(2) means_false(2)]);
% hold on
% errorbar([means_true(2) means_false(2)],[std_true(2) std_false(2)],'rx');
% 
% subplot(243);
% bar([means_true(3) means_false(3)]);
% hold on
% errorbar([means_true(3) means_false(3)],[std_true(3) std_false(3)],'rx');
% 
% subplot(244);
% bar([means_true(3) means_false(3)]);
% hold on
% errorbar([means_true(3) means_false(3)],[std_true(3) std_false(3)],'rx');





%%




bar([1 2],[means_true(6) means_false(6); means_true(7) means_false(7)]);
hold on


errorbar([1 2],[means_true(6) means_false(6); means_true(7) means_false(7)],[std_true(6) std_false(6); std_true(7) std_false(7)]);


errorbar([means_true(6) means_false(6); means_true(7) means_false(7);means_true(8) means_false(8);means_true(9) means_false(9)], ...
    [std_true(6) std_false(6); std_true(7) std_false(7);std_true(8) std_false(8);std_true(9) std_false(9)],'rx');
hold on


%%

figure;
bar([means_true(6) means_false(6); means_true(7) means_false(7);means_true(8) means_false(8);means_true(9) means_false(9)]);
hold on
errorbar([means_true(6) means_false(6); means_true(7) means_false(7);means_true(8) means_false(8);means_true(9) means_false(9)], ...
    [std_true(6) std_false(6); std_true(7) std_false(7);std_true(8) std_false(8);std_true(9) std_false(9)],'rx');
hold on

bar(means_false(6:7));
hold on







errorbar(means_false(6:7), std_false(6:7),'rx');



figure;

subplot(1,4,1);
hist(means_true(1));
hold on;
errorbar(means_true(1),std_true(1));
hold on;

hist(means_false(1));
hold on;
errorbar(means_false(1),std_false(1));
hold off;






figure;
hist(data1);
hold on;
%//make data1 red
%//get the handle of the bars in a histogram
h = findobj(gca,'Type','patch');
%//color of the bar is red and the color of the border
%// of the bar is white!
set(h,'FaceColor','r','EdgeColor','w');
%//data 2 use default color!
hist(data2);



















