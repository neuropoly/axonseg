function im=step2(handles)

im=handles.data.Step2_seg;

% Minimal size
metric=handles.stats_step2.EquivDiameter;
p=find(metric<get(handles.minSize,'Value'));
im(ismember(handles.stats_cc,p)==1)=0;

% % Circularity
% metric=handles.stats_step2.Circularity;
% p=find(metric<get(handles.Circularity,'Value'));
% im(ismember(handles.stats_cc,p)==1)=0;

% Solidity
metric=handles.stats_step2.Solidity;
p=find(metric<get(handles.Solidity,'Value'));
im(ismember(handles.stats_cc,p)==1)=0;

% Ellipticity
metric=handles.stats_step2.MinorMajorRatio;
p=find(metric<get(handles.Ellipticity,'Value'));
im(ismember(handles.stats_cc,p)==1)=0;

% % Perimeter to Perimeter convex hull
% metric=handles.stats_step2.PPchRatio;
% p=find(metric<get(handles.AreaRatio,'Value'));
% im(ismember(handles.stats_cc,p)==1)=0;


% im = sizeTest(im,get(handles.minSize,'Value'));
% im = axonValidateCircularity(im, Circularity);
% im = solidityTest(im,Solidity);
% 
% im = axonValidatePerimeterRatio(im, PerimeterRatio);
% im = axonValidateMinorAxis(im, Minor);
% im = axonValidateMajorAxis(im, Major);

%im =as_bwobjectfun(@ (x) bwconvhull(x, 'objects'),im);
