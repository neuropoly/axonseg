



I=double(cdata);

class_number=2;
potential=0.95;
maxIter=20;
seg=ICM(I,class_number,potential,maxIter);
figure; 
imshow(seg,[]);

seg=im2bw(mat2gray(seg));
imshow(seg);
% imwrite(seg,'BW_myelin.tif');

imshow(imfuse(cdata,seg));



%%
im0=mat2gray(seg);
imshow(im0);

im1=imcomplement(im0);
imshow(im1);

im2=imfill(im1,'holes'); %imshow(initialBW)
imshow(im2);

im3=bwmorph(im2,'fill'); 
imshow(im3);

im3=bwmorph(im3,'close'); 
imshow(im3);

im3=bwmorph(im3,'hbreak'); 
imshow(im3);

im3 = bwareaopen(im3,5);
imshow(im3);











