function [axonInitialBW, minor] = axonValidateMinorAxis(axonInitialBW, ellipThrsh)
% Rejection rules:
% 	- objects with normalized properties distance > distThrsh
%       distThrsh = 11 keeps 95% as determined from ground truth
%       distThrsh = 30 keeps 100% as determined from ground truth

% Use normalised properties distance threshold


% Obtain region properties for currently segmented axons
axonProp = regionprops(axonInitialBW, 'Area','Perimeter','Eccentricity','Solidity','MajorAxisLength','MinorAxisLength');

% Area=[axonProp.Area]';
% Perimeter=[axonProp.Perimeter]';
% circu=4*pi*Area./(Perimeter.^2);

MinorAxis = [axonProp.MinorAxisLength]';
minor = MinorAxis;
[a,b]=bwlabel(axonInitialBW);
p=find(MinorAxis<ellipThrsh);
axonInitialBW(ismember(a,p)==1)=0;

