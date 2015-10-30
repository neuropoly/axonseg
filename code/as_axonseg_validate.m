function [Rejected_axons_img, Accepted_axons_img,Class_table_final] = as_axonseg_validate(axonSeg_step1,axonSeg_segCorrected, parameters,type,val)
% OUTPUTS -----------------------------------------------------------------
% Rejected_axons_img (OUT) : binary image of rejected axons
% Accepted_axons_img (OUT) : binary image of accepted axons
% Class_table_final (OUT) : matrix indicating the number of axons (true &
% false) classified in each type
% INPUTS ------------------------------------------------------------------
% axonSeg_step1 (IN) : image of the initial axon segmentation (containing
% both false & true axons)
% axonSeg_segCorrected (IN) : image of the true axons only, obtained after
% manual correction with the SegmentationGUI
% parameters (IN) : cell array containing the names of the specified
% parameters (up to 9 can be chosen)
% type (IN) : string specifying the type of analysis ('linear' or
% 'quadratic')
%--------------------------------------------------------------------------
% Example : [Rejected_axons_img, Accepted_axons_img, Classification] = as_axonseg_validate(axonSeg_step1,axonSeg_segCorrected,{'Circularity','EquivDiameter'},'linear');

%--------------------------------------------------------------------------
% % 
% img_path_1 = uigetimagefile;
% axonSeg_step1 = imread(img_path_1);
% 
% img_path_2 = uigetimagefile;
% axonSeg_segCorrected = imread(img_path_2);

%--------------------------------------------------------------------------

% Validate both images are binary

AxonSeg_1_img = im2bw(axonSeg_step1);
AxonSeg_2_img = im2bw(axonSeg_segCorrected);

% Find removed objects (axons) from initial seg. to corrected seg.

False_axons_img = (AxonSeg_1_img-AxonSeg_2_img);
% % False_axons_img = imfill(False_axons_img,'holes');

% False_axons_img = find_removed_axons(AxonSeg_1_img, AxonSeg_2_img);

True_axons_img = AxonSeg_2_img;
% % True_axons_img = imfill(True_axons_img,'holes');
% % 
% % 
% % AxonSeg_1_img = imfill(AxonSeg_1_img,'holes');

% Compute stats (parameters of interest) for both groups

[Stats_1, names1] = as_stats_axons(False_axons_img);
[Stats_2, names2] = as_stats_axons(True_axons_img);
[Stats_3, names3] = as_stats_axons(AxonSeg_1_img);

% Only keep parameters wanted for discrimination analysis

Stats_1_used = rmfield(Stats_1,setdiff(names1, parameters));
Stats_2_used = rmfield(Stats_2,setdiff(names2, parameters));
Stats_3_used = rmfield(Stats_3,setdiff(names3, parameters));


% Perform Discrimination Analysis once with default cost matrix

% [classifier_init,~] = Discr_Analysis(Stats_1_used, Stats_2_used, [0, 1; 1, 0],type);


% Find cost needed to have more than 99% of true axons accepted

% cost = find_cost(classifier_init,val);


[classifier_final,~] = Discr_Analysis(Stats_1_used, Stats_2_used, [0, 1; val, 0],type);

Stats_3_used = table2array(struct2table(Stats_3_used));
[label,~,~] = predict(classifier_final,Stats_3_used);

% Recalculate Discrimination Analysis using the newly found cost value


% Class_table_init = confusionmat(classifier_init.Y,resubPredict(classifier_init));
Class_table_final = confusionmat(classifier_final.Y,resubPredict(classifier_final));


% probleme dans bwlabel du AxonSeg_1_img

index1=find(label==1);
Rejected_axons_img = ismember(bwlabel(AxonSeg_1_img),index1);

index2=find(label==2);
Accepted_axons_img = ismember(bwlabel(AxonSeg_1_img),index2);



% num_tot = bwconncomp(AxonSeg_1_img);
% num_rejected = bwconncomp(Rejected_axons_img);
% num_accepted = bwconncomp(Accepted_axons_img);

% 
% index1=find(label2==1);
% Rejected_axons_img = ismember(bwlabel(False_axons_img),index1);
% 
% index2=find(label2==2);
% Accepted_axons_img = ismember(bwlabel(True_axons_img),index2);

% sc(ismember(bwlabel(True_axons_img),index1))

figure(1);
subplot(221);
imshow(Rejected_axons_img);
title('Rejected axons');
subplot(222);
imshow(Accepted_axons_img);
title('Accepted axons');
subplot(223);
imshow(False_axons_img);
title('False axons');
subplot(224);
imshow(True_axons_img);
title('True axons');

plot_data_DiscrAnalysis(classifier_final, Stats_1_used, Stats_2_used, parameters, type);
    
end










% Plot variables in matrix

% visualize_DiscrAnalysis(classifier_final,names3);




% sc(ismember(bwlabel(True_axons_img),index1))
% index1=find(label1==2);
% sc(ismember(bwlabel(True_axons_img),index1))
% index1=find(label1==1);
% sc(ismember(bwlabel(True_axons_img),index1))
% index1=find(label1==2);
% sc(ismember(bwlabel(True_axons_img),index1))
