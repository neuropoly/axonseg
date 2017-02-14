
src='/Users/alzaia/ariane/test/multilabel_histo_seg_crop.nii.gz';

nii_src=load_nii(src);







save_nii_v2(src_reg,[sct_tool_remove_extension(src,1) '_reg'],ref);