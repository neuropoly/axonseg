function [tform,MRIref,moving_out,fixed_out]=as_reg_histo2mri(histo,MRI)
% [tform,MRIref]=as_reg_img2nii(histo,MRI)
% Then: img_reg=imwarp(img,tform,'outputview',MRIref);

dbstop if error
% dsx=nii.hdr.dime.pixdim(2)*10/(PixelSize*1e-3);
% dsy=nii.hdr.dime.pixdim(3)*10/(PixelSize*1e-3);
% img2=imgaussian(single(img(1:floor(dsx):end,1:floor(dsy):end)),0.5,2);
% %save_nii_v2(make_nii(repmat(img2,[1 1 nii.dims(3)]),[nii.hdr.dime.pixdim(2:4)]),'histo');

[moving_out,fixed_out] = cpselect(sc(histo),sc(MRI),'Wait',true);
moving_out = cpcorr(moving_out,fixed_out,rgb2gray(sc(histo,'jet')),rgb2gray(sc(MRI,[3.5 6.3],'jet')));
tform = fitgeotrans(moving_out,fixed_out,'Affine');
MRIref=imref2d(size(MRI));
histo(isnan(histo))=0;
img3=imwarp(histo,tform,'outputview',MRIref);

figure
sc(img3)
figure
sc(MRI)
%for i=0:0.001:3, sc(sc(img3,'cool')+i*sc(MRI,'hot')); drawnow; end