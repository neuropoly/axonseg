%--------------------------------------------------------------------------
% Description : Script that does the following actions :
% 1) User selects an image to be segmented with SegmentationGUI.m
% 2) Script runs SegmentationGUI for user
% 3) Script finds & loads axonlist produced by SegmentationGUI
% 4) Script creates template (labeled) image for axon segmentation
% 5) Script runs ManualCorrectionGUI with Original & AxonSeg images
% 6) Produce & save corrected image & evaluate sensitivity
%--------------------------------------------------------------------------

%% Select image file to be segmented by the segmentation GUI---------------

file_img = uigetimagefile;
[PATHSTR,NAME,EXT] = fileparts(file_img);

%% Auto seg of the image by the SegmentationGUI----------------------------

SegmentationGUI(file_img);

%% Get axonlist of the resulting segmentation------------------------------

axonlist_filepath = [PATHSTR filesep 'results_croped' filesep 'axonlist.mat'];
load(axonlist_filepath);

%% Create template (labelled) image for axon segmentation

bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');

Original_img = [PATHSTR filesep 'results_croped' filesep 'Original_img.tif'];
AxonSeg_img = [PATHSTR filesep 'results_croped' filesep 'AxonSeg.tif'];

imwrite(~~bw_axonseg,AxonSeg_img);
imwrite(img,Original_img);

%% Correct auto_seg by using ManualCorrectionGUI---------------------------

ManualCorrectionGUI(Original_img,AxonSeg_img);

%% Evaluate sensitivity of automatic segmentation of axons-----------------

AxonSeg_cor_img = [PATHSTR filesep 'results_croped' filesep 'AxonSeg_cor.tif'];

AxonSeg_sensitivity = eval_sensitivity(imread(AxonSeg_img),imread(AxonSeg_cor_img));
save([PATHSTR filesep 'results_croped' filesep 'Sensitivity.mat'],'AxonSeg_sensitivity');


AxonSeg_sensitivity = eval_sensitivity(imread(AxonSeg_img),imread(AxonSeg_cor_img));



statis_avant=as_stats_axonSeg(imread(AxonSeg_img),1);
statis_apres=as_stats_axonSeg(imread(AxonSeg_cor_img),1);

%%-------------------------------------------------------------------------
