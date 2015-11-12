function [max_metrics,best_indexes]=as_find_max_ROC_metrics(ROC_values)

max_prec=max(ROC_values(:,3));
index1=find(ROC_values(:,3)==max_prec);

max_acc=max(ROC_values(:,4));
index2=find(ROC_values(:,4)==max_acc);

max_bal_acc=max(ROC_values(:,5));
index3=find(ROC_values(:,5)==max_bal_acc);

max_metrics=[max_prec;max_acc;max_bal_acc];
best_indexes=[index1;index2;index3];

end


