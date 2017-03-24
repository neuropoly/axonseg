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

[cc,num1] = bwlabel(AxonSeg_img,8);
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
Perimeter_ConvexHull=zeros(num1,1);

for i=1:num1
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
    
    se = strel('disk',2);
    AxonSeg_gray=im2double(AxonSeg_gray);
    
    Intensity_mean=zeros(num1,2);
    Intensity_std=zeros(num1,2);
    Skewness=zeros(num1,2);
    
    Intensity_mean_axon=zeros(num1,2);
    Intensity_std_axon=zeros(num1,2);
    
    % Axon_diam=[props.EquivDiameter]';
    % Myelin_diam=(Axon_diam/0.6)-Axon_diam;
    % Myelin_diam=round(Myelin_diam);
    %
    % for j=1:num1
    %
    %     if Myelin_diam(j)==0, Myelin_diam(j)=1; end
    % %     if Myelin_diam(j)>=25, Myelin_diam(j)=25; end
    %
    % end
    
    j_progress('Loop over axons (DISCRIMINANT ANALYSIS)...')
    
    for i=1:num1
        j_progress(i/num1)
        
        
        object_i=cc==i;
        
        %     se = strel('disk',Myelin_diam(i));
        
        object_dilated_i=imdilate(object_i,se);
        diff_i=object_dilated_i & ~object_i;
        
        Gray_object_i = AxonSeg_gray(diff_i);
        Skewness(i,2)=skewness(Gray_object_i);
        
        Intensity_mean(i,1)=i;
        Intensity_std(i,1)=i;
        
        Intensity_mean(i,2)=mean(Gray_object_i);
        Intensity_std(i,2)=std(Gray_object_i);
        
        
        
        
        
        
        Gray_object_i_axon = AxonSeg_gray(object_i);
        
        Intensity_mean_axon(i,1)=i;
        Intensity_std_axon(i,1)=i;
        Skewness(i,1)=i;
        
        Intensity_mean_axon(i,2)=mean(Gray_object_i_axon);
        Intensity_std_axon(i,2)=std(Gray_object_i_axon);
    end
    j_progress('Elapsed...')
    
    
    Stats_struct.Intensity_mean = Intensity_mean_axon(:,2);
    Stats_struct.Intensity_std = Intensity_std_axon(:,2);
    Stats_struct.Neighbourhood_mean = Intensity_mean(:,2);
    Stats_struct.Neighbourhood_std = Intensity_std(:,2);
    Stats_struct.Skewness=Skewness(:,2);
    
    Contrast=zeros(num1,2);
    Contrast(:,1)=Intensity_mean(:,1);
    Contrast(:,2)=Intensity_mean(:,2)-Intensity_mean_axon(:,2);
    
    Stats_struct.Contrast = Contrast(:,2);
    
end

% Stats_struct.PerimFraction = (Perimeter_ConvexHull-Perimeter)./Perimeter;

% Get the parameters names for future use
var_names = fieldnames(Stats_struct);

end




