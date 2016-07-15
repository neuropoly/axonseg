
img_path_1 = uigetimagefile;
img1 = imread(img_path_1);

img_path_2 = uigetimagefile;
img2 = imread(img_path_2);


%%

imshowpair(img1,img2);


c = normxcorr2(img1,img2);
figure, surf(c), shading flat

imagesc(c);

max_x=max(max(c));

[ypeak, xpeak] = find(c==max(c(:)));

yoffSet = ypeak-size(img1,1);
xoffSet = xpeak-size(img2,2);


%%


c=normxcorr2_general(img1,img2);

[ypeak, xpeak] = find(c==max(c(:)));

yoffSet = ypeak-size(img1,1);
xoffSet = xpeak-size(img2,2);



%%

