function h_legend = as_plot_ROC_curve_DA(ROC_values,classifier_number)
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

% % Show max precision
% plot(1-Specificity_values(best_indexes(1)+1,:),Sensitivity_values(best_indexes(1)+1,:),'kd','MarkerSize',13);
% hold on;

% % Show max accuracy
% plot(1-Specificity_values(best_indexes(2)+1,:),Sensitivity_values(best_indexes(2)+1,:),'k^','MarkerSize',12);
% hold on;

% % Show max balanced accuracy
% plot(1-Specificity_values(best_indexes(3)+1,:),Sensitivity_values(best_indexes(3)+1,:),'bo','MarkerSize',11);
% hold on;

% % Show max Youden index
% plot(1-Specificity_values(best_indexes(4)+1,:),Sensitivity_values(best_indexes(4)+1,:),'k^','MarkerSize',11);
% hold on;

% Show min euclidian distance
plot(1-Specificity_values(best_indexes(5)+1,:),Sensitivity_values(best_indexes(5)+1,:),'bs','MarkerSize',12);
hold on;

if nargin==2
    
 % Show current classifier used
plot(1-Specificity_values(classifier_number+1,:),Sensitivity_values(classifier_number+1,:),'g*','MarkerSize',14);
hold off;   
       
end


xlabel('1-Specificity','FontSize',13);
ylabel('Sensitivity','FontSize',13);
title('ROC Curve --- Axon Discrimination Analysis','FontSize',14);
h_legend=legend('ROC curve','Reference y=x curve','Min Euclidian Distance','Location','Best');
axis([0 1 0 1]);
grid on;


if nargin==2
    
    
   h_legend=legend('ROC curve','Reference y=x curve','Min Euclidian Distance','ROC Value Selected','Location','Best'); 
    
end














