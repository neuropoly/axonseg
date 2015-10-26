%%


% Read first image (data set #1)

img_path_1 = uigetimagefile;
AxonSeg_1_img = imread(img_path_1);

% Read second image (data set #2)

img_path_2 = uigetimagefile;
AxonSeg_2_img = imread(img_path_2);


AxonSeg_1_img = im2bw(AxonSeg_1_img);
AxonSeg_2_img = im2bw(AxonSeg_2_img);

% Calculate stats of both sets

% Centr_im1=regionprops(AxonSeg_1_img,'Centroid');
% Centr_im2=regionprops(AxonSeg_2_img,'Centroid');
% 
% 
% rm=find([Centr_im1.Centroid]~=[Centr_im2.Centroid]);
% 
% [axonLabel, numAxon] = bwlabel(im_in);
% im_out(ismember(axonLabel,rm))=false;

AxonSeg_1 = im2bw(AxonSeg_1_img);
AxonSeg_2 = im2bw(AxonSeg_2_img);
deleted_axons = AxonSeg_1&(~AxonSeg_2);
deleted_axons = im2bw(deleted_axons);
imshow(deleted_axons);

Stats_1 = as_stats_axons(AxonSeg_1_img);
Stats_2 = as_stats_axons(AxonSeg_2_img);
Stats_3 = as_stats_axons(deleted_axons);

% figure(2);
% scatter(Stats_1(:,4),Stats_1(:,5),'red'); %plot first set of data
% hold on;
% scatter(Stats_2(:,4),Stats_2(:,5),'blue'); %plot first set of data
% hold on;
% scatter(Stats_3(:,4),Stats_3(:,5),'yellow'); %plot first set of data
% hold off;
% 
% xlabel('EquivDiameter');
% ylabel('Circularity');



%%

h1 = hist(Stats_1(:,4),100);
h2 = hist(Stats_2(:,4),100);
plot(h1);
hold on;
plot(h2);

%% Removed axons


removed_axons = find_removed_axons(AxonSeg_1_img, AxonSeg_2_img);






%% Projections

Vect=zeros(45,2);

for A=1:45
X=cos(A);
Y=sin(A);

Vect(A,:) = [X, Y];
end

Data_to_project = [Stats_2(:,4), Stats_2(:,5)];

Projected=zeros(size(Stats_2,1),2);

for i=1:size(Stats_2,1)
Projected(i,:) = dot(Data_to_project(i,:),Vect(10,:))/norm(Vect(10,:))^2*Vect(10,:);
end


%% Plot 

figure(1);

subplot(441);

scatter(Stats_1.Area,Stats_1.Perimeter,'red'); %plot first set of data
hold on;
scatter(Stats_2.Area,Stats_2.Perimeter,'blue'); %plot first set of data
hold off;
                
xlabel('Area');
ylabel('Perimeter');


subplot(442);

scatter(Stats_1.Area,Stats_1.Circularity,'red'); %plot first set of data
hold on;
scatter(Stats_2.Area,Stats_2.Circularity,'blue'); %plot first set of data
hold off;

xlabel('Area');
ylabel('Circularity');

subplot(443);

scatter(Stats_1.Area,Stats_1.EquivDiameter,'red'); %plot first set of data
hold on;
scatter(Stats_2.Area,Stats_2.EquivDiameter,'blue'); %plot first set of data
hold off;

xlabel('Area');
ylabel('EquivDiameter');

subplot(444);

scatter(Stats_1.Area,Stats_1.Solidity,'red'); %plot first set of data
hold on;
scatter(Stats_2.Area,Stats_2.Solidity,'blue'); %plot first set of data
hold off;

xlabel('Area');
ylabel('Solidity');

subplot(445);

scatter(Stats_1.Area,Stats_1.MinorMajorRatio,'red'); %plot first set of data
hold on;
scatter(Stats_2.Area,Stats_2.MinorMajorRatio,'blue'); %plot first set of data
hold off;

xlabel('Area');
ylabel('RatioMinorMajor');


subplot(446);

scatter(Stats_1.Perimeter,Stats_1.Circularity,'red'); %plot first set of data
hold on;
scatter(Stats_2.Perimeter,Stats_2.Circularity,'blue'); %plot first set of data
hold off;

xlabel('Perimeter');
ylabel('Circularity');

subplot(447);

scatter(Stats_1.Perimeter,Stats_1.EquivDiameter,'red'); %plot first set of data
hold on;
scatter(Stats_2.Perimeter,Stats_2.EquivDiameter,'blue'); %plot first set of data
hold off;

xlabel('Perimeter');
ylabel('EquivDiameter');


subplot(448);

scatter(Stats_1.Perimeter,Stats_1.Solidity,'red'); %plot first set of data
hold on;
scatter(Stats_2.Perimeter,Stats_2.Solidity,'blue'); %plot first set of data
hold off;

xlabel('Perimeter');
ylabel('Solidity');


subplot(449);

scatter(Stats_1.Perimeter,Stats_1.MinorMajorRatio,'red'); %plot first set of data
hold on;
scatter(Stats_2.Perimeter,Stats_2.MinorMajorRatio,'blue'); %plot first set of data
hold off;

xlabel('Perimeter');
ylabel('RatioMinorMajor');

subplot(4,4,10);

scatter(Stats_1.Circularity,Stats_1.EquivDiameter,'red'); %plot first set of data
hold on;
scatter(Stats_2.Circularity,Stats_2.EquivDiameter,'blue'); %plot first set of data
hold off;

xlabel('Circularity');
ylabel('EquivDiameter');

subplot(4,4,11);

scatter(Stats_1.Circularity,Stats_1.Solidity,'red'); %plot first set of data
hold on;
scatter(Stats_2.Circularity,Stats_2.Solidity,'blue'); %plot first set of data
hold off;

xlabel('Circularity');
ylabel('Solidity');

subplot(4,4,12);

scatter(Stats_1.Circularity,Stats_1.MinorMajorRatio,'red'); %plot first set of data
hold on;
scatter(Stats_2.Circularity,Stats_2.MinorMajorRatio,'blue'); %plot first set of data
hold off;

xlabel('Circularity');
ylabel('RatioMinorMajor');

subplot(4,4,13);

scatter(Stats_1.EquivDiameter,Stats_1.Solidity,'red'); %plot first set of data
hold on;
scatter(Stats_2.EquivDiameter,Stats_2.Solidity,'blue'); %plot first set of data
hold off;

xlabel('EquivDiameter');
ylabel('Solidity');

subplot(4,4,14);

scatter(Stats_1.EquivDiameter,Stats_1.MinorMajorRatio,'red'); %plot first set of data
hold on;
scatter(Stats_2.EquivDiameter,Stats_2.MinorMajorRatio,'blue'); %plot first set of data
hold off;

xlabel('EquivDiameter');
ylabel('RatioMinorMajor');

subplot(4,4,15);

scatter(Stats_1.Solidity,Stats_1.MinorMajorRatio,'red'); %plot first set of data
hold on;
scatter(Stats_2.Solidity,Stats_2.MinorMajorRatio,'blue'); %plot first set of data
hold off;

xlabel('Solidity');
ylabel('RatioMinorMajor');


subplot(4,4,16);

scatter(Stats_1.Eccentricity,Stats_1.MinorMajorRatio,'red'); %plot first set of data
hold on;
scatter(Stats_2.Eccentricity,Stats_2.MinorMajorRatio,'blue'); %plot first set of data
hold off;

xlabel('Eccentricity');
ylabel('RatioMinorMajor');






%% Discrimination Analysis


species = ones((size(Stats_1,1)+size(Stats_2,1)), 1);
species(1:size(Stats_1,1))=1;
species((size(Stats_1,1)+1):end)=2;

% Var_1 = zeros( (size(Stats_1,1)+size(Stats_2,1)), 2);
% Var_2 = zeros( (size(Stats_1,1)+size(Stats_2,1)), 2);

Var_1 = [Stats_1(:,3),; Stats_2(:,3)];
% Var_1(:,2) = species;

Var_2 = [Stats_1(:,4); Stats_2(:,4)];
% Var_2(:,2) = species;


h1 = gscatter(Var_1,Var_2,species,'krb','ov^',[],'off');
% h1(1).LineWidth = 2;
% h1(2).LineWidth = 2;
% legend('EquivDiameter','Circularity','Location','best')
hold on



X = [Var_1,Var_2];
X(63,:) = X(62,:);
cls = fitcdiscr(X,species);


K = cls.Coeffs(1,2).Const; % First retrieve the coefficients for the linear
L = cls.Coeffs(1,2).Linear;% boundary between the second and third classes
                           % (versicolor and virginica).

% Plot the curve K + [x,y]*L  = 0.
f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
h2 = ezplot(f,[.9 7.1 0 2.5]);
h2.Color = 'r';
h2.LineWidth = 2;


%%


figure(5);

subplot(4,4,1)
[Const, Lin] = Discr_Analysis(Stats_1(:,1),Stats_1(:,2),Stats_2(:,1),Stats_2(:,2));
subplot(4,4,2)
[Const, Lin] = Discr_Analysis(Stats_1(:,1),Stats_1(:,3),Stats_2(:,1),Stats_2(:,3));
subplot(4,4,3)
[Const, Lin] = Discr_Analysis(Stats_1(:,1),Stats_1(:,4),Stats_2(:,1),Stats_2(:,4));
subplot(4,4,4)
[Const, Lin] = Discr_Analysis(Stats_1(:,1),Stats_1(:,5),Stats_2(:,1),Stats_2(:,5));
subplot(4,4,5)
[Const, Lin] = Discr_Analysis(Stats_1(:,1),Stats_1(:,8),Stats_2(:,1),Stats_2(:,8));

subplot(4,4,6)
[Const, Lin] = Discr_Analysis(Stats_1(:,2),Stats_1(:,3),Stats_2(:,2),Stats_2(:,3));
subplot(4,4,7)
[Const, Lin] = Discr_Analysis(Stats_1(:,2),Stats_1(:,4),Stats_2(:,2),Stats_2(:,4));
subplot(4,4,8)
[Const, Lin] = Discr_Analysis(Stats_1(:,2),Stats_1(:,5),Stats_2(:,2),Stats_2(:,5));
subplot(4,4,9)
[Const, Lin] = Discr_Analysis(Stats_1(:,2),Stats_1(:,8),Stats_2(:,2),Stats_2(:,8));
subplot(4,4,10)
[Const, Lin] = Discr_Analysis(Stats_1(:,3),Stats_1(:,4),Stats_2(:,3),Stats_2(:,4));
subplot(4,4,11)
[Const, Lin] = Discr_Analysis(Stats_1(:,3),Stats_1(:,5),Stats_2(:,3),Stats_2(:,5));
subplot(4,4,12)
[Const, Lin] = Discr_Analysis(Stats_1(:,3),Stats_1(:,8),Stats_2(:,3),Stats_2(:,8));
subplot(4,4,13)
[Const, Lin] = Discr_Analysis(Stats_1(:,4),Stats_1(:,5),Stats_2(:,4),Stats_2(:,5));
subplot(4,4,14)
[Const, Lin] = Discr_Analysis(Stats_1(:,4),Stats_1(:,8),Stats_2(:,4),Stats_2(:,8));
subplot(4,4,15)
[Const, Lin] = Discr_Analysis(Stats_1(:,5),Stats_1(:,8),Stats_2(:,5),Stats_2(:,8));

%%


[Const, Lin, Quad, nbr] = Discr_Analysis_2(Stats_1(:,2),Stats_1(:,3),Stats_2(:,2),Stats_2(:,3));

[Const, Lin, Quad, nbr] = Discr_Analysis_2(Stats_1(:,2),Stats_1(:,4),Stats_2(:,2),Stats_2(:,4));

[Const, Lin, Quad, nbr] = Discr_Analysis_2(Stats_1(:,2),Stats_1(:,5),Stats_2(:,2),Stats_2(:,5));

[Const, Lin, Quad, nbr] = Discr_Analysis_2(Stats_1(:,2),Stats_1(:,8),Stats_2(:,2),Stats_2(:,8));

[Const, Lin, Quad, nbr] = Discr_Analysis_2(Stats_1(:,3),Stats_1(:,4),Stats_2(:,3),Stats_2(:,4));






%% Changement de paramètres de discrimination analysis





























