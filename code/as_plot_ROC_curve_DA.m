function h_legend = as_plot_ROC_curve_DA(ROC_values)
% Function that plots the ROC curve (Sensitivity vs 1-Specificity)

% Add point at (0,0) for ROC curve
Sensitivity_values=0;
Specificity_values=1;

% Get Sensitivity & specificity values to plot
Sensitivity_values=[Sensitivity_values; ROC_values(:,1)];
Specificity_values=[Specificity_values; ROC_values(:,2)];

% Add point at (1,1) for ROC curve
Sensitivity_values=[Sensitivity_values;1];
Specificity_values=[Specificity_values;0];

[~,best_indexes]=as_find_max_ROC_metrics(ROC_values);

% Plot ROC curve & add labels for points
plot(1-Specificity_values,Sensitivity_values,'r--o');
hold on;

% Plot reference curve (y=x) for visual comparison
x=linspace(0,1,50);
plot(x,x,'-.');
hold on;

% Show max precision
plot(1-Specificity_values(best_indexes(1)+1,:),Sensitivity_values(best_indexes(1)+1,:),'kd','MarkerSize',13);
hold on;

% Show max accuracy
plot(1-Specificity_values(best_indexes(2)+1,:),Sensitivity_values(best_indexes(2)+1,:),'g*','MarkerSize',12);
hold on;

% Show max balanced accuracy
plot(1-Specificity_values(best_indexes(3)+1,:),Sensitivity_values(best_indexes(3)+1,:),'bo','MarkerSize',11);
hold on;

% Show max Youden index
plot(1-Specificity_values(best_indexes(4)+1,:),Sensitivity_values(best_indexes(4)+1,:),'k^','MarkerSize',11);
hold on;

% Show min euclidian distance
plot(1-Specificity_values(best_indexes(5)+1,:),Sensitivity_values(best_indexes(5)+1,:),'bs','MarkerSize',11);
hold off;

xlabel('1-Specificity');
ylabel('Sensitivity');
title('ROC curve of axon discrimination analysis');
h_legend=legend('ROC curve','Reference y=x curve','Max Precision','Max Accuracy','Max Balanced Accuracy','Max Youden Index','Min Euclidian Distance','Location','Best');
axis([0 1 0 1]);
grid on;









% 
% Sensitivity = zeros(91,1);
% Specificity = zeros(91,1);
% 
% for i=10:100
% 
% [~,~,~,~,Sensitivity(i,1), Specificity(i,1), ~] = as_axonseg_validate(axonSeg_step1,axonSeg_segCorrected,...
%     {'EquivDiameter', 'Circularity'},'linear',i);
% end
% 
% figure(10);
% plot(1-Specificity,Sensitivity);
% 
% end




% 
% figure(10);
% plot(Sensitivity2,1-Specificity2);
% 
% 
% 
% Sensitivity5 = zeros(20,1);
% Specificity5 = zeros(20,1);
% 
% 
% for i=1:20
% 
% [Rejected_axons_img, Accepted_axons_img, Classification,Sensitivity5(i,1),Specificity5(i,1)] = as_axonseg_validate(axonSeg_step1,axonSeg_segCorrected,...
%     {'EquivDiameter', 'Circularity'},'quadratic',i);
% end
% 
% figure(10);
% plot(1-Specificity5,Sensitivity5);
% 
% 
% 






