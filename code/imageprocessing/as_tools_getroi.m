function [Pos, maskroi]=as_tools_getroi(img,reduced,fig)
% maskroi=as_tools_getroi(img,reduced,fig)
if ~exist('reduced','var'), reduced=max(1,floor(size(img,1)/1000)); end
if ~exist('fig','var') || fig
    figure
    imshow(img(1:reduced:end,1:reduced:end))
end
P = impoly;
Pos=P.getPosition.*reduced;
P.delete
close; drawnow;
if nargout>1
    maskroi=poly2mask(Pos(:,1),Pos(:,2),size(img,1),size(img,2));
end
%maskroi=DrawSegmentedArea2D(Pos(:,[2 1]),size(img));




