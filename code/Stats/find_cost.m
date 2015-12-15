function [Cost,ROC_values] = find_cost(classifier, Sensitivity)
% cost = find_cost(classifier,95);

for i=1:300

    classifier.Cost(2,1)=i;
    
    % For each value tested as cost, get the confusion matrix & calculate
    % the ROC stats
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
    
    else
    
    Sensitivity_values=[Sensitivity_values;Stats_ROC(1)];
    Specificity_values=[Specificity_values;Stats_ROC(2)];
    Precision_values=[Precision_values;Stats_ROC(3)];
    Accuracy_values=[Accuracy_values;Stats_ROC(4)];
    Balanced_accuracy_values=[Balanced_accuracy_values;Stats_ROC(5)];
    Youden_index_values=[Youden_index_values;Stats_ROC(6)];
    Distance_values=[Distance_values;Stats_ROC(7)];
    
    end
    
    % Find the cost needed to get the specified sensitivity
    FN_test = R(2,1);
    
    if FN_test <= round((R(2,2)/Sensitivity)-R(2,2))
        Cost=i;
        break;
    end
    
end


% If it doesnt converge (we cant find a cost smaller than 300 for the
% desired sensitivity), then take 300.
if i==300
    Cost=300;
end

% We have our ROC values for each i tested (to use for ROC curve plotting)
ROC_values=[Sensitivity_values,Specificity_values,Precision_values,Accuracy_values,Balanced_accuracy_values,Youden_index_values,Distance_values];
