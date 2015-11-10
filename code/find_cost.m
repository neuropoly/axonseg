function [Cost,ROC_values] = find_cost(classifier, Sensitivity)
% cost = find_cost(classifier,95);



for i=10:300

    classifier.Cost(2,1)=i;
    R = confusionmat(classifier.Y,resubPredict(classifier));
    
    [Stats_ROC]=ROC_calculate(R);
    
    if i==10
    
    Sensitivity_values=Stats_ROC(1);
    Specificity_values=Stats_ROC(2);
    
    else
        
    Sensitivity_values=[Sensitivity_values;Stats_ROC(1)];
    Specificity_values=[Specificity_values;Stats_ROC(2)];
        
    end
   
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
    Cost=10;
end



ROC_values=[Sensitivity_values,Specificity_values];