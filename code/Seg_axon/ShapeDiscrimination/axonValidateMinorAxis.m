function [axonInitialBW, minor] = axonValidateMinorAxis(axonInitialBW, thresh)
% Rejection rules:
% 	- objects with normalized properties distance > distThrsh
%       distThrsh = 11 keeps 95% as determined from ground truth
%       distThrsh = 30 keeps 100% as determined from ground truth

% Use normalised properties distance threshold


[cc,num] = bwlabel(axonInitialBW,8);
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


autre=(Stats_struct.Circularity+Stats_struct.Solidity)/2;

p=find(autre<thresh);
axonInitialBW(ismember(cc,p)==1)=0;

