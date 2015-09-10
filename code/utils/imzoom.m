function imzoom(im,coords,margin)
% show image around the coordinates X and Y
% imzoom(im,coords,margin)
% coords [X,Y] is a Nx2 matrix with x and y coordinates
% This function will imshow(im). Zooming on coords
imshow(im)
ylim([max(1,min(coords(:,1))-margin) min(size(im,1),max(coords(:,1))+margin)])
xlim([max(1,min(coords(:,2))-margin) min(size(im,2),max(coords(:,2)))+margin])