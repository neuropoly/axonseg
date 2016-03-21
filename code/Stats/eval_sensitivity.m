function sensitivity = eval_sensitivity(Auto_seg_img, Corrected_seg_img)
% Description : This function calculates the sensitivity of the axon
% segmentation performed by SegmentationGUI by comparing the result with
% the image obtained by correcting the segmentation (by using
% ManualCorrectionGUI).
% Auto_seg_img : IN (BW Image obtained by SegmentationGUI)
% Corrected_seg_img : IN (BW Image obtained by ManualCorrectionGUI)
%
% sensitivity : OUT (Scalar giving sensitivity between the 2 images)
%
% sensitivity = eval_sensitivity(Auto_seg_img, Corrected_seg_img)
% Example: sensitivity = eval_sensitivity(axonseg, axonseg_corrected)

cc_auto = bwconncomp(im2bw(Auto_seg_img), 8);
cc_corrected = bwconncomp(im2bw(Corrected_seg_img), 8);

centroids_auto_seg_img = regionprops(cc_auto,'Centroid');
centroids_corr_seg_img = regionprops(cc_corrected,'Centroid');

centroids_auto_seg_img = cat(1,centroids_auto_seg_img.Centroid);
centroids_corr_seg_img = cat(1,centroids_corr_seg_img.Centroid);

nbr_test=cc_auto.NumObjects;
nbr_control=cc_corrected.NumObjects;

% Axon counters for statistical calculations

nbr_of_axons_still_there = 0;
nbr_of_axons_removed = 0;
nbr_of_axons_added = 0;

for cnt=1:size(centroids_auto_seg_img,1)
    test_point_x = round(centroids_auto_seg_img(cnt,2));
    test_point_y = round(centroids_auto_seg_img(cnt,1));
    
    if (Corrected_seg_img(test_point_x,test_point_y)==true)
        nbr_of_axons_still_there=nbr_of_axons_still_there+1;    
    else
        nbr_of_axons_removed=nbr_of_axons_removed+1;
    end  
end



for cnt=1:size(centroids_corr_seg_img,1)
    test_point_x = round(centroids_corr_seg_img(cnt,2));
    test_point_y = round(centroids_corr_seg_img(cnt,1));
    
    if (Auto_seg_img(test_point_x,test_point_y)==false)
    nbr_of_axons_added = nbr_of_axons_added+1;
    end  
end


% Stats for modified axons (diameter, area)





FN = nbr_of_axons_added;
% FP = nbr_of_axons_removed;

% nbr_of_axons_still_there = TP-removed_axons
% TP = nbr_axons_in_auto_seg - added_axons - removed_axons
TP = nbr_of_axons_still_there-nbr_of_axons_added;

sensitivity = TP/(TP+FN);

figure, imshow(Auto_seg_img);
figure, imshow(Corrected_seg_img);

end