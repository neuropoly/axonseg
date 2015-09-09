function axonseg=as_myelinseg_to_axonseg(seg_3d)
% axonseg=as_myelinseg_to_axonseg(myelinseg)
% myelinseg can be 3d
seg_2d=reshape(seg_3d,[size(seg_3d,1) size(seg_3d,2)*size(seg_3d,3)]);
axonseg=(max(reshape(imfill(seg_2d,'holes') & ~seg_2d,size(seg_3d)),[],3));