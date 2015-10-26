function removed_axons = find_removed_axons(Auto_seg_img, Corrected_seg_img)
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

%---~

removed_axons = bwselect(Corrected_seg_img,centroids_auto_seg_img(:,1),centroids_auto_seg_img(:,2));

index_removed_axons = find(Corrected_seg_img(centroids_auto_seg_img(:,1),centroids_auto_seg_img(:,2))); % index are the points 
removed_axons = ismember(Auto_seg_img,index_removed_axons);


subplot(121);
imshow(removed_axons);
subplot(122);
imshow(Auto_seg_img);


% 
% % Axon counters for statistical calculations
% 
% 
% get_label = zeros(size(centroids_auto_seg_img,1),1);
% 
% for cnt=1:size(centroids_auto_seg_img,1)
%     test_point_x = round(centroids_auto_seg_img(cnt,2));
%     test_point_y = round(centroids_auto_seg_img(cnt,1));
%     
%     % Si ce centroide existe aussi dans un objet de l'image corrigée
%     if (Corrected_seg_img(test_point_x,test_point_y)~=0)
%         get_label(cnt) = cc_auto(test_point_x,test_point_y);   
%     end  
% end
% 
% Stats_changes_matrix = zeros(size(centroids_auto_seg_img,1),5);
% 
% for cnt=1:size(centroids_auto_seg_img,1)
% 
%     Stats_changes_matrix(cnt,1)=areas_auto_seg_img(cnt);
%     Stats_changes_matrix(cnt,3)=sqrt(4*areas_auto_seg_img(cnt)/pi);    
%     
%     if get_label(cnt)~=0
%         Stats_changes_matrix(cnt,2)=areas_corr_seg_img(get_label(cnt));
%         Stats_changes_matrix(cnt,4)=sqrt(4*areas_corr_seg_img(get_label(cnt))/pi);
%     else
%         Stats_changes_matrix(cnt,2)=areas_auto_seg_img(cnt);
%         Stats_changes_matrix(cnt,4)=sqrt(4*areas_auto_seg_img(cnt)/pi);
%     end
% end
% 
% 
% % Change auto vs corrected
% 
% for cnt=1:size(Stats_changes_matrix,1)
% 
%     Stats_changes_matrix(cnt,5)=100*((Stats_changes_matrix(cnt,4)-Stats_changes_matrix(cnt,3))/Stats_changes_matrix(cnt,3));  
%     
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% end