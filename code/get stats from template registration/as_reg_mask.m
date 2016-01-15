function [mask_reg_labeled, P_color]=as_reg_mask(mask,img)
% For a given mask & an image, the function finds the registration between
% the two. The outputs are the registered & labeled mask (each region of
% the mask has a different label according to the labeling done by the
% user. The second output is the color vector giving the color for each
% labeled region.
%

% img_path_1 = uigetimagefile;
% mask = imread(img_path_1);
% 
% img_path_2 = uigetimagefile;
% img = imread(img_path_2);





% Ex: [mask_reg_labeled, P_color]=as_reg_mask(pres0x2E001(:,:,1:3),img);

% mask1 = reg_mask(pres0x2E001(:,:,1:3),img);

% mask=pres0x2E001(:,:,1:3);

reduced=max(1,floor(size(img,1)/1000));

% img=imread('img_lowres.jpg');

[tform,ref]=as_reg_histo2mri(mask,img(1:reduced:end,1:reduced:end,:));

mask_reg=imwarp(mask,tform,'outputview',ref);
imwrite(mask_reg,'Mask_reg_reduced_20163.tif');

% Get the mask with the right size

mask_reg=imresize(mask_reg,reduced);
mask_reg=mask_reg(1:size(img,1),1:size(img,2),:);
imwrite(mask_reg,'Mask_reg_real_size_20163.tif');

imshow(mask_reg(:,:,1:3)), axis image
P_color = impixel(mask_reg(:,:,1:3));


mask_reg=Mask_reg_reduced_20163;

mask_reg_labeled=int8(false(size(mask_reg,1),size(mask_reg,2)));
m=1;
for il=1:size(P_color,1)
mask_reg_labeled=mask_reg_labeled+il*int8(mask_reg(:,:,1)>P_color(il,1)-m & mask_reg(:,:,1)<P_color(il,1)+m ...
    & mask_reg(:,:,2)>P_color(il,2)-m & mask_reg(:,:,2)<P_color(il,2)+m & mask_reg(:,:,3)>P_color(il,3)-m & mask_reg(:,:,3)<P_color(il,3)+m);
sc(mask_reg_labeled);
drawnow
end



mask_reg_labeled=imresize(mask_reg_labeled,reduced);
mask_reg_labeled=mask_reg_labeled(1:size(img,1),1:size(img,2),:);
imwrite(uint8(mask_reg_labeled),'Mask_reg_real_size_20163_FINAL.tif');



imshow(mask_reg_labeled);

end