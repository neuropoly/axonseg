function [Cost,ROC_values] = find_cost(classifier, Sensitivity)
% cost = find_cost(classifier,95);

for i=1:300

    classifier.Cost(2,1)=i;
    R = confusionmat(classifier.Y,resubPredict(classifier));
    
    [Stats_ROC]=ROC_calculate(R);
    
    
    if i==1
        
        Sensitivity_values=Stats_ROC(1);
        Specificity_values=Stats_ROC(2);
        Precision_values=Stats_ROC(3);
        Accuracy_values=Stats_ROC(4);
        Balanced_accuracy_values=Stats_ROC(5);
        Youden_index_values=Stats_ROC(6);
        Distance_values=Stats_ROC(7);
        
    end
    
    Sensitivity_values=[Sensitivity_values;Stats_ROC(1)];
    Specificity_values=[Specificity_values;Stats_ROC(2)];
    Precision_values=[Precision_values;Stats_ROC(3)];
    Accuracy_values=[Accuracy_values;Stats_ROC(4)];
    Balanced_accuracy_values=[Balanced_accuracy_values;Stats_ROC(5)];
    Youden_index_values=[Youden_index_values;Stats_ROC(6)];
    Distance_values=[Distance_values;Stats_ROC(7)];
        
    FN_test = R(2,1);
    
    if FN_test <= round((R(2,2)/Sensitivity)-R(2,2))
    
        Cost=i;
        break;
    end
    
%     Ratio = R(2,1)/(R(2,1)+R(2,2));
    
%     if Ratio<=((100-Percent_false_pos)/100)
%         Cost=i;
%         break;
%     end

end

if i==300
    Cost=300;
end

ROC_values=[Sensitivity_values,Specificity_values,Precision_values,Accuracy_values,Balanced_accuracy_values,Youden_index_values,Distance_values];