function [ROC_stats] = ROC_calculate(Class_table)
% Calculate common ROC values for a given confusion matrix (2x2 matrix
% containing true positives, true negatives, false positives & false
% negatives. This confusion matrix can be obtained from a discriminant
% analysis (see as_axonseg_validate()).

FN = Class_table(2,1);
FP = Class_table(1,2);
TP = Class_table(2,2);
TN = Class_table(1,1);

Sensitivity = TP/(TP+FN);
Specificity = TN/(TN+FP);

Precision = TP/(TP+FP);
Accuracy = (TP+TN)/(TP+FP+FN+TN);

Balanced_accuracy = 0.5*(Sensitivity+Specificity);

Youden_index = (Sensitivity+Specificity)-1;

P = [0,1];
Q = [1-Specificity,Sensitivity];
Distance = sqrt(sum((P - Q).^2));

ROC_stats=[Sensitivity,Specificity,Precision,Accuracy,Balanced_accuracy,Youden_index,Distance];







