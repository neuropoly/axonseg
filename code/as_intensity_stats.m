function [Intensity_means,Intensity_std] = as_intensity_stats(img_gray, img_BW)

% img_path_1 = uigetimagefile;
% img_gray = imread(img_path_1);
% 
% img_path_2 = uigetimagefile;
% img_BW_before = imread(img_path_2);
% 
% img_path_3 = uigetimagefile;
% img_BW_after = imread(img_path_3);
% 
% 
% img_BW_before=im2bw(img_BW_before);
% img_BW_after=im2bw(img_BW_after);

[BW_before_labeled,num] = bwlabel(img_BW,8);

Intensity_means=zeros(num,1);
Intensity_std=zeros(num,1);

for i=1:num

Gray_object_values = img_gray(BW_before_labeled==i);
Intensity_means(i,:)=mean(Gray_object_values);
Intensity_std(i,:)=std(Gray_object_values);

end





















