% guideline_script_AST

% create a test folder containing, cropped results, full results, axonlist
% in both, SegParameters, control for validation test



% Load an axonlist structure



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



% clean axonlist to select only fibers with axon diameter higher than mean
% diameter

axonlist_2=axonlist(:).axonEquivDiameter>diam_mean;







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

bw_axonseg=as_display_label(axonlist,size(img),'myelinThickness','myelin'); 
display_3=sc(sc(bw_axonseg,'hot')+sc(img));
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


% calculate myelin volume fraction (MVF) in an image

total_area=size(img,1)*size(img,2);

bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','myelin');
img_BW_myelins=im2bw(bw_axonseg,0);

myelin_area=sum(sum(img_BW_myelins));

MVF=myelin_area/total_area;







