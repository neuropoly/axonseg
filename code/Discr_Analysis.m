
function [label,score, classifier] = Discr_Analysis(Stats_1, Stats_2, Cost_matrix)
% Example of a good cost matrix for our case : [0, 1; 10, 1];


% Convert data to desired format

[X,species] = make_data_discrAnalysis2(Stats_1, Stats_2);

% Create the classifier

classifier = fitcdiscr(X,species,'DiscrimType','linear');



% use the classifier to predict data group

[label,score,cost] = predict(classifier,X);

classifier.Cost = Cost_matrix;


% Confusion_matrix1 = confusionmat(classifier.Y,resubPredict(classifier));



% Confusion_matrix2 = confusionmat(classifier.Y,resubPredict(classifier));

K = classifier.Coeffs(1,2).Const; 
L = classifier.Coeffs(1,2).Linear;


% h1 = gscatter(X(:,1),X(:,2),species,'krb','ov^',[],'off');
% hold on
% 
% % Plot the curve K + [x,y]*L  = 0.
% f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
% h2 = ezplot(f,[0 200 0 150]);
% h2.Color = 'blue';
% h2.LineWidth = 2;
% hold off;
