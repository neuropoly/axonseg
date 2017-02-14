% inhomogeneity correction in histology


img=imread('PANO_HIGHRES.png');
img2=imopen(img,strel('disk',15));

imshow(img2);













