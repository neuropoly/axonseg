


img_path_1 = uigetimagefile;
img = imread(img_path_1);

img(50:50:end,:,:) = 255;       %# Change every tenth row to black
img(:,50:50:end,:) = 255;       %# Change every tenth column to black
imshow(img);                  %# Display the image





