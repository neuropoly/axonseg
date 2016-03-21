% images to use

img_path_1 = uigetimagefile;
img_BW_true = imread(img_path_1);
img_BW_true=im2bw(img_BW_true);

img_path_2 = uigetimagefile;
img_BW_false = imread(img_path_2);
img_BW_false=im2bw(img_BW_false);

img_path_3 = uigetimagefile;
img_gray = imread(img_path_3);

%% get the differences between dilations & original ones

% img_BW_dilated_true = imdilate(img_BW_true,se);
% figure, imshow(imfuse(img_BW_true,img_BW_dilated_true));
% 
% img_diff_true = im2bw(img_BW_dilated_true-img_BW_true);
% figure, imshow(img_diff_true);
% 
% 
% img_BW_dilated_false = imdilate(img_BW_false,se);
% figure, imshow(imfuse(img_BW_false,img_BW_dilated_false));
% 
% img_diff_false = im2bw(img_BW_dilated_false-img_BW_false);
% figure, imshow(img_diff_false);


%% calculation for true axons

[cc_initial,num1] = bwlabel(img_BW_true,8);
se = strel('disk',4);

Intensity_mean=zeros(num1,2);
Intensity_std=zeros(num1,2);
Skewness=zeros(num1,2);

Intensity_mean_axon=zeros(num1,2);
Intensity_std_axon=zeros(num1,2);

img_gray=im2double(img_gray);

for i=1:num1

    object_i=cc_initial==i;
    object_dilated_i=imdilate(object_i,se);
    diff_i=im2bw(object_dilated_i-object_i);
    
    Gray_object_i = img_gray(diff_i==1);
    Skewness(i,2)=skewness(Gray_object_i);
    
    Intensity_mean(i,1)=i;
    Intensity_std(i,1)=i;
    Skewness(i,1)=i;
    
    Intensity_mean(i,2)=mean(Gray_object_i);
    Intensity_std(i,2)=std(Gray_object_i);
    
    Gray_object_i_axon = img_gray(cc_initial==i);
    
    Intensity_mean_axon(i,1)=i;
    Intensity_std_axon(i,1)=i;
 
    Intensity_mean_axon(i,2)=mean(Gray_object_i_axon);
    Intensity_std_axon(i,2)=std(Gray_object_i_axon);

        
end

Contrast=zeros(num1,2);
Contrast(:,1)=Intensity_mean(:,1);
Contrast(:,2)=Intensity_mean(:,2)-Intensity_mean_axon(:,2);

Stats_true.MeanAxon=Intensity_mean_axon(:,2);
Stats_true.STDAxon=Intensity_std_axon(:,2);
Stats_true.MeanBoundary=Intensity_mean(:,2);
Stats_true.STDBoundary=Intensity_std(:,2);
Stats_true.Contrast=Contrast(:,2);
Stats_true.Skewness=Skewness(:,2);

%% calculation for false axons

[cc_initial,num1] = bwlabel(img_BW_false,8);
se = strel('disk',4);


Intensity_mean=zeros(num1,2);
Intensity_std=zeros(num1,2);
Skewness=zeros(num1,2);

Intensity_mean_axon=zeros(num1,2);
Intensity_std_axon=zeros(num1,2);

img_gray=im2double(img_gray);

for i=1:num1

    object_i=cc_initial==i;
    object_dilated_i=imdilate(object_i,se);
    diff_i=im2bw(object_dilated_i-object_i);
    
    Gray_object_i = img_gray(diff_i==1);
    Skewness(i,2)=skewness(Gray_object_i);
    
    Intensity_mean(i,1)=i;
    Intensity_std(i,1)=i;
    Skewness(i,1)=i;
    
    Intensity_mean(i,2)=mean(Gray_object_i);
    Intensity_std(i,2)=std(Gray_object_i);
    
    Gray_object_i_axon = img_gray(cc_initial==i);
    
    Intensity_mean_axon(i,1)=i;
    Intensity_std_axon(i,1)=i;
 
    Intensity_mean_axon(i,2)=mean(Gray_object_i_axon);
    Intensity_std_axon(i,2)=std(Gray_object_i_axon);
          
end

Contrast=zeros(num1,2);
Contrast(:,1)=Intensity_mean(:,1);
Contrast(:,2)=Intensity_mean(:,2)-Intensity_mean_axon(:,2);

