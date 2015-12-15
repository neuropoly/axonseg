function im=step2_full(AxSeg,segParam)

im=AxSeg;
[Stats_struct,cc]=axon_stats_step2(AxSeg);

% Minimal size
metric=Stats_struct.EquivDiameter;
p=find(metric<segParam.minSize);
im(ismember(cc,p)==1)=0;

% % Circularity
% metric=Stats_struct.Circularity;
% p=find(metric<segParam.Circularity);
% im(ismember(cc,p)==1)=0;

% Solidity
metric=Stats_struct.Solidity;
p=find(metric<segParam.Solidity);
im(ismember(cc,p)==1)=0;

% Ellipticity
metric=Stats_struct.MinorMajorRatio;
p=find(metric<segParam.Ellipticity);
im(ismember(cc,p)==1)=0;

% % Area to Area convex hull
% metric=Stats_struct.AAchRatio;
% p=find(metric<segParam.AreaRatio);
% im(ismember(cc,p)==1)=0;


%im =as_bwobjectfun(@ (x) bwconvhull(x, 'objects'),im);
