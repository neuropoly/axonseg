function [AXstat, MorphoStat]=as_stats(myelinseg,pixelSize)
% statis=as_stats(myelinseg,pixelSize)
myelinseg=reshape2D(myelinseg,1);
cc = bwconncomp(myelinseg, 4);
prop =regionprops(cc, {'Area', 'FilledArea'});

% Creation of a struct var for the stats
AXstat=struct('myelinArea',0,'axonArea',0,'myelinEquivDiameter',0,'axonEquivDiameter',0,'gRatio',0,'myelinThickness',0);


if ~isempty(prop)
    % Area gives myelin area & FilledArea gives (myelin+axon) area
    area = [[prop.Area]' [prop.FilledArea]'-[prop.Area]'];
    % Calculate myelin area by using pixel size
    AXstat.myelinArea = single(area(:, 1).*pixelSize^2);
    % Calculate axon area by using pixel size
    AXstat.axonArea = single(area(:, 2).*pixelSize^2);
    % Myelin equiv. diameter = sqrt(4*TotalArea/pi)
    AXstat.myelinEquivDiameter = single(sqrt(4*(AXstat.myelinArea + AXstat.axonArea)/pi));
    % Axon equiv. diameter = sqrt(4*AxonArea/pi)
    AXstat.axonEquivDiameter = single(sqrt(4*AXstat.axonArea/pi));
    % Calculate gRatio
    AXstat.gRatio = single(AXstat.axonEquivDiameter ./ AXstat.myelinEquivDiameter);
    % Myelin thickness = (MyelinDiam - AxonDiam)/2
    AXstat.myelinThickness = single((AXstat.myelinEquivDiameter - AXstat.axonEquivDiameter) / 2);
    
%     if nargout>0
%         MorphoStat.circularity=;
%     end
end


