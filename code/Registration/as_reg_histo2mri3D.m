function as_reg_histo2mri3D(src, ref, iT, tform)
% as_reg_histo2mri3D(src, ref)
% EXAMPLE #1: >> as_reg_histo2mri3D('axonEquivDiameter.nii','MRI.nii.gz')
% EXAMPLE #2: >> load('transform.mat')
%             >> as_reg_histo2mri3D('axonEquivDiameter.nii','MRI.nii.gz',[],tform)
%
% See also as_stats_downsample_2nii

if ~exist('iT','var'), iT=1; end

nii_ref=load_nii(ref);
nii_src=load_nii(src);

src_reg=zeros([size(nii_ref.img,1),size(nii_ref.img,2)]);

if ~exist('tform','var')
    for iz=1:size(nii_ref.img,3)
        tform{iz}=as_reg_histo2mri(nii_src.img(:,:,min(iz,end),iT),nii_ref.img(:,:,iz));
    end
    save transform tform
end

% apply
MRIref=imref2d(size(src_reg));
for iz=1:size(nii_ref.img,3)
    for istat=1:size(nii_src.img,4)
        nii_src.img(:,:,min(iz,end),istat)=fillnans(nii_src.img(:,:,min(iz,end),istat));
        src_reg(:,:,iz,istat)=imwarp(nii_src.img(:,:,min(iz,end),istat),tform{iz},'outputview',MRIref);
    end
end
save_nii_v2(src_reg,[sct_tool_remove_extension(src,1) '_reg'],ref);