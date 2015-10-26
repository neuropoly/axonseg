
function [K,L] = Discr_Analysis(Group1_Var1, Group1_Var2, Group2_Var1, Group2_Var2)

species = ones((size(Group1_Var1,1)+size(Group2_Var1,1)), 1);
species(1:size(Group1_Var1,1))=1;
species((size(Group1_Var1,1)+1):end)=2;

% Var_1 = zeros( (size(Stats_1,1)+size(Stats_2,1)), 2);
% Var_2 = zeros( (size(Stats_1,1)+size(Stats_2,1)), 2);

Var_1 = [Group1_Var1; Group2_Var1];
% Var_1(:,2) = species;

Var_2 = [Group1_Var2; Group2_Var2];
% Var_2(:,2) = species;


indexes_1 = find(isnan(Var_1) | isinf(Var_1));
indexes_2 = find(isnan(Var_2) | isinf(Var_2));

Var_1 = Var_1(~any(isnan(Var_1) | isinf(Var_1), 2),:);
Var_2 = Var_2(~any(isnan(Var_2) | isinf(Var_2), 2),:);

Var_2(indexes_1,:) = [];
Var_1(indexes_2,:) = [];

indexes = [indexes_1; indexes_2];

species(indexes,:) = [];



% species = [Var_1(:,2); Var_2(:,2)];

X = [Var_1,Var_2];

cls = fitcdiscr(X,species,'DiscrimType','linear');

K = cls.Coeffs(1,2).Const; 
L = cls.Coeffs(1,2).Linear;


h1 = gscatter(Var_1,Var_2,species,'krb','ov^',[],'off');
% h1(1).LineWidth = 2;
% h1(2).LineWidth = 2;
% legend('EquivDiameter','Circularity','Location','best')
hold on


% Plot the curve K + [x,y]*L  = 0.
f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
%h2 = ezplot(f);
h2 = ezplot(f,[0 4 0 150]);
h2.Color = 'blue';
h2.LineWidth = 2;
hold off;
