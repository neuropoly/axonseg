
%% synthetic images from axon packing

a=uigetimagefile;
a=imread(a);

f=uigetimagefile;
f=imread(f);

img=a+f;
imshow(img);

aaa=img;

img(aaa==2)=25;
img(aaa==1)=200;
img(aaa==0)=150;

img=uint8(img);

imshow(img);

imwrite(img,'20161130_200_5um_0um_gap1um.tif');



mask_stats=compute_stats_from_axonlist(axonlist,PixelSize,img);

[mean_gap_axon]=gap_axons(axonlist,PixelSize,3);







good_pixelsize=0.05*1/mask_stats.axon_diam_std;



%% add noise

a1=imnoise(img,'salt & pepper',0.05);
imshow(a1);

a2=imnoise(img,'speckle',0.05);
imshow(a2);



%% deformation

tform=affine2d([1 0 0; .5 1 0; 0 0 1]);
b1=imwarp(img,tform);
imshow(b1);

tform=affine2d([1 0.4 0; 0 1 0; -0.3 0 1]);
b1=imwarp(b1,tform);
imshow(b1);







