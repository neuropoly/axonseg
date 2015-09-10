function as_reg_histo2mri3D(src, ref, isrc)
% as_reg_histo2mri3D(src, ref)

nii_ref=load_nii(ref);
nii_src=load_nii(src);

src_reg=zeros([size(nii_ref.img,1),size(nii_ref.img,2),nii_ref.dims(3),nii_src.dims(4)]);

for iz=1:nii_ref.dims(3)
    [tform{iz},MRIref]=as_reg_histo2mri(nii_src.img(:,:,isrc),nii_ref.img(:,:,iz));
end
save transform tform

% apply
for iz=1:nii_ref.dims(3)
    for istat=1:nii_src.dims(4)
        src_reg(:,:,iz,istat)=imwarp(nii_src.img(:,:,istat),tform{iz},'outputview',MRIref);
    end
end
save_nii_v2(src_reg,[sct_tool_remove_extension(src,1) '_reg'],ref);