function statis=as_stats_axonSeg(AxonSeg,pixelSize)
% statis=as_stats(myelinseg,pixelSize)
AxonSeg=reshape2D(AxonSeg,1);
cc = bwconncomp(AxonSeg, 4);
prop =regionprops(cc, {'Area'});

% Creation of a struct var for the stats
statis=struct('axonArea',0,'axonEquivDiameter',0);


if ~isempty(prop)
    area = [prop.Area]';
    % Axon area
    statis.axonArea = single(area.*pixelSize^2);
    % Axon equiv. diameter = sqrt(4*AxonArea/pi)
    statis.axonEquivDiameter = single(sqrt(4*statis.axonArea/pi));
end

% 
%     % Area gives myelin area & FilledArea gives (myelin+axon) area
%     area = [[prop.Area]' [prop.FilledArea]'-[prop.Area]'];
%     % Calculate myelin area by using pixel size
%     statis.myelinArea = single(area(:, 1).*pixelSize^2);
%     % Calculate axon area by using pixel size
%     statis.axonArea = single(area(:, 2).*pixelSize^2);