function as_myelinseg_minimalpath_displayoutput(S)

[mv1,mi1]=min(S,[],2);
% [mv2,mi2]=min(fliplr(S),[],2);]
sR=(1:length(mi1));
sC=round(mi1);
sc(S);
hold on
plot(sC,sR,'r')
hold off