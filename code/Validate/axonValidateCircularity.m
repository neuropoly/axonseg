function [axonInitialBW, circu] = axonValidateCircularity(axonInitialBW, cirThrsh)
% Rejection rules:
% 	- objects with normalized properties distance > distThrsh
%       distThrsh = 11 keeps 95% as determined from ground truth
%       distThrsh = 30 keeps 100% as determined from ground truth

% Use normalised properties distance threshold


axonProp = regionprops(axonInitialBW, 'Area','Perimeter','Eccentricity','Solidity');
Area=[axonProp.Area]';
Perimeter=[axonProp.Perimeter]';
circu=4*pi*Area./(Perimeter.^2);

[a,b]=bwlabel(axonInitialBW);
p=find(circu<cirThrsh);
axonInitialBW(ismember(a,p)==1)=0;

