
function [im_in,border_removed_mask]=RemoveBorder(im_in,pix_size)

MaximalMyelinLength=25;
MinimalMyelinLength=5;

nbr_pixels_remove=round(2*(1/pix_size));

if nbr_pixels_remove>MaximalMyelinLength
    nbr_pixels_remove=MaximalMyelinLength;
elseif nbr_pixels_remove<MinimalMyelinLength
    nbr_pixels_remove=MinimalMyelinLength;
end


im_in(nbr_pixels_remove:end-nbr_pixels_remove,nbr_pixels_remove:end-nbr_pixels_remove)=...
    imclearborder(im_in(nbr_pixels_remove:end-nbr_pixels_remove,nbr_pixels_remove:end-nbr_pixels_remove),8);


% Clear the 4 borders one by one
im_in(1:nbr_pixels_remove,:)=false;
im_in(:,1:nbr_pixels_remove)=false;
im_in(end-nbr_pixels_remove:end,:)=false;
im_in(:,end-nbr_pixels_remove:end)=false;


border_removed_mask=zeros(size(im_in,1),size(im_in,2));
border_removed_mask=im2bw(border_removed_mask);

border_removed_mask(1:nbr_pixels_remove,:)=true;
border_removed_mask(:,1:nbr_pixels_remove)=true;
border_removed_mask(end-nbr_pixels_remove:end,:)=true;
border_removed_mask(:,end-nbr_pixels_remove:end)=true;


