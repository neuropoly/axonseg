function statis=as_stats(myelinseg,pixelSize)
% statis=as_stats(myelinseg,pixelSize)
myelinseg=reshape2D(myelinseg,1);
cc = bwconncomp(myelinseg, 4);
prop =regionprops(cc, {'Area', 'FilledArea'});
statis=struct('myelinArea',0,'axonArea',0,'myelinEquivDiameter',0,'axonEquivDiameter',0,'gRatio',0,'myelinThickness',0);
if ~isempty(prop)
    area = [[prop.Area]' [prop.FilledArea]'-[prop.Area]'];
    
    statis.myelinArea = single(area(:, 1).*pixelSize^2);
    statis.axonArea = single(area(:, 2).*pixelSize^2);
    statis.myelinEquivDiameter = single(sqrt(4*(statis.myelinArea + statis.axonArea)/pi));
    statis.axonEquivDiameter = single(sqrt(4*statis.axonArea/pi));
    statis.gRatio = single(statis.axonEquivDiameter ./ statis.myelinEquivDiameter);
    statis.myelinThickness = single((statis.myelinEquivDiameter - statis.axonEquivDiameter) / 2);
end