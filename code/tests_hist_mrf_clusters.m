img_path_1 = uigetimagefile;
gray = imread(img_path_1);

gray=rgb2gray(gray);
imhist(gray);



gray2=gray(:);
gray3=gray2(1:100);

test=kmeans(gray3,2);


gray_hist=gray;





