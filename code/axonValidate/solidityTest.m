function im_out=solidityTest(im_in,sol)
axprop= regionprops(im_in, 'Solidity');
solidity= [axprop.Solidity]';
[a,b]=bwlabel(im_in);
p=find(solidity<sol);
a(ismember(a,p)==1)=0;
im_out=a;
im_out=im_out~=0;