function Stats=as_tools_StatsRoi( seg ,axonlist, mask )
if exist('mask')
    P=mask2poly(mask);
else
    [~ , P]=as_tools_getroi(seg);
end

Centroid=cat(1,axonlist.Centroid);
Centroidx=Centroid(:,1);
Centroidy=Centroid(:,2);

Px=P(:,1);
Py=P(:,2);

in=inpolygon(Centroidx,Centroidy,Px,Py);

Id=find(in==1);

AxInRoi=axonlist(Id);

gRatio=cat(1,AxInRoi.gRatio);
myelinArea=cat(1,AxInRoi.myelinArea);
axonArea=cat(1,AxInRoi.axonArea);
myelinEquivDiameter=cat(1,AxInRoi.myelinEquivDiameter);
axonEquivDiameter=cat(1,AxInRoi.myelinArea);
myelnThickness=cat(1,AxInRoi.myelnThickness);

Stats=struct('gRatio',gRatio,'myelinArea',myelinArea,'axonArea',axonArea,'myelinEquivDiameter',myelinEquivDiameter,'axonEquivDiameter',axonEquivDiameter,'myelnThickness',myelnThickness);

