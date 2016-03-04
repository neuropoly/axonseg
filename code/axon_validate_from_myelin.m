function [Stats_struct,var_names] = axon_validate_from_myelin(BW_axon,BW_myelin)
% Description : This function calculates the sensitivity of the axon
% segmentation performed by SegmentationGUI by comparing the result with
% the image obtained by correcting the segmentation (by using
% ManualCorrectionGUI).
% Auto_seg_img : IN (BW Image obtained by SegmentationGUI)
% Corrected_seg_img : IN (BW Image obtained by ManualCorrectionGUI)
%
% sensitivity : OUT (Scalar giving sensitivity between the 2 images)
%
% sensitivity = eval_sensitivity(Auto_seg_img, Corrected_seg_img)
% Example: sensitivity = eval_sensitivity(axonseg, axonseg_corrected)

% Auto_seg_img = AxonSeg;
% Corrected_seg_img = AxonSeg_cor;

% TEST IF INPUT IS LOGICAL ****
% assert(islogical(AxonSeg_img),'Image input should be logical');


% Get all the stats that have scalar values with regionprops function (we
% need bwlabel here instead of bwconncomp because we als calculate the
% intensities means & stds so we need labeled objects).

img_path_1 = uigetimagefile;
BW_axon = imread(img_path_1);

img_path_2 = uigetimagefile;
BW_myelin = imread(img_path_2);


%% find circles

A = imread('circlesBrightDark.png');

[centers,radii] = imfindcircles(BW_myelin,[10,100]);

figure, imshow(BW_myelin);
hold on;
plot(centers(:,1),centers(:,2),'r*');
hold off;


test=bwmorph(BW_myelin,'skel','1');
imshow(test);

test=bwmorph(BW_myelin,'bothat');
imshow(test);

test=bwmorph(BW_myelin,'erode');
test=bwmorph(test,'erode');
imshow(test);

test=bwmorph(BW_myelin,'majority');
imshow(test);


test=bwmorph(BW_myelin,'tophat');
imshow(test);





test=bwmorph(BW_axon,'skel','1');
imshow(test);

test=bwmorph(BW_axon,'bothat');
imshow(test);

test=bwmorph(BW_axon,'erode');
test=bwmorph(test,'erode');
imshow(test);

test=bwmorph(BW_axon,'majority');
imshow(test);


test=bwmorph(BW_myelin,'remove');
imshow(test);

BW = imregionalmax(BW_myelin);
imshow(BW);


%%

test=bwboundaries(BW_myelin);
imshow(test);

se=strel('disk',3);
BW_myelin_erosion = imerode(BW_myelin,se);
imshow(BW_myelin_erosion);

test=im2bw(BW_myelin-BW_myelin_erosion);
imshow(test);
BW_myelin=test;



test=bwdist(imcomplement(BW_myelin));
sc(test);
test=imcomplement(test);
sc(test);
seg=watershed(test);

sss=BW_myelin;
sss(seg == 0) = 0;
imshow(sss); 

% axon

test=bwdist(imcomplement(BW_axon));
sc(test);
test=imcomplement(test);
sc(test);
seg=watershed(test);

sss=BW_myelin;
sss(seg==0)=0;
imshow(sss);





%%

[cc1,num1] = bwlabel(BW_axon,8);
props1 = regionprops(cc1,{'Centroid'});

[cc2,num2] = bwlabel(BW_myelin,8);
props2 = regionprops(cc2,{'Centroid'});


centroids_axons = cat(1,props1.Centroid);
centroids_myelins = cat(1,props2.Centroid);


figure, imshow(imfuse(BW_axon,BW_myelin));
hold on;
plot(centroids_axons(:,1),centroids_axons(:,2),'r*');
hold on;
plot(centroids_myelins(:,1),centroids_myelins(:,2),'m*');
hold off;



end













