
img_path1 = uigetimagefile;
img1 = imread(img_path1);

img_path2 = uigetimagefile;
img2 = imread(img_path2);

img11 = img1(:,:,1);

[Pos, maskroi]=as_tools_getroi(img11,'rect');



img_crop1 = img1(Pos(3):Pos(4),Pos(1):Pos(2),:);
img_crop2 = img2(Pos(3):Pos(4),Pos(1):Pos(2),:);
figure(1)
imshow(img_crop1);
figure(2)
imshow(img_crop2);


savedir = uigetdir;
imwrite(img_crop1,[savedir filesep 'crop_img_BW2.jpg']);
imwrite(img_crop2,[savedir filesep 'crop_img_Myelin2.jpg']);






