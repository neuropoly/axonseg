function  BW=as_obj_remove(BW,imshowBW)
% BW=as_obj_remove(BW,im,(imshowBW?))
% Select objects to remove from binary mask
if nargin<3
    imshow(BW);
elseif imshowBW
    imshow(BW)
end
[Label]  = bwlabel(BW);
[c,r,~] = impixel;
rm=diag(Label(r,c));
BW=~ismember(Label,[0;rm]);
if nargin<3
    imshow(BW);
elseif imshowBW
    imshow(BW)
end
