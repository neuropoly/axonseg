function im_out=step1(im_in,state)

im1 = axonInitialSegmentation(im_in, state.initSeg);
im1=imfill(im1,'holes'); %imshow(initialBW)
im2 = axonInitialSegmentation(im_in, state.diffMaxMin);
im3=im_in<prctile(im_in(:),100*state.threshold);
im3=bwmorph(im3,'fill'); im3=bwmorph(im3,'close'); im3=bwmorph(im3,'hbreak'); im3 = bwareaopen(im3,5); %imshow(im3)

im_out=im1 | im2 | im3;
