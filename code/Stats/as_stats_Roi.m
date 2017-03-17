function [Index, Stats]=as_stats_Roi(axonlist, img, mask )
% [Index, Stats] = as_stats_Roi(axonlist, img);
% [Index, Stats] = as_stats_Roi(axonlist, [], mask)
% [Index, Stats] = as_stats_Roi(axonlist, [], Poly) --> poly: Two dimentional [N,2] matrix with coordinates 
% axonlist_ROI= axonlist(Index);

if isempty(img)
    if size(mask,2)>2
        P=mask2poly(mask);
    else
        P=mask;
    end
else
    % polygon obtained manually
    P=as_tools_getroi(img);
end

% Get the axon centroids
Centroid=cat(1,axonlist.Centroid);
% Get the x values of the centroids
Centroidx=Centroid(:,1);
% Get the y values of the centroids
Centroidy=Centroid(:,2);

% Get the x values of the polygon
Px=P(:,2);
% Get the y values of the polygon
Py=P(:,1);

% Verify if the axons defined by their centroids are included in the
% polygon area
in=inpolygon(Centroidx,Centroidy,Px,Py);

% Keep only the coordinates of the axons included in the polygon
Index= in==1;


if nargout>1
    % Create new axon list by keeping only the axons in the ROI
    axonlistInRoi=axonlist(Index);
    
    % Keep the stats for the axons in the ROI
    gRatio=cat(1,axonlistInRoi.gRatio);
    myelinArea=cat(1,axonlistInRoi.myelinArea);
    axonArea=cat(1,axonlistInRoi.axonArea);
    myelinEquivDiameter=cat(1,axonlistInRoi.myelinEquivDiameter);
    axonEquivDiameter=cat(1,axonlistInRoi.axonEquivDiameter);
    myelinThickness=cat(1,axonlistInRoi.myelinThickness);
    
    % Put the combined stats in a struct
    Stats=struct('gRatio',gRatio,'myelinArea',myelinArea,'axonArea',axonArea,'myelinEquivDiameter',myelinEquivDiameter,'axonEquivDiameter',axonEquivDiameter,'myelinThickness',myelinThickness);
end

