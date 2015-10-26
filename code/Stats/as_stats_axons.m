function Stats_struct = as_stats_axons(AxonSeg_img)
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



%---
cc = bwconncomp(AxonSeg_img, 4);
props = regionprops(cc,{'Area', 'Perimeter', 'EquivDiameter', 'Solidity', 'MajorAxisLength', 'MinorAxisLength','Eccentricity'});

Area=[props.Area]';
Perimeter=[props.Perimeter]';
Circularity=4*pi*Area./(Perimeter.^2);

Major=[props.MajorAxisLength]';
Minor=[props.MinorAxisLength]';
Ratio=Minor./Major;


Stats_struct = struct;


% columnNames = {'Area in pixels', 'Perimeter in pixels', 'Circularity', 'Equivalent diameter', ...
%     'Solidity', 'Major Axis in pixels', 'Minor Axis in pixels'};
% 
% 
% Stats_matrix(1,1) = 'Area in pixels';
% Stats_matrix(1,2) = 'Perimeter in pixels';
% Stats_matrix(1,3) = 'Circularity';
% Stats_matrix(1,4) = 'Diameter';
% Stats_matrix(1,5) = 'Solidity';
% Stats_matrix(1,6) = 'Major Axis';
% Stats_matrix(1,7) = 'Minor Axis';

Stats_struct.Area = Area;
Stats_struct.Perimeter = Perimeter;
Stats_struct.Circularity = Circularity;
Stats_struct.EquivDiameter = cat(1,props.EquivDiameter);
Stats_struct.Solidity = cat(1,props.Solidity);
Stats_struct.MajorAxisLength = cat(1,props.MajorAxisLength);
Stats_struct.MinorAxisLength = cat(1,props.MinorAxisLength);
Stats_struct.MinorMajorRatio = Ratio;
Stats_struct.Eccentricity = cat(1,props.Eccentricity);

end



