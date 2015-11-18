%% with functions

[reg_type,myfit]=as_make_curve_fitting('log',datasets_xx.x1,datasets_yy.y1);
Estimated_MyelinThickness=as_estimate_myelin_thickness(reg_type,myfit,cat(1,axonlist.axonEquivDiameter));



%% script_gratio_diameter

xm=cat(1,axonlist.axonEquivDiameter);
ym=cat(1,axonlist.gRatio);


x1=cat(1,axonlist.axonEquivDiameter);
y1=cat(1,axonlist.gRatio);


x=[x;cat(1,axonlist.axonEquivDiameter)];
y=[y;cat(1,axonlist.gRatio)];

x=log(cat(1,axonlist.axonEquivDiameter));
y=log(cat(1,axonlist.gRatio));

% scatter(log(x),log(y));
scatter(xm,ym);

[pl,xs,ys]=selectdata;

% scatter(log(xs),log(ys));
scatter(xs,ys);

hold on;

X = [ones(length(xs),1) xs];
b = X\ys;
yCalc2 = X*b;
plot(xs,yCalc2,'--');

R = 1 - sum((ys - yCalc2).^2)/sum((ys - mean(ys)).^2);


%%

xs=xs.*(0.185/0.1);

myfittype = fittype('b + a*log(x)','dependent',{'y'},'independent',{'x'},'coefficients',{'b','a'});
myfit = fit(xs,ys,myfittype);

% R = 1 - sum((ys - myfit).^2)/sum((ys - mean(ys)).^2);
scatter(xs,ys);
hold on;

plot(myfit);
hold on;

xx=linspace(0,5,100);
yy=0.220*log(xx)+0.508;
plot(xx,yy);
xlabel('Axon Diameter (in um)');
ylabel('G-ratio');
title('Logarithmic regression of G-ratio VS axon diameter');
legend('Data scatter','Log fit y = a*log(x)+b','Fit obtained by Ikeda 2012 from control data (sciatic rat nerve)','Location','Best');
grid on;
hold off;


%%


% x1=x1.*(0.185/0.1);
% x2=x2.*(0.185/0.1);
% x3=x3.*(0.185/0.1);
% x4=x4.*(0.185/0.1);
% x5=x5.*(0.185/0.1);

myfittype = fittype('b + a*log(x)','dependent',{'y'},'independent',{'x'},'coefficients',{'b','a'});

% datasets_y.y1=double(datasets_y.y1);
% datasets_y.y2=double(datasets_y.y2);
% datasets_y.y3=double(datasets_y.y3);
% datasets_y.y4=double(datasets_y.y4);
% datasets_y.y5=double(datasets_y.y5);

figure(2);

subplot(221);
scatter(datasets_xx.x1,datasets_yy.y1);
title('Dataset 1 : DA linear');
xlabel('Axon Diameter (in um)');
ylabel('G-ratio');
grid on;
axis([0 10 0 0.8]);
subplot(222);
scatter(datasets_xx.x2,datasets_yy.y2);
title('Dataset 2 : DA quadratic');
xlabel('Axon Diameter (in um)');
ylabel('G-ratio');
grid on;
axis([0 10 0 0.8]);
subplot(223);
scatter(datasets_xx.x4,datasets_yy.y4);
title('Dataset 3 : DA + LevelSet');
xlabel('Axon Diameter (in um)');
ylabel('G-ratio');
grid on;
axis([0 10 0 0.8]);
subplot(224);
scatter(datasets_xx.x5,datasets_yy.y5);
title('Dataset 4 : LevelSet (no DA)');
xlabel('Axon Diameter (in um)');
ylabel('G-ratio');
grid on;
axis([0 10 0 0.8]);

scatter(datasets_x.x1,datasets_y.y1);
[p1,datasets_xx.x1,datasets_yy.y1]=selectdata;

scatter(datasets_x.x2,datasets_y.y2);
[p2,datasets_xx.x2,datasets_yy.y2]=selectdata;

scatter(datasets_x.x4,datasets_y.y4);
[p4,datasets_xx.x4,datasets_yy.y4]=selectdata;

scatter(datasets_x.x5,datasets_y.y5);
[p5,datasets_xx.x5,datasets_yy.y5]=selectdata;

myfit1 = fit(datasets_xx.x1,datasets_yy.y1,myfittype);
myfit2 = fit(datasets_xx.x2,datasets_yy.y2,myfittype);
myfit3 = fit(datasets_xx.x3,datasets_yy.y3,myfittype);
myfit4 = fit(datasets_xx.x4,datasets_yy.y4,myfittype);
myfit5 = fit(datasets_xx.x5,datasets_yy.y5,myfittype);

% R = 1 - sum((ys - myfit).^2)/sum((ys - mean(ys)).^2);
% scatter(xs,ys);
% hold on;

plot(myfit1,'r--');
hold on;

plot(myfit2,'b--');
hold on;

% plot(myfit3);
% hold on;

plot(myfit4,'g--');
hold on;

plot(myfit5,'m--');
hold on;

% xx=linspace(0,10,100);
% yy=0.220*log(xx)+0.508;
% plot(xx,yy,'k-.');

xlabel('Axon Diameter (in um)');
ylabel('G-ratio');

title('Logarithmic regression of G-ratio VS axon diameter');
legend('Dataset 1 : DA linear','Dataset 2 : DA quadratic','Dataset 3 : DA + LevelSet','Dataset 4 : LevelSet (no DA)','Location','Best');
grid on;
axis([0 10 0.45 0.65]);

hold off;











%% Use relation to find myelin thickness from axon equivalent diameter


% x : axon diameters of data (xm for us)
% y : g-ratio to estimate

a=myfit1.a;
b=myfit1.b;

Estimated_gRatios=a*log(xm)+b;

Estimated_MyelinThickness=(xm./Estimated_gRatios)-xm;

hist(Estimated_MyelinThickness);





%%

X = [ones(length(x),1) x];
b = X\y;

yCalc2 = X*b;
Rsq2 = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);

plot(x,yCalc2,'--');
hold on;

scatter(xs,ys);
hold off;


%% manual


scatter(xm,ym);
% [p,xm,ym]=selectdata;


hold on;

% myfittype2 = fittype('b + a*x','dependent',{'y'},'independent',{'x'},'coefficients',{'b','a'});
myfitm = fit(xm,ym,myfittype);

plot(myfitm,'r--');
hold off;
title('Dataset segmented manually (1500x)');
xlabel('Axon Diameter (in um)');
ylabel('G-ratio');
grid on;
axis([0 10 0.3 0.8]);




















