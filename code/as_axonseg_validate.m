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

[Stats_1, names1] = as_stats_axons(False_axons_img);
[Stats_2, names2] = as_stats_axons(True_axons_img);

% Perform Discrimination Analysis once with default cost matrix

[label,score, classifier] = Discr_Analysis(Stats_1, Stats_2, [0, 1; 1, 0]);

% Find cost needed to have more than 99% of true axons accepted

cost = find_cost(classifier,99);

% Recalculate Discrimination Analysis using the newly found cost value
[label2,score, classifier2] = Discr_Analysis(Stats_1, Stats_2, [0, 1; cost, 0]);


R2 = confusionmat(classifier2.Y,resubPredict(classifier));

% X_labeled = [label, X];

index1=find(label2==1);
Rejected_axons_img = ismember(bwlabel(False_axons_img),index1);

index2=find(label2==2);
Accepted_axons_img = ismember(bwlabel(True_axons_img),index2);

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

% Plot variables in matrix

visualize_DiscrAnalysis(classifier2,names1);




% sc(ismember(bwlabel(True_axons_img),index1))
% index1=find(label1==2);
% sc(ismember(bwlabel(True_axons_img),index1))
% index1=find(label1==1);
% sc(ismember(bwlabel(True_axons_img),index1))
% index1=find(label1==2);
% sc(ismember(bwlabel(True_axons_img),index1))
