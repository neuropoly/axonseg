function BW_removed_axons = find_removed_axons(Auto_seg_img, Corrected_seg_img)
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

% Auto_seg_img = AxonSeg_1_img;
% Corrected_seg_img = AxonSeg_2_img;


%---
cc_auto = bwconncomp(Auto_seg_img, 4);
cc_corrected = bwconncomp(Corrected_seg_img, 4);

%---

props_auto_seg_img = regionprops(cc_auto,{'Centroid'});
props_corr_seg_img = regionprops(cc_corrected,{'Centroid'});

centroids_auto_seg_img = cat(1,props_auto_seg_img.Centroid);
centroids_corr_seg_img = cat(1,props_corr_seg_img.Centroid);

centroids_auto_seg_img = round(centroids_auto_seg_img);
centroids_corr_seg_img = round(centroids_corr_seg_img);

%--- ~


Matrix_centroids_auto = zeros(1,2);
% 
% 
% Matrix_centroids_auto(Corrected_seg_img(centroids_auto_seg_img(:,2),centroids_auto_seg_img(:,1))==0, :)= [];
% 
% 
% Matrix_centroids_auto(Corrected_seg_img(Matrix_centroids_auto)==0, :)= [];



for i=1:length(centroids_auto_seg_img)
    
    if Corrected_seg_img(centroids_auto_seg_img(i,2),centroids_auto_seg_img(i,1))==0
        Matrix_centroids_auto = [Matrix_centroids_auto; centroids_auto_seg_img(i,:)];
    end
    
end

Matrix_centroids_auto(1,:)=[];

BW_removed_axons = bwselect(Auto_seg_img,Matrix_centroids_auto(:,1),Matrix_centroids_auto(:,2));

subplot(131);
imshow(BW_removed_axons);
subplot(132);
imshow(Auto_seg_img);
subplot(133);
imshow(Corrected_seg_img);
