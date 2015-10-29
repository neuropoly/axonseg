function [X,species] = make_data_discrAnalysis4(Stats_1, Stats_2)
% Pre-processing before using Discrimination Analysis
% [X,species] = make_data_discrAnalysis(Group1_Var1, Group1_Var2, Group2_Var1, Group2_Var2)

names = fieldnames(Stats_1);
first_field1 = getfield(Stats_1 ,names{1}); 
first_field2 = getfield(Stats_2 ,names{1});

% Create a species vector to separate the datasets (#1 & #2)

species = ones((size(first_field1,1)+size(first_field2,1)), 1);
species(1:size(first_field1,1))=1;
species((size(first_field1,1)+1):end)=2;

% Combine each variable of both datasets in one matrix




Set_1 = table2array(struct2table(Stats_1)); 
Set_2 = table2array(struct2table(Stats_2)); 



% Set_1 = [Stats_1.Area, Stats_1.Circularity, Stats_1.EquivDiameter]; 
% 
% Set_2 = [Stats_2.Area,Stats_2.Circularity, Stats_2.EquivDiameter]; 


% for istat=as_stats_fields
% X=cat(2,X,cat(1,axonlist.(istat{1})))
% end



% Filter data (eliminate Inf & NaN values for both variables)

% [indexes_1x, indexes_1y] = find(isnan(Set_1) | isinf(Set_1));
% [indexes_2x, indexes_2y] = find(isnan(Set_2) | isinf(Set_2));
% 
% Set_1 = Set_1(~any(isnan(Set_1) | isinf(Set_1), 2),:);
% Set_2 = Set_2(~any(isnan(Set_2) | isinf(Set_2), 2),:);
% 
% 
% 
% % Set_2(indexes_1x,:) = [];
% % Set_1(indexes_2x,:) = [];
% 
% indexes = [indexes_1x; indexes_2x];
% 
% % Final 'species' vector indicating from which dataset each data comes
% 
% species(indexes,:) = [];

% Vector containing the variables to be analysed

X = [Set_1; Set_2];
