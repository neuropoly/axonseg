function im=step2(im,state)
im = sizeTest(im,state.minSize);
im = axonValidateCircularity(im, state.Circularity);
im = solidityTest(im,state.Solidity);
%im =as_bwobjectfun(@ (x) bwconvhull(x, 'objects'),im);
