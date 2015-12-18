

img_BW_test=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
img_BW_test=im2bw(img_BW_test,0);
imshow(img_BW_test);

imwrite(img_BW_test,'axons_other_em_quad.tif');


imagesc(img_BW_test);


%%

img_path_1 = uigetimagefile;
img_BW_control = imread(img_path_1);

%%

img_path_2 = uigetimagefile;
img_BW_test = imread(img_path_2);

img_BW_control=im2bw(img_BW_control);
img_BW_test=im2bw(img_BW_test);

imshow(img_BW_control);
imshow(img_BW_test);

[sensitivity, TP, FP, FN, nbr_test, nbr_control,J]=eval_sensitivity_new(img_BW_test,img_BW_control);





