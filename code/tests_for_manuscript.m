

aaa=uigetimagefile;
img=imread(aaa);

img=img(600:750,750:900,:);


H = fspecial('gaussian',3, 3);
img_smooth = imfilter(img,H);
img1=img_smooth;

H = fspecial('gaussian',3, 0.5);
img_smooth = imfilter(img,H);
img2=img_smooth;

H = fspecial('average',3);
img_smooth = imfilter(img,H);
img3=img_smooth;


a=imhmin(img1,70);
imshow(a);
b=imregionalmin(a);
imshow(b);


BW = imregionalmin(imhmin(img,70,8),8);
imshow(BW);

figure;
subplot(1,3,1);
imshow(img);
subplot(1,3,2);
imshow(img1);
subplot(1,3,3);
imshow(img3);

rrr=img1-img3;
imshow(rrr);

imwrite(img,'test_gaussian2.tif');
imwrite(img1,'test_gaussian2_before.tif');
imwrite(img2,'test_gaussian2_after.tif');

imshow(img);
imshow(img1);
imshow(img2);






test=50*ones(7,7);
test(2:3,2:3)=15;
test(5:6,5:6)=5;
sc(test);

a=imhmin(test,7);
sc(a);
b=imregionalmin(a);
sc(b);












