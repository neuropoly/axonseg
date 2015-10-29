function [Rejected_axons_img, Accepted_axons_img,Class_table_final] = as_axonseg_validate(axonSeg_step1,axonSeg_segCorrected, parameters,type)
% Example : [Rejected_axons_img, Accepted_axons_img] = as_axonseg_validate(axonSeg_step1,axonSeg_segCorrected,{'Circularity','EquivDiameter'},'linear');

%--------------------------------------------------------------------------

% img_path_1 = uigetimagefile;
% axonSeg_step1 = imread(img_path_1);
% 
% img_path_2 = uigetimagefile;
% axonSeg_segCorrected = imread(img_path_2);

%--------------------------------------------------------------------------

% Validate both images are binary

AxonSeg_1_img = im2bw(axonSeg_step1);
AxonSeg_2_img = im2bw(axonSeg_segCorrected);

% Find removed objects (axons) from initial seg. to corrected seg.

False_axons_img = (AxonSeg_1_img-AxonSeg_2_img);
False_axons_img = imfill(False_axons_img,'holes');

% False_axons_img = find_removed_axons(AxonSeg_1_img, AxonSeg_2_img);

True_axons_img = AxonSeg_2_img;
True_axons_img = imfill(True_axons_img,'holes');


AxonSeg_1_img = imfill(AxonSeg_1_img,'holes');

% Compute stats (parameters of interest) for both groups

[Stats_1, names1] = as_stats_axons(False_axons_img);
[Stats_2, names2] = as_stats_axons(True_axons_img);
[Stats_3, names3] = as_stats_axons(AxonSeg_1_img);

% Only keep parameters wanted for discrimination analysis

Stats_1_used = rmfield(Stats_1,setdiff(names1, parameters));
Stats_2_used = rmfield(Stats_2,setdiff(names2, parameters));
Stats_3_used = rmfield(Stats_3,setdiff(names3, parameters));


% Perform Discrimination Analysis once with default cost matrix

[classifier_init,species] = Discr_Analysis(Stats_1_used, Stats_2_used, [0, 1; 1, 0],type);


% Find cost needed to have more than 99% of true axons accepted

cost = find_cost(classifier_init,30);
[classifier_final,species] = Discr_Analysis(Stats_1_used, Stats_2_used, [0, 1; cost, 0],type);

Stats_3_used = table2array(struct2table(Stats_3_used));
[label,~,~] = predict(classifier_final,Stats_3_used);

% Recalculate Discrimination Analysis using the newly found cost value


Class_table_init = confusionmat(classifier_init.Y,resubPredict(classifier_init));
Class_table_final = confusionmat(classifier_final.Y,resubPredict(classifier_final));


% probleme dans bwlabel du AxonSeg_1_img

index1=find(label==1);
Rejected_axons_img = ismember(bwlabel(AxonSeg_1_img),index1);

index2=find(label==2);
Accepted_axons_img = ismember(bwlabel(AxonSeg_1_img),index2);



% num_tot = bwconncomp(AxonSeg_1_img);
% num_rejected = bwconncomp(Rejected_axons_img);
% num_accepted = bwconncomp(Accepted_axons_img);

% 
% index1=find(label2==1);
% Rejected_axons_img = ismember(bwlabel(False_axons_img),index1);
% 
% index2=find(label2==2);
% Accepted_axons_img = ismember(bwlabel(True_axons_img),index2);

% sc(ismember(bwlabel(True_axons_img),index1))

figure(1);
subplot(221);
imshow(Rejected_axons_img);
title('Rejected axons');
subplot(222);
imshow(Accepted_axons_img);
title('Accepted axons');
subplot(223);
imshow(False_axons_img);
title('False axons');
subplot(224);
imshow(True_axons_img);
title('True axons');





figure(2);


K = classifier_final.Coeffs(2,1).Const; 
L = classifier_final.Coeffs(2,1).Linear;

if strcmp(type,'quadratic')
Q = classifier_final.Coeffs(2,1).Quadratic;
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
value2 = getfield(Stats_1_used, parameters{2});

value3 = getfield(Stats_2_used, parameters{1});
value4 = getfield(Stats_2_used, parameters{2});


h2 = plot(value1,value2,'r+');
hold on;
h3 = plot(value3,value4,'*');
legend('false axons','true axons');
hold on;

% 
% h3 = gscatter(value1, value2,ones(size(value1,1),1));
% 
% % h1(1).LineWidth = 2;
% % h1(2).LineWidth = 2;
% % legend('EquivDiameter','Circularity','Location','best')
% hold on
% hold on;
% 
% for i=1:size(var_names,1)
%     ezplot(f, ax(1,1));
%     xlabel(ax(9,i),var_names{i});
%     ylabel(ax(i,1),var_names{i});
% end

% % Plot the curve K + [x,y]*L  = 0.

if strcmp(type,'linear')

f1 = @(x1,x2) K + L(1)*x1 + L(2)*x2;
h4 = ezplot(f1,[0 1000 0 1000]);
h4.Color = 'blue';
h4.LineWidth = 2;
hold off;


elseif strcmp(type,'quadratic')

% Plot the curve K + [x,y]*L  = 0.
f2 = @(x1,x2) K + L(1)*x1 + L(2)*x2 + Q(1,1)*x1.^2 +(Q(1,2)+Q(2,1))*x1.*x2 + Q(2,2)*x2.^2;
ezplot(f2,[0 10 0 1000]);
% h5 = ezplot(f2,[0 1000 0 1000]);
% h5.Color = 'blue';
% h5.LineWidth = 2;
hold off;
    
    
    
end










% Plot variables in matrix

% visualize_DiscrAnalysis(classifier_final,names3);




% sc(ismember(bwlabel(True_axons_img),index1))
% index1=find(label1==2);
% sc(ismember(bwlabel(True_axons_img),index1))
% index1=find(label1==1);
% sc(ismember(bwlabel(True_axons_img),index1))
% index1=find(label1==2);
% sc(ismember(bwlabel(True_axons_img),index1))