Stats_false.MeanAxon=Intensity_mean_axon(:,2);
Stats_false.STDAxon=Intensity_std_axon(:,2);
Stats_false.MeanBoundary=Intensity_mean(:,2);
Stats_false.STDBoundary=Intensity_std(:,2);
Stats_false.Contrast=Contrast(:,2);
Stats_false.Skewness=Skewness(:,2);

%% plotting

subplot(151);
bar([1 2],[mean(cat(1,Stats_true.MeanAxon)) mean(cat(1,Stats_false.MeanAxon))]);
hold on
errorbar([1 2],[mean(cat(1,Stats_true.MeanAxon)) mean(cat(1,Stats_false.MeanAxon))],[std(cat(1,Stats_true.MeanAxon)) std(cat(1,Stats_false.MeanAxon))],'rx');

subplot(152);
bar([1 2],[mean(cat(1,Stats_true.STDAxon)) mean(cat(1,Stats_false.STDAxon))]);
hold on
errorbar([1 2],[mean(cat(1,Stats_true.STDAxon)) mean(cat(1,Stats_false.STDAxon))],[std(cat(1,Stats_true.STDAxon)) std(cat(1,Stats_false.STDAxon))],'rx');
 
subplot(153);
bar([1 2],[mean(cat(1,Stats_true.MeanBoundary)) mean(cat(1,Stats_false.MeanBoundary))]);
hold on
errorbar([1 2],[mean(cat(1,Stats_true.MeanBoundary)) mean(cat(1,Stats_false.MeanBoundary))],[std(cat(1,Stats_true.MeanBoundary)) std(cat(1,Stats_false.MeanBoundary))],'rx');
 
subplot(154);
bar([1 2],[mean(cat(1,Stats_true.STDBoundary)) mean(cat(1,Stats_false.STDBoundary))]);
hold on
errorbar([1 2],[mean(cat(1,Stats_true.STDBoundary)) mean(cat(1,Stats_false.STDBoundary))],[std(cat(1,Stats_true.STDBoundary)) std(cat(1,Stats_false.STDBoundary))],'rx');
 
subplot(155);
bar([1 2],[mean(cat(1,Stats_true.Contrast)) mean(cat(1,Stats_false.Contrast))]);
hold on
errorbar([1 2],[mean(cat(1,Stats_true.Contrast)) mean(cat(1,Stats_false.Contrast))],[std(cat(1,Stats_true.Contrast)) std(cat(1,Stats_false.Contrast))],'rx');


%%

subplot(121);
imshow(imfuse(object_i(100:300,130:400),img_gray(100:300,130:400)));

subplot(122);
imshow(imfuse(diff_i(100:300,130:400),img_gray(100:300,130:400)));



imshow(sc(sc(object_i(100:300,130:400),[0 0.75 0],object_i(100:300,130:400))+sc(diff_i(100:300,130:400),[1 0.5 0],diff_i(100:300,130:400))+sc(img_gray(100:300,130:400))));




subplot(121);
imshow(imfuse(object_i,img_gray));

subplot(122);
imshow(imfuse(diff_i,img_gray));



imshow(sc(sc(object_i,[0 0.75 0],object_i)+sc(diff_i,[1 0.5 0],diff_i)+sc(img_gray)));


%% proportional to size of each object - TRUE

[cc_initial,num1] = bwlabel(img_BW_true,8);
props=regionprops(cc_initial,'EquivDiameter');
Axon_diam=[props.EquivDiameter]';
Myelin_diam=(Axon_diam/0.6)-Axon_diam;
Myelin_diam=round(Myelin_diam);

for j=1:num1
    
    if Myelin_diam(j)==0, Myelin_diam(j)=1; end
%     if Myelin_diam(j)>=25, Myelin_diam(j)=25; end    
    
    
end

Intensity_mean=zeros(num1,2);
Intensity_std=zeros(num1,2);
Skewness=zeros(num1,2);

Intensity_mean_axon=zeros(num1,2);
Intensity_std_axon=zeros(num1,2);

img_gray=im2double(img_gray);

