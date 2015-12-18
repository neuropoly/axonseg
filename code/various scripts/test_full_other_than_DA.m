
img_path_1 = uigetimagefile;
img_BW = imread(img_path_1);
img_BW=im2bw(img_BW);

img_path_3 = uigetimagefile;
img_gray = imread(img_path_3);

parameters={'Area', 'Perimeter', 'EquivDiameter', 'Solidity','Circularity','MajorAxisLength','MinorMajorRatio',...
    'MinorAxisLength','Eccentricity','ConvexArea','Intensity_std',...
    'Intensity_mean','Perimeter_ConvexHull','PPchRatio','AAchRatio',...
    'Intensity_std', 'Intensity_mean','Neighbourhood_mean','Neighbourhood_std','Contrast','Skewness'};
AxSeg=img_BW;
AxonSeg_gray=img_gray;

[Stats_3, names3] = as_stats_axons(AxSeg,AxonSeg_gray);
Stats_3_used = rmfield(Stats_3,setdiff(names3, parameters));

% Predict true & false axons by using the classifier (INPUT)

Stats_3_used = table2array(struct2table(Stats_3_used));

[label,~,~] = predict(classifier_final,Stats_3_used);

% Identify true & false axons 

% index1=find(label==1);
% Rejected_axons_img = ismember(bwlabel(AxSeg),index1);

index2=find(label==0);
Accepted_axons_img = ismember(bwlabel(AxSeg),index2);

AxonSeg_DA = Accepted_axons_img;

figure, imshow(imfuse(AxonSeg_DA,img_gray));









