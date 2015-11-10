function as_plot_ROC_curve_DA(ROC_values)

plot(1-ROC_values(:,2),ROC_values(:,1));
xlabel('1-Specificity');
ylabel('Sensitivity');
axis([0 1 0 1]);







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






