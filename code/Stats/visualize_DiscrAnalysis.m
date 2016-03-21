function visualize_DiscrAnalysis(classifier,var_names)

X=classifier.X;
Y=classifier.Y;

K = classifier.Coeffs(1,2).Const; 
L = classifier.Coeffs(1,2).Linear;

% Const + Linear * x + x' * Quadratic * x = 0,
% 


% % Plot the curve K + [x,y]*L  = 0.
% f = @(x1,x2,x3,x4,x5,x6,x7,x8,x9) K + L(1)*x1 + L(2)*x2+ L(3)*x3+ L(4)*x4+ L(5)*x5+ L(6)*x6+ L(7)*x7+ L(8)*x8+ L(9)*x9;




figure(1);
[h,ax,bigax] = gplotmatrix(X,X,Y);

for i=1:size(var_names,1)    
    xlabel(ax(9,i),var_names{i});
    ylabel(ax(i,1),var_names{i});
end




% hold on;
% 
% for i=1:size(var_names,1)
%     ezplot(f, ax(1,1));
%     xlabel(ax(9,i),var_names{i});
%     ylabel(ax(i,1),var_names{i});
% end

% % Plot the curve K + [x,y]*L  = 0.
figure(2);
f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
h2 = ezplot(f,[0 200 0 150]);
h2.Color = 'blue';
h2.LineWidth = 2;
% hold off;

