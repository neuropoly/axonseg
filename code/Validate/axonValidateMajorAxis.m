function [axonInitialBW, major] = axonValidateMajorAxis(axonInitialBW, ellipThrsh)
% Uses MajorAxisLength property to discriminate between objects in binary
% image


% Use normalised properties distance threshold


% Obtain region properties for currently segmented axons
axonProp = regionprops(axonInitialBW, 'Area','Perimeter','Eccentricity','Solidity','MajorAxisLength','MinorAxisLength');

% Area=[axonProp.Area]';
% Perimeter=[axonProp.Perimeter]';
% circu=4*pi*Area./(Perimeter.^2);

MajorAxis = [axonProp.MajorAxisLength]';
major = MajorAxis;
[a,b]=bwlabel(axonInitialBW);
p=find(MajorAxis<ellipThrsh);
axonInitialBW(ismember(a,p)==1)=0;

