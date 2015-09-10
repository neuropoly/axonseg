function [axonBW, axonRejectBW] = axonInitialSegmentation(im, h )

if nargin < 2
    h = std(double(im(:)));
end
initialBW=imextendedmin(im,h,8);%bwmorph(bwmorph(bwmorph(watershed(imimposemin(im,imextendedmin(im,h,8)))~=0,'thin'),'thin'),'thin');
% level = graythresh(im);
% initialBW=im2bw(im,level);
 initialBW=bwmorph(initialBW,'fill'); %imshow(initialBW)
 initialBW=bwmorph(initialBW,'close'); %imshow(initialBW)
 initialBW=bwmorph(initialBW,'hbreak'); %imshow(initialBW)
 initialBW=bwmorph(initialBW,'open'); %imshow(initialBW)
 initialBW=bwmorph(initialBW,'majority'); %imshow(initialBW)
 initialBW=imfill(initialBW,'holes'); %imshow(initialBW)
%CH_objects = bwconvhull(initialBW,'objects'); %imshow(initialBW)
% Clear border
axonBW = imclearborder(initialBW);

axonRejectBW = xor(initialBW, axonBW);