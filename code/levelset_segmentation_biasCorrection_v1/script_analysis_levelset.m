% script_analysis_levelset


img_path_1 = uigetimagefile;
img_gray = imread(img_path_1);

% Mu



inner5=LevelSet_results.img;

figure;
subplot(231);
imshow(imfuse(base,base));
subplot(232);
imshow(imfuse(inner1,base));
subplot(233);
imshow(imfuse(inner2,base));
subplot(234);
imshow(imfuse(inner3,base));
subplot(235);
imshow(imfuse(inner4,base));
subplot(236);
imshow(imfuse(inner5,base));

figure;
subplot(231);
imshow(imfuse(base,img_gray));
subplot(232);
imshow(imfuse(inner1,img_gray));
subplot(233);
imshow(imfuse(inner2,img_gray));
subplot(234);
imshow(imfuse(inner3,img_gray));
subplot(235);
imshow(imfuse(inner4,img_gray));
subplot(236);
imshow(imfuse(inner5,img_gray));

figure;
subplot(231);
imshow(im2bw(base));
subplot(232);
imshow(im2bw(base-inner1));
subplot(233);
imshow(im2bw(base-inner2));
subplot(234);
imshow(im2bw(base-inner3));
subplot(235);
imshow(im2bw(base-inner4));
subplot(236);
imshow(im2bw(base-inner5));



imshow(imfuse(base,inner1));

imshow(im2bw(base-mu1));



imwrite








