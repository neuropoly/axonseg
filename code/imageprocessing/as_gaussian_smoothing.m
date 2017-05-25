function img_smooth=as_gaussian_smoothing(img)
% Function that performs an averaging denoise

img_smooth = medfilt2(img,[8 8]);

end