function [Rejected_axons_img, Accepted_axons_img] = as_axonseg_validate(axonSeg_step1,axonSeg_segCorrected)

%--------------------------------------------------------------------------

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

False_axons_img = find_removed_axons(AxonSeg_1_img, AxonSeg_2_img);
True_axons_img = AxonSeg_2_img;

% Compute stats (parameters of interest) for both groups

Stats_1 = as_stats_axons(False_axons_img);
Stats_2 = as_stats_axons(True_axons_img);

% Perform Discrimination Analysis once with default cost matrix

[label,score, classifier] = Discr_Analysis(Stats_1, Stats_2, [0, 1; 1, 0]);

% Find cost needed to have more than 99% of true axons accepted

cost = find_cost(classifier,99);

% Recalculate Discrimination Analysis using the newly found cost value
[label,score, classifier] = Discr_Analysis(Stats_1, Stats_2, [0, 1; cost, 0]);


X_labeled = [label, X];


Rejected_axons_img = find(X_labeled(:,1)==1);
Accepted_axons_img = find(X_labeled(:,1)==2);



% sc(ismember(bwlabel(True_axons_img),index1))
% index1=find(label1==2);
% sc(ismember(bwlabel(True_axons_img),index1))
% index1=find(label1==1);
% sc(ismember(bwlabel(True_axons_img),index1))
% index1=find(label1==2);
% sc(ismember(bwlabel(True_axons_img),index1))
