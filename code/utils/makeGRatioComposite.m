function myelinGRatio = makeGRatioComposite(input, myelinBW, filename)

if nargin == 1
    im = input.im.processed;
    myelinBW = input.results.myelinBW;
    filename = input.imInfo.Filename;
else
    im = input;
end

if ~isempty(strfind(filename, '-masked'))
    im = imread(strrep(filename, '-masked', ''));
end

cc = bwconncomp(myelinBW, 4);
prop =regionprops(cc, {'Area', 'FilledArea'});

myelinArea = [prop.Area]';
axonArea = [prop.FilledArea]'-[prop.Area]';

myelinArea(axonArea == 0, :) = 0;

myelinEquivDiameter = sqrt(4*(myelinArea + axonArea)/pi);
axonEquivDiameter = sqrt(4*axonArea/pi);
gRatio = axonEquivDiameter ./ myelinEquivDiameter;

myelinGRatio = zeros(size(im));
for i=1:cc.NumObjects
    myelinGRatio(cc.PixelIdxList{i}) = gRatio(i);    
end

imwrite(myelinGRatio, strrep(filename , '.tif', '-morpho-GRatio.tif'))

myelinGRatioComposite = sc(im)*0.6 + sc(myelinGRatio, [0, 1], hot)*0.5;
close gcf
imwrite(myelinGRatioComposite, strrep(filename , '.tif', '-morpho-GRatioComposite.png'))