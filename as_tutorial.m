%-------------------------------------------------------------------------%
% Name: as_tutorial.                                                      %
% Description: The purpose of this script is to help new users of AxonSeg %
% start exploring the functions and utilities.                            %
%                                                                         %
%                                                                         %
%                                                                         %
%-------------------------------------------------------------------------%


%% PART 1 - SEGMENT AXONS AND MYELIN USING AxonSeg GUI

% load and display test image

test=imread('test_image_OM.tif');
figure; imshow(test);

% Use AxonSeg to perform axon and myelin on test image

AxonSeg test_image_OM.tif;

% After segmentation, the segmentation parameters is saved (SegParameters.mat) you can segment new images using:

AxonSeg('test_image_OM.tif','SegParameters.mat','-nogui');


%% PART 2 - EXPLORE AXONLIST STRUCTURE FOR MORPHOMETRY ANALYSIS OF THE DATA

load('axonlist.mat');

% Extract a specific stat (axon diameters) for all axons in axonlist
Axon_diameters = cat(1,axonlist.axonEquivDiameter);

% Plot distribution of stats in histogram (50 bins)

figure;
hist(Axon_diameters,50);

% Calculate stats of distribution

diam_mean=mean(Axon_diameters);
diam_median=median(Axon_diameters);
diam_std=std(Axon_diameters);

diam_max=max(Axon_diameters);
diam_min=min(Axon_diameters);

%% PART 3 - Filter final axonlist results depending on a parameter/feature

% Remove axons larger than a certain size (for example 10 um here) from the axonlist
axonlist([axonlist.axonEquivDiameter]>15)=[];

% Remove axons that have >50% of their myelin in conflict with their
% other axons
axonlist([axonlist.conflict]>0.5)=[];

% You can apply the same method in order to filter the axonlist based on a
% specific metric, for instance the gRatio here
axonlist([axonlist.gRatio]>0.9)=[];

% Remove false positive axons detected in the background
% --> Manually draw a Polygon on your image and get the index of the axons found in this region:
[Index, Stats] = as_stats_Roi(axonlist, img);
% --> Remove these axons
axonlist(Index)=[];

%% PART 4 - EXPLORE AXON AND MYELIN DISPLAY OPTIONS AVAILABLE
% Note: If your image is very big (>20 megapixels), go to the end of this
% section, otherwise you will experience memory saturation

% Produce an axon display colorcoded for axon diameter on initial gray
% image
axonseg_ind=as_display_label(axonlist,size(img),'axonEquivDiameter','axon'); 
rgb=sc(sc(axonseg_ind,'hot')+sc(img));
imshow(rgb);

% display myelin colorcoded for g-ratio
myelinseg_ind=as_display_label(axonlist,size(img),'gRatio','myelin'); 
rgb=sc(sc(myelinseg_ind,'hicontrast')+sc(img));
imshow(rgb);

% Save last display to current folder
imwrite(rgb,'gratio_rgb.png');

% Get the binary image of entire fibers (axon + myelin)
bw_axonseg_axons=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
bw_axonseg_myelins=as_display_label(axonlist,size(img),'axonEquivDiameter','myelin');
img_BW_fibers=im2bw(bw_axonseg_axons+bw_axonseg_myelins,0);
imshow(img_BW_fibers);

% FOR LARGE IMAGES: to prevent memory saturation:
[~, RGB_hot]=as_display_label(axonlist,size(img),'gRatio','myelin');
% enhance img contrast, convert to RGB and display
img =imadjust(img);
img = repmat(img,[1 1 3]);
as_display_LargeImage(.5*RGB_hot+.5*img) % zoom by drawing a square

%% PART 5 - Correct the axonal mask and redo the myelin segmentation with the modified mask

% If the axon segmentation is not good enough, you can manually correct it
% on another image processing software (for instance GIMP) by adding,
% removing or modifying the axon shapes. Then, you can segment the myelin
% again using the new axonal mask (axon_mask.tif).

AxonSeg({'test_image_OM.tif','axon_mask.tif'},'SegParameters.mat','-nogui');

% convert axonlist into excel file
axontable = struct2table(axonlist);
axontable.axonID=[];
axontable.data=[];
writetable(axontable);

%% PART 6 - ROI STATS EXTRACTION

% SOLUTION 1: MANUALLY DRAW A POLYGON ON YOUR IMAGE
[Index, Stats] = as_stats_Roi(axonlist, img);


% SOLUTION 2: CREATE A LOW RESOLUTION COLOR-CODED ATLAS OF THE DIFFERENT REGIONS (E.G. USING POWERPOINT) AND
% REGISTER THE MASK

% create and load a RGB mask with different ROIs
mask=imread('mask.png');
imshow(mask);

% Register the mask on the image
[mask_reg_labeled, P_color]=as_reg_mask(mask,img);

% Get indexes of axons belonging to each ROI of the mask in order to
% compute statistics
[indexes,mask_stats]=as_stats_mask_labeled_2(axonlist, mask_reg_labeled,PixelSize);

% Compute statistics for each ROI and plot results
as_stats_barplot_2(mask_stats,P_color);

%% PART 7 - MISC

% calculate myelin volume fraction (MVF) in an image

total_area=size(img,1)*size(img,2);

bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','myelin');
img_BW_myelins=im2bw(bw_axonseg,0);

myelin_area=nnz(img_BW_myelins);

MVF=myelin_area/total_area;



















