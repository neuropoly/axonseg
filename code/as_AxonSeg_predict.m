function AxonSeg_DA = as_AxonSeg_predict(AxSeg,classifier_final, parameters,AxonSeg_gray)
% Ex : AxonSeg_DA = as_AxonSeg_predict(AxSeg,classifier_final, parameters);


% Calculate stats of the image

[Stats_3, names3] = as_stats_axons(AxSeg,AxonSeg_gray);
Stats_3_used = rmfield(Stats_3,setdiff(names3, parameters));

% Predict true & false axons by using the classifier (INPUT)

Stats_3_used = table2array(struct2table(Stats_3_used));
[label,score,~] = predict(classifier_final,Stats_3_used);

% Identify true & false axons 

index1=find(label==1);
Rejected_axons_img = ismember(bwlabel(AxSeg),index1);

index2=find(label==2);
Accepted_axons_img = ismember(bwlabel(AxSeg),index2);

AxonSeg_DA = Accepted_axons_img;

















