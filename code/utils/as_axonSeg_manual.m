function manualBW=as_axonSeg_manual(type)
% manualBW=as_axonSeg_manual_ellipse
if ~exist('type','var'), type='free'; end
if strcmp(type,'free')
    object=imfreehand;
elseif strcmp(type,'ellipse')
    object=imellipse;
end
wait(object);
manualBW = createMask(object);
object.delete;
