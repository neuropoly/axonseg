function img_smooth=as_gaussian_smoothing(img)
% Function that performs an averaging denoise

H = fspecial('average',3);
img_smooth = imfilter(img,H);

end