function [axonInitialBW, ellip] = axonValidatePerimeterRatio(axonInitialBW, ellipThrsh)
% Rejection rules:
% 	- objects with normalized properties distance > distThrsh
%       distThrsh = 11 keeps 95% as determined from ground truth
%       distThrsh = 30 keeps 100% as determined from ground truth

% Use normalised properties distance threshold

[Stats_struct,~] = as_stats_axons(axonInitialBW);
ellip=Stats_struct.AAchRatio;

[a,b]=bwlabel(axonInitialBW);
p=find(ellip<ellipThrsh);
axonInitialBW(ismember(a,p)==1)=0;

