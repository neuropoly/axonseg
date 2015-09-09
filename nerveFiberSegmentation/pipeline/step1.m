function im_out=step1(im_in,state)

im1 = axonInitialSegmentation(im_in, state.initSeg);
im2 = axonInitialSegmentation(im_in, state.diffMaxMin);
im_out=im1 | im2;