for i=1:num1

    object_i=cc_initial==i;
    se = strel('disk',Myelin_diam(i));
    object_dilated_i=imdilate(object_i,se);
    diff_i=im2bw(object_dilated_i-object_i);
    
    Gray_object_i = img_gray(diff_i==1);
    Skewness(i,2)=skewness(Gray_object_i);
    
    Intensity_mean(i,1)=i;
    Intensity_std(i,1)=i;
    Skewness(i,1)=i;
    
    Intensity_mean(i,2)=mean(Gray_object_i);
    Intensity_std(i,2)=std(Gray_object_i);
    
    Gray_object_i_axon = img_gray(cc_initial==i);
    
    Intensity_mean_axon(i,1)=i;
    Intensity_std_axon(i,1)=i;
 
    Intensity_mean_axon(i,2)=mean(Gray_object_i_axon);
    Intensity_std_axon(i,2)=std(Gray_object_i_axon);

        
end

Contrast=zeros(num1,2);
Contrast(:,1)=Intensity_mean(:,1);
Contrast(:,2)=Intensity_mean(:,2)-Intensity_mean_axon(:,2);

Stats_true.MeanAxon=Intensity_mean_axon(:,2);
Stats_true.STDAxon=Intensity_std_axon(:,2);
Stats_true.MeanBoundary=Intensity_mean(:,2);
Stats_true.STDBoundary=Intensity_std(:,2);
Stats_true.Contrast=Contrast(:,2);
Stats_true.Skewness=Skewness(:,2);

%% proportional to size of each object - FALSE

[cc_initial,num1] = bwlabel(img_BW_false,8);
props=regionprops(cc_initial,'EquivDiameter');
Axon_diam=[props.EquivDiameter]';
Myelin_diam=(Axon_diam/0.6)-Axon_diam;
Myelin_diam=round(Myelin_diam);

for j=1:num1
    
    if Myelin_diam(j)==0, Myelin_diam(j)=1; end
%     if Myelin_diam(j)>=25, Myelin_diam(j)=25; end    
    
    
end

Intensity_mean=zeros(num1,2);
Intensity_std=zeros(num1,2);
Skewness=zeros(num1,2);

Intensity_mean_axon=zeros(num1,2);
Intensity_std_axon=zeros(num1,2);

img_gray=im2double(img_gray);

for i=1:num1

    object_i=cc_initial==i;
    se = strel('disk',Myelin_diam(i));
    object_dilated_i=imdilate(object_i,se);
    diff_i=im2bw(object_dilated_i-object_i);
    
    Gray_object_i = img_gray(diff_i==1);
    Skewness(i,2)=skewness(Gray_object_i);
    
    Intensity_mean(i,1)=i;
    Intensity_std(i,1)=i;
    Skewness(i,1)=i;
    
    Intensity_mean(i,2)=mean(Gray_object_i);
    Intensity_std(i,2)=std(Gray_object_i);
    
    Gray_object_i_axon = img_gray(cc_initial==i);
    
    Intensity_mean_axon(i,1)=i;
    Intensity_std_axon(i,1)=i;
 
    Intensity_mean_axon(i,2)=mean(Gray_object_i_axon);
    Intensity_std_axon(i,2)=std(Gray_object_i_axon);

        
end

Contrast=zeros(num1,2);
Contrast(:,1)=Intensity_mean(:,1);
Contrast(:,2)=Intensity_mean(:,2)-Intensity_mean_axon(:,2);

Stats_false.MeanAxon=Intensity_mean_axon(:,2);
Stats_false.STDAxon=Intensity_std_axon(:,2);
Stats_false.MeanBoundary=Intensity_mean(:,2);
Stats_false.STDBoundary=Intensity_std(:,2);
Stats_false.Contrast=Contrast(:,2);
Stats_false.Skewness=Skewness(:,2);

%% Plot intensity means true & false vs neighbourhood size used

% axon mean & std






% neighbour mean & std

mean_true_mean_1=mean(cat(1,Stats_true.MeanBoundary));
std_true_mean_1=std(cat(1,Stats_true.MeanBoundary));

mean_true_std_1=mean(cat(1,Stats_true.STDBoundary));
std_true_std_1=std(cat(1,Stats_true.STDBoundary));

mean_false_mean_1=mean(cat(1,Stats_false.MeanBoundary));
std_false_mean_1=std(cat(1,Stats_false.MeanBoundary));

mean_false_std_1=mean(cat(1,Stats_false.STDBoundary));
std_false_std_1=std(cat(1,Stats_false.STDBoundary));

