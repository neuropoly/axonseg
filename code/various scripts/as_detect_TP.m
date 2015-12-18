function [TP, nbr_test] = as_detect_TP(img_BW, Coordinates)
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

cc = bwconncomp(im2bw(img_BW), 8);
nbr_test=cc.NumObjects;

% Axon counters for statistical calculations

TP = 0;

for cnt=1:size(Coordinates,1)
    
    test_point_x = round(Coordinates(cnt,2));
    test_point_y = round(Coordinates(cnt,1));
    
    if (img_BW(test_point_x,test_point_y)==true)
        TP=TP+1;    
    end  
end

figure, imshow(img_BW);
hold on;
plot(Coordinates(:,1),Coordinates(:,2),'r*');
hold off;


end