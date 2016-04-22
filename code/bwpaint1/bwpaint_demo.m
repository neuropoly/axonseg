%load an 3D mri image
load mri;
D=squeeze(D);
bw_D=(D>40);

%usage 1: create a new mask 
figure(1);
rgb3=im3rgb(D);
bwpaint1(rgb3);
 


%usage 2: express binary mask contour on the mri image
figure(2);
rgb3=im3rgb(D,bw_D,'contour');
bwpaint1(rgb3);

%usage 3: express a binary mask as overlay above the mri image
figure(3);
rgb3=im3rgb(D,bw_D,'overlay');
bwpaint1(rgb3);