%%

True_mean_neighbour_mean=[mean(cat(1,Stats_true_1.MeanBoundary)),mean(cat(1,Stats_true_2.MeanBoundary)),...
    mean(cat(1,Stats_true_3.MeanBoundary)),mean(cat(1,Stats_true_4.MeanBoundary)),mean(cat(1,Stats_true_10.MeanBoundary))];
True_std_neighbour_mean=[std(cat(1,Stats_true_1.MeanBoundary)),std(cat(1,Stats_true_2.MeanBoundary)),...
    std(cat(1,Stats_true_3.MeanBoundary)),std(cat(1,Stats_true_4.MeanBoundary)),std(cat(1,Stats_true_10.MeanBoundary))];

True_mean_neighbour_std=[mean(cat(1,Stats_true_1.STDBoundary)),mean(cat(1,Stats_true_2.STDBoundary)),...
    mean(cat(1,Stats_true_3.STDBoundary)),mean(cat(1,Stats_true_4.STDBoundary)),mean(cat(1,Stats_true_10.STDBoundary))];
True_std_neighbour_std=[std(cat(1,Stats_true_1.STDBoundary)),std(cat(1,Stats_true_2.STDBoundary)),...
    std(cat(1,Stats_true_3.STDBoundary)),std(cat(1,Stats_true_4.STDBoundary)),std(cat(1,Stats_true_10.STDBoundary))];

True_mean_contrast=[mean(cat(1,Stats_true_1.Contrast)),mean(cat(1,Stats_true_2.Contrast)),...
    mean(cat(1,Stats_true_3.Contrast)),mean(cat(1,Stats_true_4.Contrast)),mean(cat(1,Stats_true_10.Contrast))];
True_std_contrast=[std(cat(1,Stats_true_1.Contrast)),std(cat(1,Stats_true_2.Contrast)),...
    std(cat(1,Stats_true_3.Contrast)),std(cat(1,Stats_true_4.Contrast)),std(cat(1,Stats_true_10.Contrast))];






%%


False_mean_neighbour_mean=[mean(cat(1,Stats_false_1.MeanBoundary)),mean(cat(1,Stats_false_2.MeanBoundary)),...
    mean(cat(1,Stats_false_3.MeanBoundary)),mean(cat(1,Stats_false_4.MeanBoundary)),mean(cat(1,Stats_false_10.MeanBoundary))];
False_std_neighbour_mean=[std(cat(1,Stats_false_1.MeanBoundary)),std(cat(1,Stats_false_2.MeanBoundary)),...
    std(cat(1,Stats_false_3.MeanBoundary)),std(cat(1,Stats_false_4.MeanBoundary)),std(cat(1,Stats_false_10.MeanBoundary))];

False_mean_neighbour_std=[mean(cat(1,Stats_false_1.STDBoundary)),mean(cat(1,Stats_false_2.STDBoundary)),...
    mean(cat(1,Stats_false_3.STDBoundary)),mean(cat(1,Stats_false_4.STDBoundary)),mean(cat(1,Stats_false_10.STDBoundary))];
False_std_neighbour_std=[std(cat(1,Stats_false_1.STDBoundary)),std(cat(1,Stats_false_2.STDBoundary)),...
    std(cat(1,Stats_false_3.STDBoundary)),std(cat(1,Stats_false_4.STDBoundary)),std(cat(1,Stats_false_10.STDBoundary))];

False_mean_contrast=[mean(cat(1,Stats_false_1.Contrast)),mean(cat(1,Stats_false_2.Contrast)),...
    mean(cat(1,Stats_false_3.Contrast)),mean(cat(1,Stats_false_4.Contrast)),mean(cat(1,Stats_false_10.Contrast))];
False_std_contrast=[std(cat(1,Stats_false_1.Contrast)),std(cat(1,Stats_false_2.Contrast)),...
    std(cat(1,Stats_false_3.Contrast)),std(cat(1,Stats_false_4.Contrast)),std(cat(1,Stats_false_10.Contrast))];



%%

x=[1,2,3,4,10];

plot(x,True_mean_neighbour_mean,'or');
hold on
errorbar(x,True_mean_neighbour_mean,True_std_neighbour_mean,'r');
hold on

