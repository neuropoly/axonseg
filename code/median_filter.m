


B=medfilt2(img, [5 5]);
imshow(B);

imwrite(B,'med5x5.tif');

C=B-img;
imshow(C);
