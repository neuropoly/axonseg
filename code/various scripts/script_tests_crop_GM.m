

file_img = uigetimagefile;
[PATHSTR,NAME,EXT] = fileparts(file_img);

img = imread(file_img);
[Pos, maskroi]=as_tools_maskGM(img);

mask = imcomplement(maskroi);
mask = double(mask);
img = double(img);
img = rgb2gray(img);
img_fin = mask.*img;
imshow(img_fin);