plot(x,False_mean_neighbour_mean,'sg');
hold on
errorbar(x,False_mean_neighbour_mean,False_std_neighbour_mean,'g');

plot(x,True_mean_contrast,'ob');
hold on
errorbar(x,True_mean_contrast,True_std_contrast,'b');

plot(x,False_mean_contrast,'sk');
hold on
errorbar(x,False_mean_contrast,False_std_contrast,'k');

title('Axon candidates measures vs neighbourhood size considered','FontSize',14);
legend('True axons - Neighbourhood mean','','False axons - Neighbourhood mean','','True axons - Contrast Difference','','False axons - Contrast Difference','','Location','best');
xlabel('Radius value (in pix) of the disk used for object dilation','FontSize',14);
ylabel('Grayscale intensity (normalized between 0 & 1)','FontSize',14);





plot(x,True_mean_neighbour_std,'o-.r');
hold on
% errorbar(x,True_mean_neighbour_std,True_std_neighbour_std,'r');

plot(x,False_mean_neighbour_std,'s-.b');
hold on
% errorbar(x,False_mean_neighbour_std,False_std_neighbour_std,'b');

plot(x,True_std_contrast,'o-.g');
hold on
% errorbar(x,True_std_contrast,std(True_std_contrast),'g');

plot(x,False_std_contrast,'s-.k');
hold on
% errorbar(x,False_std_contrast,std(False_std_contrast),'k');

title('Axon candidates measures vs neighbourhood size considered','FontSize',14);
legend('True axons - std of Neighbourhood means','False axons - std of Neighbourhood means','True axons - std of Contrast Differences','False axons - std of Contrast Differences','Location','best');
xlabel('Radius value (in pix) of the disk used for object dilation','FontSize',14);
ylabel('Grayscale intensity (normalized between 0 & 1)','FontSize',14);



%%

scatter(Myelin_diam_true,Stats_true.STDBoundary,'b');
hold on;
scatter(Myelin_diam_false,Stats_false.STDBoundary,'*r');

subplot(121);
hist(Stats_true.Contrast);
subplot(122);
hist(Stats_false.Contrast);


scatter(ones(245,1),Stats_true.Contrast);
hold on;
scatter(2*ones(928,1),Stats_false.Contrast);
hold on;
scatter(3*ones(245,1),Stats_true.STDBoundary);
hold on;
scatter(4*ones(928,1),Stats_false.STDBoundary);
hold on;
scatter(5*ones(245,1),Stats_true.MeanBoundary);
hold on;
scatter(6*ones(928,1),Stats_false.MeanBoundary);




%% contrast tests

a=imadjust(img_gray);
figure, imshow(a);

b=histeq(img_gray,2);
figure, imshow(b);

c=adapthisteq(img_gray);
figure, imshow(c);


seg=edge(img_gray, 'LoG',0.005);
imshow(seg);

seg_sum=(0.7*im2uint8(seg))+img_gray;
imshow(seg_sum);
imwrite(seg_sum,'SEM_06_test_enhanced3.tif');


test=0.4*b+0.7*img_gray;
figure, imshow(test);



%% gradient tests

[Gx, Gy] = imgradientxy(img_gray,'CentralDifference');
imshow(Gy);
imshow(im2double(img_gray)+0.05*Gx+0.05*Gy);

test2=im2double(img_gray)+0.025*Gx+0.025*Gy;
test2=histeq(test2,4);
imshow(test2);
imwrite(test2,'SEM_06_test_with_gradients.tif');



res=imgradient(img_gray,'Roberts');
imshow(0.015*res);
imwrite(0.005*res,'SEM_06_test_with_all_gradients.tif');

aaa=im2double(0.4*img_gray)+(0.005*res);
imshow(aaa);
imwrite(aaa,'test_bizarre.tif');



%% score histograms

r=[1 2 2 3 4 4 5 6 6 7 8 9 10 11 11 11 12 12 13 14 16 19 20 21 22 25 26 27 28];
d=prctile(r,1);


m=hist(r,5);



%% 

img_path_1 = uigetimagefile;
img = imread(img_path_1);

img=as_gaussian_smoothing(img);

img2=medfilt2(img,[2 2]);
img2=medfilt2(img2,[15 15]);

figure, imshow(img2);
imwrite(img(1:800,1:800),'test_mini_ledvelset3.bmp');







