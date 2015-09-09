function stats=as_RoiStats(seg2d,roi,pixelSize)
% function stats=as_RoiStats(seg2d,roi,pixelSize)
if ~isempty(roi), seg2d(~roi)=1; crop=seg2d; end
crop=RemoveBorder(crop);
stats=as_stats(crop,pixelSize);





