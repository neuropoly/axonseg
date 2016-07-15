img_path_1 = uigetimagefile;
img = imread(img_path_1);

imshow(img);

img2=img(4000:5000,19000:20000,:);
img2=img(15000:16000,25000:26000,:);
imshow(img2);
imwrite(img2,'20150929_rat_moelle_2_slice_3_9000_11000_5000_8000.tif');



img_path_2 = uigetimagefile;
FALSE = imread(img_path_2);

img_path_3 = uigetimagefile;
gray = imread(img_path_3);






%% region growing

img_path_1 = uigetimagefile;
img = imread(img_path_1);

I = im2double(img);

J = regiongrowing(I); 
figure, imshow(I+J);
imshow(J);