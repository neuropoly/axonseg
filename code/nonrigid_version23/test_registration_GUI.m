
img_path_1 = uigetimagefile;
Istatic = imread(img_path_1);

img_path_2 = uigetimagefile;
Imoving = imread(img_path_2);


rgbImage = repmat(Imoving,[1 1 3]);



Istatic2 = imresize(Istatic,0.3);


manually_warp_images(rgbImage,Istatic2);
manually_warp_images(Imoving,Istatic);


rgbImage=im2double(rgbImage);
Istatic2=im2double(Istatic2);

rgbImage=rgb2gray(rgbImage);
Istatic2=rgb2gray(Istatic2);



figure(1);
imshow(rgbImage);

figure(2);
imshow(Istatic2);


imagesc(rgbImage);

figure(1);








