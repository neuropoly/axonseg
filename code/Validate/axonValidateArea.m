function [axonInitialBW, circu] = axonValidateArea(axonInitialBW, min_area)
% Rejection rules:
% 	- objects with normalized properties distance > distThrsh
%       distThrsh = 11 keeps 95% as determined from ground truth
%       distThrsh = 30 keeps 100% as determined from ground truth

% Use normalised properties distance threshold


% Obtain region properties for currently segmented axons
axonProp = regionprops(axonInitialBW, 'Area','Perimeter','Eccentricity','Solidity');

Area=[axonProp.Area]';

[a,b]=bwlabel(axonInitialBW);
p=find(Area<min_area);
axonInitialBW(ismember(a,p)==1)=0;

