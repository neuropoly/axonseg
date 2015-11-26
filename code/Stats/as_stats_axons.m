function [Stats_struct,var_names] = as_stats_axons(AxonSeg_img,AxonSeg_gray)
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

[cc,num] = bwlabel(AxonSeg_img,8);
props = regionprops(cc,{'Area', 'Perimeter', 'EquivDiameter', 'Solidity', 'MajorAxisLength',...
    'MinorAxisLength','Eccentricity','ConvexArea','Orientation','Extent','FilledArea','ConvexImage','ConvexHull'});

Area=[props.Area]';
Perimeter=[props.Perimeter]';
Circularity=4*pi*Area./(Perimeter.^2);

Major=[props.MajorAxisLength]';
Minor=[props.MinorAxisLength]';
Ratio=Minor./Major;

% Create a struct for all the stats computed
Stats_struct = struct;

% Fill the struct fields with the computed stats
Stats_struct.Area = Area;
Stats_struct.Perimeter = Perimeter;
Stats_struct.Circularity = Circularity;
Stats_struct.EquivDiameter = cat(1,props.EquivDiameter);
Stats_struct.Solidity = cat(1,props.Solidity);
Stats_struct.MajorAxisLength = cat(1,props.MajorAxisLength);
Stats_struct.MinorAxisLength = cat(1,props.MinorAxisLength);
Stats_struct.MinorMajorRatio = Ratio;
Stats_struct.Eccentricity = cat(1,props.Eccentricity);
Stats_struct.ConvexArea = cat(1,props.ConvexArea);
Stats_struct.Orientation = cat(1,props.Orientation);
Stats_struct.Extent = cat(1,props.Extent);
Stats_struct.FilledArea = cat(1,props.FilledArea);


% Calculate the perimeter of the convex hull of each object
Perimeter_ConvexHull=zeros(num,1);

for i=1:num
    Perimeter_image=bwperim(props(i).ConvexImage,8);
    Perimeter_ConvexHull(i,:) = sum(Perimeter_image(:));
end

% Add the new stat to the stats struct
Stats_struct.Perimeter_ConvexHull=Perimeter_ConvexHull;

% Compute the perimeter & area ratios (convex hull) & add them to the
% struct

Stats_struct.PPchRatio=Perimeter./Perimeter_ConvexHull;
Stats_struct.AAchRatio=Area./Stats_struct.ConvexArea;

% If a gray level image is in input, also do intensity stats (mean
% intensity & std of each object of the binary image).

if nargin==2

    AxonSeg_gray=im2double(AxonSeg_gray);

    Intensity_means=zeros(num,1);
    Intensity_std=zeros(num,1);
    
    for i=1:num        
        Gray_object_values = AxonSeg_gray(cc==i);
        Intensity_means(i,:)=mean(Gray_object_values);
        Intensity_std(i,:)=std(Gray_object_values); 
    end

    Stats_struct.Intensity_mean = Intensity_means;
    Stats_struct.Intensity_std = Intensity_std;

end


% Get the parameters names for future use
var_names = fieldnames(Stats_struct);

end



