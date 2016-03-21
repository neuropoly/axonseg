function [Pos, maskroi]=as_tools_maskGM(img,fig)
% maskroi=as_tools_getroi(img,reduced,fig)

if ~exist('fig','var') || fig
    figure
    imshow(img);
    
end
P = impoly;
Pos=P.getPosition;
P.delete;
close; 
drawnow;
if nargout>1
    maskroi=poly2mask(Pos(:,1),Pos(:,2),size(img,1),size(img,2));
end


