function [classifier,species] = Discr_Analysis(Stats_1, Stats_2, Cost_matrix, type)
% Computes a classifier (discriminant analysis) given 2 datasets with
% variables, a discriminant analysis type & a defined cost matrix.
%
% Example of a cost matrix : [0, 1; 10, 0];
% If you want the default cost matrix, use : [0, 1; 1, 0];

% Convert data to compatible format for use with fitcdiscr

[X,species] = make_data_DA(Stats_1, Stats_2);

% Perform the discriminant analysis & create the classifier

classifier = fitcdiscr(X,species,'DiscrimType',type,'Cost',Cost_matrix);