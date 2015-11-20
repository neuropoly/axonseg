function Validation_stats = as_eval_seg_quality(axonlist_control,axonlist_test,img)

% Validation methods that can be used :
% - Correlation coefficient (2D) between the 2 binary images segmented
% - Number of objects in each binary image (test vs control)
% - % of axons of test that are also in control (use centroids)

img_BW_control=as_display_label(axonlist_control,size(img),'axonEquivDiameter','axon');
img_BW_test=as_display_label(axonlist_test,size(img),'axonEquivDiameter','axon');

img_BW_control=im2bw(img_BW_control,0);
img_BW_test=im2bw(img_BW_test,0);

imshow(img_BW_control);
imshow(img_BW_test);

% Correlation coefficient
corr_coef=corr2(img_BW_control,img_BW_test);
Validation_stats.corr_coef=corr_coef;

% Number of objects in each binary image

[~,num_control] = bwlabel(img_BW_control,8);
[~,num_test] = bwlabel(img_BW_test,8);

Validation_stats.num_objects_control=num_control;
Validation_stats.num_objects_test=num_test;

% Number of pixels in both, only control or only test

pixels_in_both = img_BW_control&img_BW_test;
pixels_only_control = logical(img_BW_control-pixels_in_both);
pixels_only_test = logical(img_BW_test-pixels_in_both);

nbr_pixels_in_both = sum(sum(pixels_in_both));
nbr_pixels_only_control = sum(sum(pixels_only_control));
nbr_pixels_only_test = sum(sum(pixels_only_test));

Validation_stats.nbr_pix_in_both=nbr_pixels_in_both;
Validation_stats.nbr_pix_only_control=nbr_pixels_only_control;
Validation_stats.nbr_pix_only_test=nbr_pixels_only_test;

% Jaccard & others

intersection_img=img_BW_control&img_BW_test;
union_img=img_BW_control|img_BW_test;

a=sum(sum(intersection_img));
b=sum(sum(pixels_only_control));
c=sum(sum(pixels_only_test));
d=sum(sum(union_img));

n=a+b+c+d;

Validation_stats.Jaccard=a/(a+b+c);
Validation_stats.PatternDifference=(4*b*c)/n^2;
Validation_stats.SizeDifference=(b+c)^2/n^2;
Validation_stats.ShapeDifference=(n*(b+c)-(b-c)^2)/n^2;

% Plot comparison results

% figure(1);
% sc(sc(pixels_in_both,[1 1 1],pixels_in_both)+sc(pixels_only_control,[0 0.5 0],pixels_only_control)+sc(pixels_only_test,[1 0 0],pixels_only_test));

end