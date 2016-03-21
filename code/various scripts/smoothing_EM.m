
img_path_1 = uigetimagefile;
img = imread(img_path_1);


H = fspecial('gaussian',3, 2);
img_smooth = imfilter(img,H);


% H = fspecial('average',3);
% img_smooth = imfilter(img,H);


figure(1);
subplot(121);
imshow(img);
subplot(122);
imshow(img_smooth);



cx=1;
cy=1;
c=1;

figure(2);

for size_f=2:5
    for std=2:5

        H = fspecial('gaussian',size_f, std);
        img_smooth = imfilter(img,H);
        subplot(cx,cy,c);
        title(['gaussian filter size : ' num2str(size_f) '  & std : ' num2str(std)]); 
        imshow(img_smooth);
        hold on;
   
cy=cy+1;
c=c+1;

    end
    cx=cx+1;    
end
        
hold off;
        
        
        
        
        