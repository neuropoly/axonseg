img_path_1 = uigetimagefile;
img = imread(img_path_1);

img_path_2 = uigetimagefile;
bw = imread(img_path_2);

bw2=uint8(bw);

res=img.*bw2;

imshow(res);



bw3=imcomplement(bw);
bw4=uint8(bw3);
res2=img.*bw4;
imshow(res2);




%% stats --- features --- weights

Features=as_stats_axons(bw,img);

% bar(cat(1,Features.Skewness));

































