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

% Use SegmentationGUI to perform axon and myelin on test image

SegmentationGUI test_image_OM.tif;

% After segmentation of a region of the image sample, you can launch the
% full segmentation 

as_Segmentation_full_image('test_image_OM.tif','SegParameters.mat');


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

%% PART 4 - MISC

% calculate myelin volume fraction (MVF) in an image

total_area=size(img,1)*size(img,2);

bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','myelin');
img_BW_myelins=im2bw(bw_axonseg,0);

myelin_area=nnz(img_BW_myelins);

MVF=myelin_area/total_area;



%% PART 5 - ROI STATS EXTRACTION

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





















