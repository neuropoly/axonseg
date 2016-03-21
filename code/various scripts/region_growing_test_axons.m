
img_path_1 = uigetimagefile;
img = imread(img_path_1);
img = img(:,:,2);

img=rgb2gray(img);
img=im2double(img);

img_smooth=as_gaussian_smoothing(img);


imshow(img);
[x,y,~]=impixel;

nbr=size(x,1);


for i=1:nbr
    
    J=regiongrowing(img_smooth,y(i),x(i),0.1);
    figure(i); imshow(J+img_smooth);
    
end


J=regiongrowing(img_smooth,x(4),y(4),0.1);
J2 = J(:,:,1)+J(:,:,2)+J(:,:,3);
imshow(J2);

imshow(J+img);





