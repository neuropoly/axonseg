function [X,species] = make_data_discrAnalysis2(Stats_1, Stats_2)
% Pre-processing before using Discrimination Analysis
% [X,species] = make_data_discrAnalysis(Group1_Var1, Group1_Var2, Group2_Var1, Group2_Var2)


% Create a species vector to separate the datasets (#1 & #2)

species = ones((size(Stats_1.Area,1)+size(Stats_2.Area,1)), 1);
species(1:size(Stats_1.Area,1))=1;
species((size(Stats_1.Area,1)+1):end)=2;

% Combine each variable of both datasets in one matrix


Set_1 = [Stats_1.Area, Stats_1.Perimeter, Stats_1.Circularity, Stats_1.EquivDiameter, ...
    Stats_1.Solidity, Stats_1.MajorAxisLength, Stats_1.MinorAxisLength, Stats_1.MinorMajorRatio, ...
    Stats_1.Eccentricity]; 


Set_2 = [Stats_2.Area, Stats_2.Perimeter, Stats_2.Circularity, Stats_2.EquivDiameter, ...
    Stats_2.Solidity, Stats_2.MajorAxisLength, Stats_2.MinorAxisLength, Stats_2.MinorMajorRatio, ...
    Stats_2.Eccentricity]; 



% Set_1 = [Stats_1.Area, Stats_1.Circularity, Stats_1.EquivDiameter]; 
% 
% Set_2 = [Stats_2.Area,Stats_2.Circularity, Stats_2.EquivDiameter]; 


% for istat=as_stats_fields
% X=cat(2,X,cat(1,axonlist.(istat{1})))
% end



% Filter data (eliminate Inf & NaN values for both variables)

[indexes_1x, indexes_1y] = find(isnan(Set_1) | isinf(Set_1));
[indexes_2x, indexes_2y] = find(isnan(Set_2) | isinf(Set_2));

Set_1 = Set_1(~any(isnan(Set_1) | isinf(Set_1), 2),:);
Set_2 = Set_2(~any(isnan(Set_2) | isinf(Set_2), 2),:);



% Set_2(indexes_1x,:) = [];
% Set_1(indexes_2x,:) = [];

indexes = [indexes_1x; indexes_2x];

% Final 'species' vector indicating from which dataset each data comes

species(indexes,:) = [];

% Vector containing the variables to be analysed

X = [Set_1; Set_2];
