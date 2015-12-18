function [Intensity_means,Intensity_std] = as_intensity_stats(img_gray, img_BW)
% Function that computes the intensity means & std (gray) of objects
% present on binary mask input (img_BW), in gray level image input
% (img_gray). 
% - The output Intensity_means is a column vector containing the
% mean intensities of each object found in the binary mask input.
%
% - The output Intensity_std is a column vector containing the
% standard deviation of the intensities of each object found in the binary
% mask input.
%
% Example : [Intensity_means,Intensity_std] =
% as_intensity_stats(initial_img_gray, img_axonseg_bw);
%
%


img_gray=im2double(img_gray);

[BW_before_labeled,num] = bwlabel(img_BW,8);

Intensity_means=zeros(num,1);
Intensity_std=zeros(num,1);

for i=1:num

    Gray_object_values = img_gray(BW_before_labeled==i);
    Intensity_means(i,:)=mean(Gray_object_values);
    Intensity_std(i,:)=std(Gray_object_values);

end





















