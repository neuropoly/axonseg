function  BW=as_obj_remove(BW,img)
% BW=as_obj_remove(BW)
% BW=as_obj_remove(BW, img) --> display figure
% Select objects to remove from binary mask
if exist('img','var')
    imshow(imfuse(BW,img,'blend'));
end
[Label]  = bwlabel(BW);
[c,r,~] = impixel;
rm=diag(Label(r,c));
BW=~ismember(Label,[0;rm]);
if exist('img','var')
    imshow(imfuse(BW,img,'blend'));
end
