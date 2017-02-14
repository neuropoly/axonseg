function img_zoom = as_display_LargeImage(img)

reducefactor=max(1,floor(size(img,1)/1000));   % Max 1000 pixels size set for imshow
imshow(img(1:reducefactor:end,1:reducefactor:end))
img_zoom=as_improc_cutFromRect(img, reducefactor);
reducefactor=max(1,floor(size(img_zoom,1)/1000));   % Max 1000 pixels size set for imshow
imshow(img_zoom(1:reducefactor:end,1:reducefactor:end));