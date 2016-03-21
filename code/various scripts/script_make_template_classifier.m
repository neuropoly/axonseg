
%% for each training data made, calculate stats for DA & make DA vectors X &
% species for classification

img_path_1 = uigetimagefile;
axonSeg_step1 = imread(img_path_1);

img_path_2 = uigetimagefile;
axonSeg_segCorrected = imread(img_path_2);

img_path_3 = uigetimagefile;
axonSeg_gray = imread(img_path_3);

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

% % Only keep parameters wanted for discrimination analysis
% Stats_1_used = rmfield(Stats_1,setdiff(names1, parameters));
% Stats_2_used = rmfield(Stats_2,setdiff(names2, parameters));

% Perform Discrimination Analysis once with an initial cost matrix (we use
% the matrix [0, 1; 10, 0] because we want the more ROC data possible, so
% with the find_cost function, we can end up with a cost matrix of [0, 300;
% 10, 0].

[X,species] = make_data_DA(Stats_1, Stats_2);

%%

X_global = X;
species_global = species;


X_global = [X_global; X];
species_global = [species_global; species];




%%

% Perform the discriminant analysis & create the classifier

classifier = fitcdiscr(X,species,'DiscrimType',type,'Cost',Cost_matrix);




[classifier_init,~] = Discr_Analysis(Stats_1_used, Stats_2_used, [0, 1; 10, 0],type);

% Find cost needed to have more than val of true axons accepted & get the
% ROC values that can be used later for analysis of the ROC curve
[cost,ROC_values] = find_cost(classifier_init,val);

% Make a discriminant analysis with the optimized cost given by find_cost()
[classifier_final,~] = Discr_Analysis(Stats_1_used, Stats_2_used, [0, 1; cost, 0],type);









