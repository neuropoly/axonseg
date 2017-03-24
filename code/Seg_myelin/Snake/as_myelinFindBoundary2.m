function [x1, x2]=as_myelinFindBoundary2(im1,im2,EquivDiameter,verbose,khomo_off)
if ~isdeployed, dbstop if error; end
Nangles=size(im1,1);
[~,Problematiclength]=find(im1==0); Problematiclength=min(min(Problematiclength));

if isempty(Problematiclength), Problematiclength=size(im1,2); end
if (Problematiclength <= 3), Problematiclength=size(im1,2); end
[~,x2]=minimalPath(im2,1,0);
[~,x1]=minimalPath(im1,1,0);

P=[(1:Nangles)',x1, min(floor(x2), Problematiclength-1)];




Options.Verbose=verbose;
Options.Sigma1=1;
Options.Gamma=2;
Options.Wline=0.2;
Options.Wedge=5;
Options.Iterations=50;
if khomo_off
    Options.khomo=0;
    Options.kfixinner=0.001;
end
Options.Mu=0;
Options.Sigma3=1;
Options.GIterations=0;

P=Snake2D(im1(:,2:Problematiclength-1),im2(:,2:Problematiclength-1),P,EquivDiameter,Options);

theta=linspace(0,2*pi,Nangles+1); theta=theta(1:end-1);
x1=P(:,2);
x2=P(:,3);