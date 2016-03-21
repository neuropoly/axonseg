function img_smooth=as_gaussian_smoothing(img)
% Function that performs a gaussian denoise

H = fspecial('gaussian',3, 3);
img_smooth = imfilter(img,H);

end