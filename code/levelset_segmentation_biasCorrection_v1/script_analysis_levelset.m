% script_analysis_levelset


img_path_1 = uigetimagefile;
img_gray = imread(img_path_1);

%% Mu



base=LevelSet_results.img;
mu1=LevelSet_results.img;
mu2=LevelSet_results.img;
mu3=LevelSet_results.img;
mu4=LevelSet_results.img;
mu5=LevelSet_results.img;
mu6=LevelSet_results.img;

figure;
subplot(231);
imshow(imfuse(base,base));
subplot(232);
imshow(imfuse(mu1,base));
subplot(233);
imshow(imfuse(mu3,base));
subplot(234);
imshow(imfuse(mu4,base));
subplot(235);
imshow(imfuse(mu5,base));

%% epsilon

epsilon1=LevelSet_results.img;
epsilon2=LevelSet_results.img;
epsilon3=LevelSet_results.img;
epsilon4=LevelSet_results.img;
epsilon5=LevelSet_results.img;

figure;
subplot(231);
imshow(imfuse(base,img_gray));
subplot(232);
imshow(imfuse(epsilon1,img_gray));
subplot(233);
imshow(imfuse(epsilon2,img_gray));
subplot(234);
imshow(imfuse(epsilon3,img_gray));
subplot(235);
imshow(imfuse(epsilon4,img_gray));
subplot(236);
imshow(imfuse(epsilon5,img_gray));

figure;
subplot(231);
imshow(im2bw(base));
subplot(232);
imshow(im2bw(base-epsilon1));
subplot(233);
imshow(im2bw(base-epsilon2));
subplot(234);
imshow(im2bw(base-epsilon3));
subplot(235);
imshow(im2bw(base-epsilon4));
subplot(236);
imshow(im2bw(base-epsilon5));


%% timestep

timestep1=LevelSet_results.img;
timestep2=LevelSet_results.img;
timestep3=LevelSet_results.img;
timestep4=LevelSet_results.img;

figure;
subplot(231);
imshow(imfuse(base,img_gray));
subplot(232);
imshow(imfuse(timestep1,img_gray));
subplot(233);
imshow(imfuse(timestep2,img_gray));
subplot(234);
imshow(imfuse(timestep3,img_gray));
subplot(235);
imshow(imfuse(timestep4,img_gray));


figure;
subplot(231);
imshow(im2bw(base));
subplot(232);
imshow(im2bw(base-epsilon1));
subplot(233);
imshow(im2bw(base-epsilon2));
subplot(234);
imshow(im2bw(base-epsilon3));
subplot(235);
imshow(im2bw(base-epsilon4));
subplot(236);
imshow(im2bw(base-epsilon5));

%% c0

c1=LevelSet_results.img;
c2=LevelSet_results.img;
c3=LevelSet_results.img;
c4=LevelSet_results.img;
c5=LevelSet_results.img;

figure;
subplot(231);
imshow(imfuse(base,img_gray));
subplot(232);
imshow(imfuse(c1,img_gray));
subplot(233);
imshow(imfuse(c2,img_gray));
subplot(234);
imshow(imfuse(c3,img_gray));
subplot(235);
imshow(imfuse(c4,img_gray));
subplot(236);
imshow(imfuse(c5,img_gray));

figure;
subplot(231);
imshow(im2bw(base));
subplot(232);
imshow(im2bw(base-c1));
subplot(233);
imshow(im2bw(base-c2));
subplot(234);
imshow(im2bw(base-c3));
subplot(235);
imshow(im2bw(base-c4));
subplot(236);
imshow(im2bw(base-c5));

%% nu

nu1=LevelSet_results.img;
nu2=LevelSet_results.img;
nu3=LevelSet_results.img;
nu4=LevelSet_results.img;
nu5=LevelSet_results.img;
nu6=LevelSet_results.img;

figure;
subplot(241);
imshow(imfuse(base,img_gray));
subplot(242);
imshow(imfuse(nu1,img_gray));
subplot(243);
imshow(imfuse(nu2,img_gray));
subplot(244);
imshow(imfuse(nu3,img_gray));
subplot(245);
imshow(imfuse(nu4,img_gray));
subplot(246);
imshow(imfuse(nu5,img_gray));
subplot(247);
imshow(imfuse(nu6,img_gray));

figure;
subplot(241);
imshow(im2bw(base));
subplot(242);
imshow(im2bw(base-nu1));
subplot(243);
imshow(im2bw(base-nu2));
subplot(244);
imshow(im2bw(base-nu3));
subplot(245);
imshow(im2bw(base-nu4));
subplot(246);
imshow(im2bw(base-nu5));
subplot(247);
imshow(im2bw(base-nu6));

figure;
subplot(231);
imshow(im2bw(base));
subplot(232);
imshow(im2bw(base-c1));
subplot(233);
imshow(im2bw(base-c2));
subplot(234);
imshow(im2bw(base-c3));
subplot(235);
imshow(im2bw(base-c4));
subplot(236);
imshow(im2bw(base-c5));



%%

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








