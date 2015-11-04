function [Sensitivity,Specificity] = ROC_calculate(Class_table)

% Calculate Sensitivity & Specificity

FN = Class_table(2,1);
FP = Class_table(1,2);
TP = Class_table(2,2);
TN = Class_table(1,1);

Sensitivity = TP/(TP+FN);
Specificity = TN/(TN+FP);

