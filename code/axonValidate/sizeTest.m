function im_out=sizeTest(im_in,sizeM)
axprop= regionprops(im_in, 'EquivDiameter');
eqDiam= [axprop.EquivDiameter]';
[a,b]=bwlabel(im_in);
p=find(eqDiam<sizeM);
a(ismember(a,p)==1)=0;
im_out=a;
im_out=im_out~=0;
