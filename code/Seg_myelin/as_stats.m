function AXstat =as_stats(bwseg,PixelSize,myelin,metric)
% statis=as_stats(bwseg,pixelSize,myelin)
if ~exist('myelin','var'), myelin=1; end


bwseg=reshape2D(~~bwseg,1);
Npix = length(bwseg(:));
cc = bwconncomp(bwseg, 8);
if myelin
    myelinseg = bwseg;
    bwseg = logical(imfill(myelinseg,'holes') - myelinseg);
end

stats                   =   regionprops(bwseg,{'Eccentricity', 'EquivDiameter','Area'});

% convert units pixel to meters
EquivDiameter = [stats.EquivDiameter]*PixelSize;

AXstat.EquivDiameter01   =   sum(EquivDiameter>0 & EquivDiameter<1);
AXstat.EquivDiameter14   =   sum(EquivDiameter>1 & EquivDiameter<4);
AXstat.EquivDiameter48   =   sum(EquivDiameter>4 & EquivDiameter<8);
AXstat.EquivDiameter812  =   sum(EquivDiameter>8 & EquivDiameter<12);
AXstat.EquivDiameter1217  =   sum(EquivDiameter>12 & EquivDiameter<17);
AXstat.EquivDiameter     =   mean(EquivDiameter);
AXstat.EquivDiameter_W   =   sum(EquivDiameter.^3)/sum(EquivDiameter.^2);
AXstat.EquivDiameter_std =   std(EquivDiameter);
AXstat.Eccentricity      =   max([stats.Eccentricity]);
AXstat.AVF               =   sum([stats.Area])/Npix;
AXstat.Naxons            =   length(stats);

if myelin
    stats                   =   regionprops(myelinseg,{'EquivDiameter'});
    myelinEquivDiameter = [stats.EquivDiameter]*PixelSize;
    AXstat.MVF = sum(myelinseg)/Npix;
    AXstat.myelinEquivDiameter = median(myelinEquivDiameter);
    try
    AXstat.gRatio = single(EquivDiameter ./ myelinEquivDiameter);
    catch
        warning('Some myelin have no holes')
    end
end

if exist('metric','var')
    AXstat = AXstat.(metric);
end
