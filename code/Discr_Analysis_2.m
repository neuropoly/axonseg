
function [K,L,Q] = Discr_Analysis_2(Group1_Var1, Group1_Var2, Group2_Var1, Group2_Var2)

[X,species] = make_data_discrAnalysis(Group1_Var1, Group1_Var2, Group2_Var1, Group2_Var2);

cls = fitcdiscr(X,species,'DiscrimType','quadratic');

K = cls.Coeffs(1,2).Const; 
L = cls.Coeffs(1,2).Linear;
Q = cls.Coeffs(1,2).Quadratic; 




h1 = gscatter(Var_1,Var_2,species,'krb','ov^',[],'off');
 h1.LineWidth = 2;

% legend('EquivDiameter','Circularity','Location','best')
hold on


% Plot the curve K + [x,y]*L  = 0.
f = @(x1,x2) K + L(1)*x1 + L(2)*x2 + Q(1,1)*x1.^2 + ...
    (Q(1,2)+Q(2,1))*x1.*x2 + Q(2,2)*x2.^2;
% h2 = ezplot(f);
h2 = ezplot(f,[0 4 0 200]);
h2.Color = 'r';
h2.LineWidth = 2;





