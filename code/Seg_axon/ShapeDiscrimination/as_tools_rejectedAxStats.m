function [hgr,pgr,hac,pac]=as_tools_rejectedAxStats(Axonlist,img,matrixsize)

axonseg=as_display_label( Axonlist,matrixsize,'axon number','axon');
axonseg=logical(axonseg);
sc(0.9*sc(img)+0.1*sc(axonseg,'cool'));

[Label, numAxonObj]  = bwlabel(axonseg);
[c,r,~] = impixel;
rm=diag(Label(r,c));
liste=1:max(max(Label));
False=false(size(liste));

for i=1:length(rm)
False(rm(i))=1;
end

Right=1-False;

BadStats=Axonlist(False==1);
GoodStats=Axonlist(Right==1);

Goodac=cat(1,GoodStats.axonEquivDiameter);
Badac=cat(1,BadStats.axonEquivDiameter);


Goodgr=cat(1,GoodStats.gRatio);
Badgr=cat(1,BadStats.gRatio);

[hgr,pgr]=ttest2(Goodgr,Badgr);
[hac,pac]=ttest2(Goodac,Badac);

FalsePos=sum(False);
TruePos=sum(Right);



