function im=step2(im,minSize, Circularity, Solidity, EllipRatio, Minor, Major)
im = sizeTest(im,minSize);
im = axonValidateCircularity(im, Circularity);
im = solidityTest(im,Solidity);

im = axonValidateEllipsity(im, EllipRatio);
im = axonValidateMinorAxis(im, Minor);
im = axonValidateMajorAxis(im, Major);

%im =as_bwobjectfun(@ (x) bwconvhull(x, 'objects'),im);
