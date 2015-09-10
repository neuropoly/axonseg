function im_out=Deconv(im_in,param)
if param<2
    im_out=im_in;
else
im_out=deconvblind(im_in,ones(param,param));
end
