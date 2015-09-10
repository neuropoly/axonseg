function as_reg_histo2mri3D(src, ref, isrc, tform)
% as_reg_histo2mri3D(src, ref)
% EXAMPLE #1: >> as_reg_histo2mri3D('axonEquivDiameter.nii','MRI.nii.gz')
% EXAMPLE #2: >> load('transform.mat')
%             >> as_reg_histo2mri3D('axonEquivDiameter.nii','MRI.nii.gz',[],tform)
%
% See also as_stats_downsample_2nii

if ~exist('isrc','var'), isrc=1; end

nii_ref=load_nii(ref);
nii_src=load_nii(src);

src_reg=zeros([size(nii_ref.img,1),size(nii_ref.img,2),nii_ref.dims(3),nii_src.dims(4)]);

if ~exist('tform','var')
    for iz=1:nii_ref.dims(3)
        tform{iz}=as_reg_histo2mri(nii_src.img(:,:,isrc),nii_ref.img(:,:,iz));
    end
    save transform tform
end

% apply
MRIref=imref2d(nii_ref.dims(1:2));
for iz=1:nii_ref.dims(3)
    for istat=1:nii_src.dims(4)
        src_reg(:,:,iz,istat)=imwarp(nii_src.img(:,:,istat),tform{iz},'outputview',MRIref);
    end
end
save_nii_v2(src_reg,[sct_tool_remove_extension(src,1) '_reg'],ref);