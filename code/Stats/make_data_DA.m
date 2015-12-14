function [X,species] = make_data_DA(Stats_1, Stats_2)
% Pre-processing before using Discrimination Analysis
% [X,species] = make_data_discrAnalysis(Stats_)

names = fieldnames(Stats_1);
first_field1 = getfield(Stats_1 ,names{1}); 
first_field2 = getfield(Stats_2 ,names{1});

% Create a species vector to separate the datasets (0 for dataset1 & 1 for dataset2)

species = ones((size(first_field1,1)+size(first_field2,1)), 1);
species(1:size(first_field1,1))=0;
species((size(first_field1,1)+1):end)=1;

% Combine each variable of both datasets in one matrix

Set_1 = table2array(struct2table(Stats_1)); 
Set_2 = table2array(struct2table(Stats_2)); 

% Vector containing the variables to be analysed

X = [Set_1; Set_2];

