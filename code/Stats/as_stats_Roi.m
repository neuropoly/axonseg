function [Index, Stats]=as_stats_Roi(axonlist, img, mask )
% [Index, Stats] = as_stats_Roi(axonlist, img)
% [Index, Stats] = as_stats_Roi(axonlist, [], mask)
% axonlist_ROI= axonlist(Index)

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

Index= in==1;


if nargout>1
    axonlistInRoi=axonlist(Index);
    gRatio=cat(1,axonlistInRoi.gRatio);
    myelinArea=cat(1,axonlistInRoi.myelinArea);
    axonArea=cat(1,axonlistInRoi.axonArea);
    myelinEquivDiameter=cat(1,axonlistInRoi.myelinEquivDiameter);
    axonEquivDiameter=cat(1,axonlistInRoi.axonEquivDiameter);
    myelinThickness=cat(1,axonlistInRoi.myelinThickness);
    Stats=struct('gRatio',gRatio,'myelinArea',myelinArea,'axonArea',axonArea,'myelinEquivDiameter',myelinEquivDiameter,'axonEquivDiameter',axonEquivDiameter,'myelinThickness',myelinThickness);
end

