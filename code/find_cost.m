function Cost = find_cost(classifier, Sensitivity)
% cost = find_cost(classifier,95);

for i=1:300

    classifier.Cost(2,1)=i;
    R = confusionmat(classifier.Y,resubPredict(classifier));
    
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
    Cost=1;
end