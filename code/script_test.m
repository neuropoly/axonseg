
img_path = uigetimagefile;
img = imread(img_path);

img = img(:,:,1);

[Pos, maskroi]=as_tools_getroi(img,'rect');



