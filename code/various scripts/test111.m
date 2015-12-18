
% ---

Stats_ROC=zeros(51,51);

for i=1:50
    for j=1:50
                
[classifier,~] = Discr_Analysis(Stats_1_used, Stats_2_used, [0, i; j, 0],type);
R = confusionmat(classifier.Y,resubPredict(classifier));
Stats_ROC=ROC_calculate(R);
      

%         Sensitivity_values=Stats_ROC(1);
%         Specificity_values=Stats_ROC(2);
%         Precision_values=Stats_ROC(3);
%         Accuracy_values=Stats_ROC(4);
%         Balanced_accuracy_values=Stats_ROC(5);
%         Youden_index_values=Stats_ROC(6);
%         Distance_values=Stats_ROC(7);   

    end
end

%---