
a=uigetimagefile;
a=imread(a);

img=a;
mask=prediction;
mask=double(mask);
mask=im2bw(mask);

figure;
sc(sc(mask,'y',mask)+sc(img));



%post-processing

% fill holes


% 


