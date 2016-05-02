%-------------------------------------------------------------------------%
% Name: AST_guideline_script.                                             %
% Description: The purpose of this script is to help new users of AST     %
% start exploring the functions and utilities.                            %
%                                                                         %
%                                                                         %
%-------------------------------------------------------------------------%

% Evaluate This script line by line
% Tutorial to manipulate axonlist structure


%% PART 1 - LOAD SEGMENTATION RESULTS

% load Segmentation Results (be patient.. can take some time)
load('myelin_seg_results_cleaned.mat');


%% PART 2 - EXPLORE AXONLIST STRUCTURE FOR MORPHOMETRY ANALYSIS OF THE DATA


% number of axons segmented :
nbaxons = length(axonlist);
disp(['number of axons segmented : ' num2str(nbaxons) ' axons']);

% See the stats available:
axonlist

% Extract axon diameters for all axons in axonlist
Axon_diameters = cat(1,axonlist.axonEquivDiameter);

% Plot distribution of stats in histogram (50 bins)

figure;
hist(Axon_diameters,50);

% Calculate stats of distribution

diam_mean=mean(Axon_diameters);
disp(['mean axon diameter in this image is : ' num2str(diam_mean) ' µm'])
diam_std=std(Axon_diameters);
disp(['axon diameter standard deviation in this image is : ' num2str(diam_std) ' µm'])


% Remove axons larger than 15 µm
axonlist_2=axonlist(Axon_diameters<15);
disp(['number of axons segmented (<15µm) : ' num2str(nbaxons) ' axons']);

%% PART 2 - EXTRACT STATS OF A PARTICULAR ROI




%% PART 3 - EXPLORE AXON AND MYELIN DISPLAY OPTIONS AVAILABLE



% Produce an axon display colorcoded for axon diameter on initial gray
% image

bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','axon'); 
sc2(sc2(bw_axonseg,'hot')+sc2(img))
% display axon colorcoded for axon number

bw_axonseg=as_display_label(axonlist,size(img),'axon number','axon'); 
display_2=sc2(sc2(bw_axonseg,'hot')+sc2(img));
imshow(display_2);

% display myelin colorcoded for myelin thickness

bw_axonseg=as_display_label(axonlist,size(img),'myelinThickness','myelin'); 
display_3=sc2(sc2(bw_axonseg,'hot')+sc2(img));
imshow(display_3);

% display myelin colorcoded for g-ratio

bw_axonseg=as_display_label(axonlist,size(img),'gRatio','myelin'); 
display_4=sc(sc(bw_axonseg,'hot')+sc(img));
imshow(display_4);

% display both axon and myelin colorcoded for axon diameter

bw_axonseg_1=as_display_label(axonlist,size(img),'axonEquivDiameter','axon'); 
bw_axonseg_2=as_display_label(axonlist,size(img),'axonEquivDiameter','myelin'); 

display_4=sc(sc(bw_axonseg_1,'hot')+sc(bw_axonseg_2,'hot')+sc(img));
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

% Get the binary image of myelin objects

bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','myelin');
img_BW_myelins=im2bw(bw_axonseg,0);
imshow(img_BW_myelins);

% Get the binary image of entire fibers (axon + myelin)

bw_axonseg_axons=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
bw_axonseg_myelins=as_display_label(axonlist,size(img),'axonEquivDiameter','myelin');

img_BW_fibers=im2bw(bw_axonseg_axons+bw_axonseg_myelins,0);
imshow(img_BW_fibers);


% Use fiber binary image as mask to select fibers in gray image


fibers_extract=uint8(img_BW_fibers).*img;
imshow(fibers_extract);
imwrite(fibers_extract,'fibers_masked.tif');


%% WARP STATS FROM HISTOLOGY TO MRI

%% PART 1 - 

% calculate myelin volume fraction (MVF) in an image

total_area=size(img,1)*size(img,2);

bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','myelin');
img_BW_myelins=im2bw(bw_axonseg,0);

myelin_area=sum(sum(img_BW_myelins));

MVF=myelin_area/total_area;






