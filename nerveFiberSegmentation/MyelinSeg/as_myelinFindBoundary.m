function [x1s, x2s]=as_myelinFindBoundary(imRadialProfileGrad,EquivDiameter)
dbstop if error
[x,y]=meshgrid(1:size(imRadialProfileGrad,2),linspace(0,360,size(imRadialProfileGrad,1)));

nbsplinenodes=floor(size(imRadialProfileGrad,1)/2);
x0=[floor(0.1*EquivDiameter)*ones(nbsplinenodes,1); floor(0.1*EquivDiameter+0.15*EquivDiameter)*ones(nbsplinenodes,1)];

A=[diag(ones(1, length(x0)/2)) , -diag(ones(1, length(x0)/2))];
ub=max(max(x))/2*ones(1,2*nbsplinenodes);
lb=ones(1,2*nbsplinenodes);
b=zeros(length(x0)/2,1);

options=optimoptions('fmincon','DiffMinChange',1);
xmopt=fmincon(@(xm) costfun(imRadialProfileGrad,xm(1:end/2),xm(end/2+1:end),x,y,EquivDiameter), x0,A,b,[],[],lb,ub,[],options);

x1=xmopt(1:end/2);
x2=xmopt(end/2+1:end);
[~, x1s, x2s]=costfun(imRadialProfileGrad,x1,x2,x,y,EquivDiameter);

function [cost, x1s, x2s]=costfun(imRadialProfileGrad,x1,x2,x,y,equivDiameter)
x1'
x2'
a=0.8;
b=0.3;

% create spline using the N=length(x1) nodes points spaced between 0 and 360°
angles=round(linspace(0,360,length(x1)+1)); angles=angles(1:end-1);
x1s = csaps(angles,x1,b,unique(y));
x2s = csaps(angles,x2,b,unique(y));

% Gradient maximal and minimal at myelin borders regulation
pgradient=interp2(x,y,imRadialProfileGrad,x1s,unique(y))-interp2(x,y,imRadialProfileGrad,x2s,unique(y));
pgradient(isnan(pgradient))=0;
% Gratio regulation:
gratio=equivDiameter./(2*(x2s-x1s)+equivDiameter);
pgratio=pdf('ev',gratio,0.77,0.18);


% Cost function
cost=-a*sum(pgradient)-(1-a)*sum(pgratio)

% display
figure(3)
hold off
imshow(imRadialProfileGrad',[0.5 1])
colormap gray
hold on
plot(unique(y),x1s,'b')
plot(unique(y),x2s,'r')