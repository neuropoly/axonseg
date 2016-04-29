function [Validation_results] = as_validation(img_BW_control,img_BW_test)

% Validation methods that can be used :
% - Correlation coefficient (2D) between the 2 binary images segmented
% - Number of objects in each binary image (test vs control)
% - % of axons of test that are also in control (use centroids)

% img_path_1 = uigetimagefile;
% img_BW_test = imread(img_path_1);
% 
% img_path_2 = uigetimagefile;
% img_BW_control = imread(img_path_2);

% 
% img_BW_control=as_display_label(axonlist_control,size(img),'axonEquivDiameter','axon');
% 
% img_BW_test=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
% img_BW_test=im2bw(img_BW_test,0);


% imshow(imfuse(img_BW_test,img_BW_control));

%% STEP 1 --- INPUT VALIDATION

img_BW_control=im2bw(img_BW_control);
img_BW_test=im2bw(img_BW_test);

% imshow(img_BW_control);
% imshow(img_BW_test);

%% STEP 2 --- SENSITIVITY CALCULATIONS


% use centroids & compare with ctrl image

[cc_auto,num1] = bwlabel(im2bw(img_BW_test), 8);
[cc_corrected,num2] = bwlabel(im2bw(img_BW_control), 8);

centroids_auto_seg_img = regionprops(cc_auto,'Centroid');
centroids_corr_seg_img = regionprops(cc_corrected,'Centroid');

size_corr_seg_img = regionprops(cc_corrected,'EquivDiameter');

Equiv_Diameter = cat(1,size_corr_seg_img);
Equiv_Diameter = cell2mat(struct2cell(Equiv_Diameter))';

centroids_auto_seg_img = cat(1,centroids_auto_seg_img.Centroid);
centroids_corr_seg_img = cat(1,centroids_corr_seg_img.Centroid);

% Axon counters for statistical calculations

TP = 0;
FP = 0;
FN = 0;

for cnt=1:size(centroids_auto_seg_img,1)
    test_point_x = round(centroids_auto_seg_img(cnt,2));
    test_point_y = round(centroids_auto_seg_img(cnt,1));
    
    if (img_BW_control(test_point_x,test_point_y)==true)
        TP=TP+1;    
    else
        FP=FP+1;
    end  
end



for cnt=1:size(centroids_corr_seg_img,1)
    test_point_x = round(centroids_corr_seg_img(cnt,2));
    test_point_y = round(centroids_corr_seg_img(cnt,1));
    
    if (img_BW_test(test_point_x,test_point_y)==false)
    FN = FN+1;
    end  
end


% Stats for modified axons (diameter, area)

sensitivity = TP/(TP+FN);
precision = TP/(TP+FP);

figure, imshow(imfuse(img_BW_test,img_BW_control));
hold on;
plot(centroids_auto_seg_img(:,1),centroids_auto_seg_img(:,2),'r*');
hold off;


%% STEP 3 



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

% Validation_stats.nbr_pix_in_both=nbr_pixels_in_both;
% Validation_stats.nbr_pix_only_control=nbr_pixels_only_control;
% Validation_stats.nbr_pix_only_test=nbr_pixels_only_test;

% Dice & others

intersection_img=img_BW_control&img_BW_test;
union_img=img_BW_control|img_BW_test;

a=sum(sum(intersection_img));
b=sum(sum(pixels_only_control));
c=sum(sum(pixels_only_test));
d=sum(sum(union_img));

n=a+b+c+d;

% These are global measures taking into account the whole results (biaised
% if missed axons in one of the 2 --- considers it in calculation)

% Validation_stats.Dice=2*a/((2*a)+b+c);
% Validation_stats.PatternDifference=(4*b*c)/n^2;
% Validation_stats.SizeDifference=(b+c)^2/n^2;
% Validation_stats.ShapeDifference=(n*(b+c)-(b-c)^2)/n^2;
% Validation_stats.Tarantula=a*(c+d)/(c*(a+b));
% 
% 




