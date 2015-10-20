
%% Select image file to be segmented by the segmentation GUI---------------

file_img = uigetimagefile;
[PATHSTR,NAME,EXT] = fileparts(file_img);

%% Auto seg of the image by the SegmentationGUI----------------------------

SegmentationGUI(file_img);

%% Get axonlist of the resulting segmentation------------------------------

axonlist_filepath = [PATHSTR filesep 'results_croped' filesep 'axonlist.mat'];
load(axonlist_filepath);

% Create template (labelled) image for axon segmentation

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


% statis=as_stats(imread(AxonSeg_img),1);

% %%
% 
% 
% 
% directoryname = uigetdir(pwd,'Select directory with SegmentationGUI results');
% load('/Users/alzaia/Desktop/test_images_seg/results_croped/axonlist.mat');
% 
% bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
% 
% imwrite(~~bw_axonseg,'/Users/alzaia/Desktop/test_images_seg/AxonSeg7.tif');
% imwrite(img,'/Users/alzaia/Desktop/test_images_seg/img7.tif');
% ManualCorrectionGUI /Users/alzaia/Desktop/test_images_seg/img7.tif /Users/alzaia/Desktop/test_images_seg/AxonSeg7.tif;
% s = eval_sensitivity(imread('/Users/alzaia/Desktop/test_images_seg/AxonSeg7.tif'),imread('/Users/alzaia/Desktop/test_images_seg/AxonSeg7_cor.tif'));
% 
% %%
% 
% 
% 
% SegmentationGUI;
% [FileName,PathName] = uigetimagefile;
% load('axonlist.mat');
% 
% 
% bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
% 
% imshow(img);
% imshow(bw_axonseg);
% imagesc(bw_axonseg);
% imagesc(bw_axonseg+img);
% 
% 
% imwrite(~~bw_axonseg,'AxonSeg6.tif');
% imwrite(img,'img6.tif');
% ManualCorrectionGUI img6.tif AxonSeg6.tif;
% 
% s = eval_sensitivity(imread('AxonSeg6.tif'),imread('AxonSeg6_cor.tif'));
% 
% %%
% 
% [FileName,PathName,FilterIndex] = uigetfile('*.jpeg*','Select all images you want to segment','MultiSelect','on');
% numfiles = size(FileName,2);
% 
% if iscell(FileName)
%     numfiles = length(FileName);
% elseif FileName~=0
%     numfiles = 1;
% else
%     numfiles = 0;
% end
% 
% 
% for ii = 1:numfiles
%     entirefile=fullfile(PathName,FileName{ii});
%     Im = imread(entirefile);
%     SegmentationGUI entirefile
% end  
% 











