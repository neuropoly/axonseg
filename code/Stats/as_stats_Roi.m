function [axonlistInRoi, Stats]=as_stats_Roi(axonlist, img, mask )
% [axonlistInRoi, Stats] = as_stats_Roi(axonlist, img)
% [axonlistInRoi, Stats] = as_stats_Roi(axonlist, [], mask)

if isempty(img)
    P=mask2poly(mask);
else
    P=as_tools_getroi(img);
end

Centroid=cat(1,axonlist.Centroid);
Centroidx=Centroid(:,1);
Centroidy=Centroid(:,2);

Px=P(:,2);
Py=P(:,1);

in=inpolygon(Centroidx,Centroidy,Px,Py);

Id= in==1;

axonlistInRoi=axonlist(Id);
if nargout>1
    gRatio=cat(1,axonlistInRoi.gRatio);
    myelinArea=cat(1,axonlistInRoi.myelinArea);
    axonArea=cat(1,axonlistInRoi.axonArea);
    myelinEquivDiameter=cat(1,axonlistInRoi.myelinEquivDiameter);
    axonEquivDiameter=cat(1,axonlistInRoi.axonEquivDiameter);
    myelinThickness=cat(1,axonlistInRoi.myelinThickness);
    Stats=struct('gRatio',gRatio,'myelinArea',myelinArea,'axonArea',axonArea,'myelinEquivDiameter',myelinEquivDiameter,'axonEquivDiameter',axonEquivDiameter,'myelinThickness',myelinThickness);
end

