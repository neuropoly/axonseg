function statis=as_stats(myelinseg,pixelSize)
% statis=as_stats(myelinseg,pixelSize)
myelinseg=reshape2D(myelinseg,1);
cc = bwconncomp(myelinseg, 4);
prop =regionprops(cc, {'Area', 'FilledArea'});

% Creation of a struct var for the stats
statis=struct('myelinArea',0,'axonArea',0,'myelinEquivDiameter',0,'axonEquivDiameter',0,'gRatio',0,'myelinThickness',0);


if ~isempty(prop)
    % Area gives myelin area & FilledArea gives (myelin+axon) area
    area = [[prop.Area]' [prop.FilledArea]'-[prop.Area]'];
    % Calculate myelin area by using pixel size
    statis.myelinArea = single(area(:, 1).*pixelSize^2);
    % Calculate axon area by using pixel size
    statis.axonArea = single(area(:, 2).*pixelSize^2);
    % Myelin equiv. diameter = sqrt(4*TotalArea/pi)
    statis.myelinEquivDiameter = single(sqrt(4*(statis.myelinArea + statis.axonArea)/pi));
    % Axon equiv. diameter = sqrt(4*AxonArea/pi)
    statis.axonEquivDiameter = single(sqrt(4*statis.axonArea/pi));
    % Calculate gRatio
    statis.gRatio = single(statis.axonEquivDiameter ./ statis.myelinEquivDiameter);
    % Myelin thickness = (MyelinDiam - AxonDiam)/2
    statis.myelinThickness = single((statis.myelinEquivDiameter - statis.axonEquivDiameter) / 2);
end