function im=step2_full(AxSeg,segParam)

im=AxSeg;

minSize=segParam.minSize;
Circularity=segParam.Circularity;
Solidity=segParam.Solidity;
PerimeterRatio=segParam.PerimeterRatio;
Minor=segParam.MinorAxis;
Major=segParam.MajorAxis;

im = sizeTest(im,minSize);
im = axonValidateCircularity(im, Circularity);
im = solidityTest(im,Solidity);

im = axonValidatePerimeterRatio(im, PerimeterRatio);
im = axonValidateMinorAxis(im, Minor);
im = axonValidateMajorAxis(im, Major);

%im =as_bwobjectfun(@ (x) bwconvhull(x, 'objects'),im);
