function [BW_axonseg_corrected] = as_validate_LevelSet_values(BW_axonseg)
% Rejection rules:



% Obtain region properties for currently segmented axons
axonProps = regionprops(BW_axonseg, {'Area','Perimeter'});



Area=[axonProps.Area]';
Perimeter=[axonProps.Perimeter]';
Circ=4*pi*Area./(Perimeter.^2);


% index_elim = find(isnan(Circ) | isinf(Circ));
% 
% 
% BW_axonseg_corrected = Set_1(~any(isnan(Set_1) | isinf(Set_1), 2),:);
% Set_2 = Set_2(~any(isnan(Set_2) | isinf(Set_2), 2),:);



% Set_2(indexes_1x,:) = [];
% Set_1(indexes_2x,:) = [];





[a,b]=bwlabel(BW_axonseg);
p=find(isnan(Circ) | Circ==Inf);
BW_axonseg_corrected(ismember(a,p)==1)=0;
%
c=1;



