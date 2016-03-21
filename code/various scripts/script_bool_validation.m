bw_control=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
imshow(im2bw(bw_control,0));

bw_test1=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
imshow(im2bw(bw_test1,0));

bw_test2=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
imshow(im2bw(bw_test2,0));

a=corr2(bw_control,bw_test1);
b=corr2(bw_control,bw_test2);

imshow(im2bw(bw_test1-bw_control),0);