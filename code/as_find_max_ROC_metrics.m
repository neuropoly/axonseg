function [max_metrics,best_indexes]=as_find_max_ROC_metrics(ROC_values)

max_prec=max(ROC_values(:,3));
index1=find(ROC_values(:,3)==max_prec);
index1=index1(1);

max_acc=max(ROC_values(:,4));
index2=find(ROC_values(:,4)==max_acc);
index2=index2(1);

max_bal_acc=max(ROC_values(:,5));
index3=find(ROC_values(:,5)==max_bal_acc);
index3=index3(1);

max_youden=max(ROC_values(:,6));
index4=find(ROC_values(:,6)==max_youden);
index4=index4(1);

min_distance=min(ROC_values(:,7));
index5=find(ROC_values(:,7)==min_distance);
index5=index5(1);

max_metrics=[max_prec;max_acc;max_bal_acc;max_youden;min_distance];
best_indexes=[index1;index2;index3;index4;index5];

end


