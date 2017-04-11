function [Accepted_axons_img,Rejected_axons_img,Class_table_final,Sensitivity,Specificity]=as_axonSeg_apply_DA_classifier(axonSeg_step1,axonSeg_gray,classifier_final,parameters)
%---PART 2 - APPLY IT TO THE WHOLE DATA -----------------------------------

% Validate both images are binary
if ~islogical(axonSeg_step1), axonSeg_step1 = im2bw(axonSeg_step1); end

% Get the stats from the whole data (initial binary image without any
% corrections)
[Stats_3, names3] = as_stats_axons(axonSeg_step1,axonSeg_gray);
Stats_3_used = rmfield(Stats_3,setdiff(names3, parameters));
Stats_3_used = table2array(struct2table(Stats_3_used));

% Classify the whole data with the classifier obtained in PART 2
[label,~,~] = predict(classifier_final,Stats_3_used);

% Get the final confusion matrix for output
Class_table_final = confusionmat(classifier_final.Y,resubPredict(classifier_final));

% Get the rejected axons as given by the classifier
index1=find(label==0);
Rejected_axons_img = ismember(bwlabel(axonSeg_step1),index1);

% Get the accepted axons as given by the classifier
index2=find(label==1);
Accepted_axons_img = ismember(bwlabel(axonSeg_step1),index2);

% Calculate ROC stats & get the sensitivity & specificity values
[ROC_stats] = ROC_calculate(Class_table_final);
Sensitivity=ROC_stats(1);
Specificity=ROC_stats(2);
