function im=step2(handles)

im=handles.data.Step2_seg;
minSize=get(handles.minSize,'Value');
Circularity=get(handles.Circularity,'Value');
Solidity=get(handles.Solidity,'Value');
PerimeterRatio=get(handles.PerimeterRatio,'Value');
Minor=get(handles.MinorAxis,'Value');
Major=get(handles.MajorAxis,'Value');

im = sizeTest(im,minSize);
im = axonValidateCircularity(im, Circularity);
im = solidityTest(im,Solidity);

im = axonValidatePerimeterRatio(im, PerimeterRatio);
im = axonValidateMinorAxis(im, Minor);
im = axonValidateMajorAxis(im, Major);

%im =as_bwobjectfun(@ (x) bwconvhull(x, 'objects'),im);
