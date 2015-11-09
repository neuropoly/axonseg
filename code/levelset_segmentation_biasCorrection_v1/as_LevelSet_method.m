function img = as_LevelSet_method(img_init)
% 
% close all;
% clear all;

Img=img_init;
Img=double(Img(:,:,1)); % Convert initial image to 2 dim double
A=255;
Img=A*normalize01(Img); % normalize intensities from 0 to 254
nu=0.001*A^2; % coefficient of arc length term

sigma = 4; % scale parameter that specifies the size of the neighborhood
iter_outer=30; 
iter_inner=10;   % inner iteration for level set evolution

timestep=.1;
mu=1;  % coefficient for distance regularization term (regularize the level set function)

c0=1;
figure(1);
% imagesc(Img,[0, 255]); colormap(gray); axis off; axis equal

% initialize level set function


initialLSF = c0*ones(size(Img));  % a matrix of 1s with same size as Img



initialLSF(3:20,3:20) = -c0; % Put square of (-1s) in the middle of initialLSF
%initialLSF(30:90,50:90) = -c0; % Put square of (-1s) in the middle of initialLSF
% initialLSF(5:size(Img,1)-2,5:size(Img,2)-2) = -c0; % Put square of (-1s) in the middle of initialLSF

% cercle = strel('disk',20);


u=initialLSF; % Our u will be the initialLSF (has the initial contour)



hold on;
contour(u,[0 0],'r');
title('Initial contour');

% figure(2);
% imagesc(Img,[0, 255]); colormap(gray); axis off; axis equal
% hold on;
% contour(u,[0 0],'r');
% title('Initial contour');

epsilon=1;
b=ones(size(Img));  %%% initialize bias field with 1s same size as image

K=fspecial('gaussian',round(2*sigma)*2+1,sigma); % Gaussian kernel
KI=conv2(Img,K,'same'); % Result of convolution of image Img by K gaussian kernel
KONE=conv2(ones(size(Img)),K,'same');% Result of convolution of test image (only 1s) = white image with black contours

[row,col]=size(Img); % Take sizes x & y of Img
N=row*col; % Number of pixels in image (product of x size x y size)




for n=1:iter_outer
    
tic    
[u, b, C]= lse_bfe(u,Img, b, K,KONE, nu,timestep,mu,epsilon, iter_inner);    
toc
disp(n);


%     if mod(n,2)==0
%         pause(0.001);
%         imagesc(Img,[0, 255]); colormap(gray); axis off; axis equal;
%         hold on;
%         contour(u,[0 0],'r');
%         iterNum=[num2str(n), ' iterations'];
%         title(iterNum);
%         hold off;
%     end
   
end



Mask =(Img>10); % Create a binary mask
Img_corrected=normalize01(Mask.*Img./(b+(b==0)))*255;

% figure(3); imagesc(b);  colormap(gray); axis off; axis equal;
% title('Bias field');
% 
% figure(4);
% imagesc(Img_corrected); colormap(gray); axis off; axis equal;
% title('Bias corrected image');

%imshow(imcomplement(u));

% img = imcomplement(u);
img = u;


























