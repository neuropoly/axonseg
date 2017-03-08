% build template classifier


% image of segmented axons (all axons in step 1, true and false)
img_path_1 = uigetimagefile;
BW_all = imread(img_path_1);

% image of corrected axons after discrimination (binary true axons)
img_path_2 = uigetimagefile;
BW_true = imread(img_path_2);

% original grayscale image
img_path_3 = uigetimagefile;
BW_gray = imread(img_path_3);

[classifier, parameters,ROC_values] = as_axonSeg_make_DA_classifier(BW_all,BW_true,BW_gray, ...
{'EquivDiameter','Solidity','Circularity','MinorMajorRatio','Intensity_std', 'Intensity_mean','Neighbourhood_mean'...
,'Neighbourhood_std','Contrast','Skewness'},'linear',1);

classifier_final=classifier{10};

% Apply selected classifier to the given data
[Accepted_axons_img,Rejected_axons_img,Classification,~,~]=as_axonSeg_apply_DA_classifier(BW_all,BW_gray,classifier_final,parameters);

figure; imshow(Accepted_axons_img);








