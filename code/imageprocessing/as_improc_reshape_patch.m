function seg_out=as_improc_reshape_patch(im_struct)

data=full(im_struct.seg);
seg_out=reshape(data,[size(im_struct.img) length(data)/(size(im_struct.img,1)*size(im_struct.img,2))]);
end