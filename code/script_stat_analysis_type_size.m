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

[false_cluster1,false_cluster2]=as_clustering(FALSE);
subplot(121);
imshow(false_cluster1);
subplot(122);
imshow(false_cluster2);


imshow(imfuse(false_cluster1,false_cluster2));
imshow(imfuse(true_cluster1,true_cluster2));

% stats for each cluster

Stats_true_1=as_stats_axons(true_cluster1,gray);
Stats_true_2=as_stats_axons(true_cluster2,gray);
Stats_false_1=as_stats_axons(false_cluster1,gray);
Stats_false_2=as_stats_axons(false_cluster2,gray);

Stats_true_1=table2array(struct2table(Stats_true_1));
Stats_true_2=table2array(struct2table(Stats_true_2));
Stats_false_1=table2array(struct2table(Stats_false_1));
Stats_false_2=table2array(struct2table(Stats_false_2));

means_true_1=mean(Stats_true_1,1);
std_true_1=std(Stats_true_1,1);

means_true_2=mean(Stats_true_2,1);
std_true_2=std(Stats_true_2,1);

means_false_1=mean(Stats_false_1,1);
std_false_1=std(Stats_false_1,1);

means_false_2=mean(Stats_false_2,1);
std_false_2=std(Stats_false_2,1);

figure;

for i=1:18
    
subplot(3,6,i);
bar([1 2 3 4],[means_true_1(i) means_true_2(i) means_false_1(i) means_false_2(i)]);
hold on
errorbar([1 2 3 4],[means_true_1(i) means_true_2(i) means_false_1(i) means_false_2(i)],[std_true_1(i) std_true_2(i) std_false_1(i) std_false_2(i)],'rx');
   
    
    
end




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



















