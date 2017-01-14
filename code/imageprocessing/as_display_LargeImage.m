function img_zoom = as_display_LargeImage(img)
% img_zoom = as_display_LargeImage(img)
%   Example 1
%   ---------
%   Display a very large image and zoom in a selected region
%
%       AS_DISPLAY_LARGEIMAGE(img)
%
%   Example 2
%   ---------
%   Double step zoom: zoom twice in an image
%
%       AS_DISPLAY_LARGEIMAGE(AS_DISPLAY_LARGEIMAGE(img))

reducefactor=max(1,floor(size(img,1)/1000));   % Max 1000 pixels size set for imshow
imagesc(img(1:reducefactor:end,1:reducefactor:end))
colormap gray; axis image
img_zoom=as_improc_cutFromRect(img, reducefactor);
reducefactor=max(1,floor(size(img_zoom,1)/1000));   % Max 1000 pixels size set for imshow
imagesc(img_zoom(1:reducefactor:end,1:reducefactor:end));
colormap gray; axis image