% FOR EACH OBJECT

Local_validation=zeros(1,6);

% for each object in control image
for i=1:num_control
        
    % get a binary image of this object alone
    object_ctrl_i=cc_corrected==i;
    
    % get the centroid of this object
    cx = round(centroids_corr_seg_img(i,2));
    cy = round(centroids_corr_seg_img(i,1));
    
    % verify if this position in on or off in test image
    if (cc_auto(cx,cy)~=0)
        
        % make binary image of same object in test image
        object_test_i=cc_auto==cc_auto(cx,cy);
        
        % calculate seg validation for this object
        intersection_i=object_test_i&object_ctrl_i;
        union_i=object_test_i|object_ctrl_i;
        
        pixels_only_control = logical(object_ctrl_i-intersection_i);
        pixels_only_test = logical(object_test_i-intersection_i);

        a=sum(sum(intersection_i));
        b=sum(sum(pixels_only_control));
        c=sum(sum(pixels_only_test));
        d=sum(sum(union_i));

        n=a+b+c+d;

        Local_Dice_i=2*a/((2*a)+b+c);
        
        
        Local_PatternDifference_i=(4*b*c)/n^2;
        Local_SizeDifference_i=(b+c)^2/n^2;
        Local_ShapeDifference_i=(n*(b+c)-(b-c)^2)/n^2;
        
        [ccc,~] = bwlabel(object_ctrl_i, 8);
        size_corr_seg_img = regionprops(ccc,'Area');
        Equiv_Diameter = cat(1,size_corr_seg_img);
        Equiv_Diameter = cell2mat(struct2cell(Equiv_Diameter));
             
        Local_validation=[Local_validation;[i,Equiv_Diameter,Local_Dice_i,Local_PatternDifference_i,Local_SizeDifference_i,Local_ShapeDifference_i]];
        
    end  
    
end
     


Local_validation=Local_validation(2:end,:);


Dice_mean = mean(Local_validation(:,3));
Dice_std = std(Local_validation(:,3));
Dice_median = median(Local_validation(:,3));
Dice_percentile_90 = prctile(Local_validation(:,3),90);
Dice_percentile_95 = prctile(Local_validation(:,3),95);
Dice_percentile_10 = prctile(Local_validation(:,3),10);

Pattern_Difference_mean = mean(Local_validation(:,4));
Pattern_Difference_std = std(Local_validation(:,4));

Size_Difference_mean = mean(Local_validation(:,5));
Size_Difference_std = std(Local_validation(:,5));

Shape_Difference_mean = mean(Local_validation(:,6));
Shape_Difference_std = std(Local_validation(:,6));


Validation_results.test_img=img_BW_test;
Validation_results.control_img=img_BW_control;

Validation_results.Dice_mean=Dice_mean;
Validation_results.Dice_std=Dice_std;
Validation_results.Dice_median=Dice_median;
Validation_results.Dice_percentile_90=Dice_percentile_90;
Validation_results.Dice_percentile_95=Dice_percentile_95;
Validation_results.Dice_percentile_10=Dice_percentile_10;

Validation_results.Dice_table=Local_validation;

Validation_results.Precision=precision;
Validation_results.Sensitivity=sensitivity;
Validation_results.ROC.TP=TP;
Validation_results.ROC.FP=FP;
Validation_results.ROC.FN=FN;

Validation_results.Pattern_Difference_mean=Pattern_Difference_mean;
Validation_results.Pattern_Difference_std=Pattern_Difference_std;

Validation_results.Size_Difference_mean=Size_Difference_mean;
Validation_results.Size_Difference_std=Size_Difference_std;

Validation_results.Shape_Difference_mean=Shape_Difference_mean;
Validation_results.Shape_Difference_std=Shape_Difference_std;


save('Validation_results_quad.mat','Validation_results','-v7.3');



% scatter(Local_validation(2:end,2),Local_validation(2:end,3));

end













