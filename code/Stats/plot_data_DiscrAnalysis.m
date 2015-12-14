function plot_data_DiscrAnalysis(classifier_final, Stats_1_used, Stats_2_used, parameters, type)



figure;




    K = classifier_final.Coeffs(1,2).Const; 
    L = classifier_final.Coeffs(1,2).Linear;

if strcmp(type,'quadratic')
    
    Q = classifier_final.Coeffs(1,2).Quadratic;

end


% Const + Linear * x + x' * Quadratic * x = 0,
% 
% h1 = plot(Stats_1_used(:,1),Stats_1_used(:,2),'r+');
% 
% h1 = plot(Stats_2_used(:,1),value4(:,2),'g+');
% % 
% % 
% hold on;

value1 = getfield(Stats_1_used, parameters{1});
value3 = getfield(Stats_2_used, parameters{1});

% if size(Stats_1_used,2)>=2
value2 = getfield(Stats_1_used, parameters{2});
value4 = getfield(Stats_2_used, parameters{2});
% end


max_x = max(max(value1),max(value3));
max_y = max(max(value2),max(value4));


% if size(Stats_1_used,2)>=2

    h2 = plot(value1,value2,'r+');
    hold on;
    h3 = plot(value3,value4,'*');
    legend('false axons','true axons','location','best');
    hold on;


% else
%     h2 = plot(value1,zeros(size(value1,1),1),'r+');
%     hold on;
%     h3 = plot(value3,zeros(size(value3,1),1),'*');
%     legend('false axons','true axons');
%     hold on;
%     
%     
% end  
    


% % Plot the curve K + [x,y]*L  = 0.

if strcmp(type,'linear')

f1 = @(x2,x1) K + L(1)*x1 + L(2)*x2;
h4 = ezplot(f1,[0 max_x 0 max_y]);
h4.Color = 'blue';
h4.LineWidth = 2;
hold off;


elseif strcmp(type,'quadratic')

% Plot the curve K + [x,y]*L  = 0.
f2 = @(x2,x1) K + L(1)*x1 + L(2)*x2 + Q(1,1)*x1.^2 +(Q(1,2)+Q(2,1))*x1.*x2 + Q(2,2)*x2.^2;
ezplot(f2,[0 max_x 0 max_y]);
% h5 = ezplot(f2,[0 1000 0 1000]);
% h5.Color = 'blue';
% h5.LineWidth = 2;
hold off;



end

