%-------------------------------------------------------------------------%
% Name: as_tutorial.                                                      %
% Description: The purpose of this script is to help new users of AxonSeg %
% start exploring the functions and utilities.                            %
%                                                                         %
%                                                                         %
%                                                                         %
%-------------------------------------------------------------------------%


%% PART 1 - LOAD TEST IMAGE AND SEGMENT AXONS AND MYELIN BY USING THE SEGMENTATION GUI

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


%% PART 3 - EXPLORE AXON AND MYELIN DISPLAY OPTIONS AVAILABLE

% Produce an axon display colorcoded for axon diameter on initial gray
% image

bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','axon'); 
display_1=sc(sc(bw_axonseg,'hot')+sc(img));
imshow(display_1);

% display axon colorcoded for axon number

bw_axonseg=as_display_label(axonlist,size(img),'axon number','axon'); 
display_2=sc(sc(bw_axonseg,'hot')+sc(img));
imshow(display_2);

% display myelin colorcoded for myelin thickness

bw_axonseg=as_display_label(axonlist,size(img),'myelinThickness','axon'); 
display_3=sc(sc(bw_axonseg,'hot')+sc(img));
imshow(display_3);

% display myelin colorcoded for g-ratio

bw_axonseg=as_display_label(axonlist,size(img),'gRatio','myelin'); 
display_4=sc(sc(bw_axonseg,'hot')+sc(img));
imshow(display_4);

% change colormap for same display

bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','axon'); 
display_5=sc(sc(bw_axonseg,'thermal')+sc(img));
imshow(display_5);

% Save last display to current folder

imwrite(display_1,'Axon_display.tif');

% Get the binary image of axon objects

bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
img_BW_axons=im2bw(bw_axonseg,0);
imshow(img_BW_axons);

imwrite(img_BW_axons,'AxonMask_AxonSeg.tif');

% Get the binary image of myelin objects

bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','myelin');
img_BW_myelins=im2bw(bw_axonseg,0);
imshow(img_BW_myelins);

imwrite(img_BW_myelins,'MyelinMask_AxonSeg.tif');

% Get the binary image of entire fibers (axon + myelin)

bw_axonseg_axons=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
bw_axonseg_myelins=as_display_label(axonlist,size(img),'axonEquivDiameter','myelin');

img_BW_fibers=im2bw(bw_axonseg_axons+bw_axonseg_myelins,0);
imshow(img_BW_fibers);

% Use fiber binary image as mask to select fibers in gray image

fibers_extract=uint8(img_BW_fibers).*img;
imshow(fibers_extract);
imwrite(fibers_extract,'fibers_masked.tif');


%% PART 4 - Filter final axonlist results depending on a parameter/feature

% Remove axons larger than a certain size (for example 10 um here) from the axonlist
axonlist([axonlist.axonEquivDiameter]>10)=[];

% You can do a similar operation in order to remove the smallest axons
axonlist([axonlist.axonEquivDiameter]<0.5)=[];

% You can apply the same method in order to filter the axonlist based on a
% specific metric, for instance the gRatio here
axonlist([axonlist.gRatio]>0.9)=[];

%% PART 5 - Correct the axonal mask and redo the myelin segmentation with the modified mask

% If the axon segmentation is not good enough, you can manually correct it
% on another image processing software (for instance GIMP) by adding,
% removing or modifying the axon shapes. Then, you can resegment the myelin
% by using the new axonal mask (axon_mask.tif).

AxonSeg({'test_image_OM.tif','axon_mask.tif'},'SegParameters.mat','-nogui');

% convert axonlist into excel file
axontable = struct2table(axonlist);
axontable.axonID=[];
axontable.data=[];
writetable(axontable);

%% PART 6 - ROI STATS EXTRACTION

% create and load a RGB mask with different ROIs

mask=imread('mask_2.png');
imshow(mask);

% Register the mask on the image

[mask_reg_labeled, P_color]=as_reg_mask(mask,img);

% Get indexes of axons belonging to each ROI of the mask in order to
% compute statistics

[indexes,mask_stats]=as_stats_mask_labeled_2(axonlist, mask_reg_labeled,0.1);

% Compute statistics for each ROI and plot results
as_stats_barplot_2(mask_stats,P_color);


as_stats_barplot(axonlist,indexes,P_color);

[mean_gap_axon]=gap_axons(axonlist,PixelSize,3);


%% PART 7 - MISC

% calculate myelin volume fraction (MVF) in an image

total_area=size(img,1)*size(img,2);

bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','myelin');
img_BW_myelins=im2bw(bw_axonseg,0);

myelin_area=nnz(img_BW_myelins);

MVF=myelin_area/total_area;



















