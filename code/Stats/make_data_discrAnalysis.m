function [X,species] = make_data_discrAnalysis(Group1_Var1, Group1_Var2, Group2_Var1, Group2_Var2)
% Pre-processing before using Discrimination Analysis
% [X,species] = make_data_discrAnalysis(Group1_Var1, Group1_Var2, Group2_Var1, Group2_Var2)


% Create a species vector to separate the datasets (#1 & #2)

species = ones((size(Group1_Var1,1)+size(Group2_Var1,1)), 1);
species(1:size(Group1_Var1,1))=1;
species((size(Group1_Var1,1)+1):end)=2;

% Combine each variable of both datasets in one matrix

Var_1 = [Group1_Var1; Group2_Var1]; 
Var_2 = [Group1_Var2; Group2_Var2];

% Filter data (eliminate Inf & NaN values for both variables)

indexes_1 = find(isnan(Var_1) | isinf(Var_1));
indexes_2 = find(isnan(Var_2) | isinf(Var_2));

Var_1 = Var_1(~any(isnan(Var_1) | isinf(Var_1), 2),:);
Var_2 = Var_2(~any(isnan(Var_2) | isinf(Var_2), 2),:);

Var_2(indexes_1,:) = [];
Var_1(indexes_2,:) = [];

indexes = [indexes_1; indexes_2];

% Final 'species' vector indicating from which dataset each data comes

species(indexes,:) = [];

% Vector containing the variables to be analysed

X = [Var_1,Var_2];

