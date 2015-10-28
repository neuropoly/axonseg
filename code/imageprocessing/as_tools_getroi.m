function [Pos, maskroi]=as_tools_getroi(img,type,reduced,fig)
% maskroi=as_tools_getroi(img,type,reduced,fig)
% type can be 'rect' or 'poly';
% Example : [Pos, maskroi]=as_tools_getroi(img,'rect');
% img_croped =
%
% See Also: as_stats_Roi
if ~exist('reduced','var'), reduced=max(1,floor(size(img,1)/1000)); end
if ~exist('type','var'), type='poly'; end
if ~exist('fig','var') || fig
    figure
    imshow(img(1:reduced:end,1:reduced:end))
end

if nargout && strcmp(type,'rect')
    P = imrect;
    Pos=P.getPosition.*reduced;
    % maskroi=I(max(h(2),1):min(h(2)+h(4),end),max(h(1),1):min(h(1)+h(3),end));
    P.delete;
    close;
    drawnow;
    
    X1 = round(Pos(1));
    Y1 = round(Pos(2));
    X2 = round(X1 + Pos(3));
    Y2 = round(Y1 + Pos(4));
    
    if nargout>1
        maskroi=poly2mask([X1 X2 X2 X1],[Y1 Y1 Y2 Y2],size(img,1),size(img,2));
    end
    
elseif nargout && strcmp(type,'poly')
    P = impoly;
    Pos=P.getPosition.*reduced;
    P.delete
    close; drawnow;
    
    if nargout>1
        maskroi=poly2mask(Pos(:,1),Pos(:,2),size(img,1),size(img,2));
    end
    
    
end



%maskroi=DrawSegmentedArea2D(Pos(:,[2 1]),size(img));




