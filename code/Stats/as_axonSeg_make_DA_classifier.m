function [classifier, parameters,ROC_values] = as_axonSeg_make_DA_classifier(axonSeg_step1,axonSeg_segCorrected,axonSeg_gray, parameters,type,val)
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
% Example : [Rejected_axons_img, Accepted_axons_img, classifier_final, Classification, Sensitivity, Specificity, parameters] = as_axonseg_validate(axonSeg_step1,axonSeg_segCorrected,{'Circularity','EquivDiameter'},'linear',0.9);

%--------------------------------------------------------------------------
% % 
% img_path_1 = uigetimagefile;
% img = imread(img_path_1);
% 
% img_path_2 = uigetimagefile;
% axonSeg_segCorrected = imread(img_path_2);

%---PART 1 - PERFORM A DISCRIMINANT ANALYSIS ------------------------------

% Validate both images are binary
AxonSeg_1_img = im2bw(axonSeg_step1);
AxonSeg_2_img = im2bw(axonSeg_segCorrected);

% Find removed objects (axons) from initial seg. to corrected seg.
False_axons_img = im2bw(AxonSeg_1_img-AxonSeg_2_img);
False_axons_img = bwmorph(False_axons_img,'clean');

% False_axons_img2 = find_removed_axons(AxonSeg_1_img, AxonSeg_2_img);
True_axons_img = AxonSeg_2_img;
True_axons_img = bwmorph(True_axons_img,'clean');

% Compute stats (parameters of interest) for both groups
[Stats_1, names1] = as_stats_axons(False_axons_img,axonSeg_gray);
[Stats_2, names2] = as_stats_axons(True_axons_img,axonSeg_gray);

% Only keep parameters wanted for discrimination analysis
Stats_1_used = rmfield(Stats_1,setdiff(names1, parameters));
Stats_2_used = rmfield(Stats_2,setdiff(names2, parameters));

% Perform Discrimination Analysis once with an initial cost matrix (we use
% the matrix [0, 1; 10, 0] because we want the more ROC data possible, so
% with the find_cost function, we can end up with a cost matrix of [0, 300;
% 10, 0].
[classifier_init,~] = Discr_Analysis(Stats_1_used, Stats_2_used, [0, 1; 10, 0],type);

% Find cost needed to have more than val of true axons accepted & get the
% ROC values that can be used later for analysis of the ROC curve
[cost_max,ROC_values] = find_cost(classifier_init,val);

% % Make a discriminant analysis with the optimized cost given by find_cost()
% [classifier_final,~] = Discr_Analysis(Stats_1_used, Stats_2_used, [0, 1; cost, 0],type);

classifier=cell(cost_max,1);

for m=1:cost_max
[classifier{m},~] = Discr_Analysis(Stats_1_used, Stats_2_used, [0, 1; m, 0],type);
end
