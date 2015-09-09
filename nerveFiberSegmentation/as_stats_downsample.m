function [stats_downsample, sFields, axonlistcell]=as_stats_downsample(axonlist,matrixsize,PixelSize,resolution, outputstats)
%[stats_downsample, statsname]=as_stats_downsample(axonlist,matrixsize(µm),PixelSize(µm),resolution)
if ~exist('outputstats','var'), outputstats=1; end
dsx=resolution(1)/(PixelSize);
dsy=resolution(end)/(PixelSize);

Xcoords=1:dsx:matrixsize(1);
Ycoords=1:dsy:matrixsize(2);

Centroids=cat(1,axonlist.Centroid);

sFields=as_stats_fields;

stats_downsample=zeros([length(Xcoords) length(Ycoords) length(sFields)+2]);
axonlistcell=cell(length(Xcoords),length(Ycoords));
for x=1:length(Xcoords)
    for y=1:length(Ycoords)
        inpixel=Centroids(:,1)>Xcoords(x) & Centroids(:,1)<Xcoords(min(x+1,end)) & Centroids(:,2)>Ycoords(y) & Centroids(:,2)<Ycoords(min(y+1,end));
        
        axonlistcell{x,y}=inpixel;
        if outputstats
            for istat=1:length(sFields)
                stats_downsample(x,y,istat)=mean([axonlist(inpixel).(sFields{istat})]);
            end
            stats_downsample(x,y,end-1)=nnz(inpixel); % number of axons in each pixel;
            tmp=[axonlist(inpixel).axonEquivDiameter];
            stats_downsample(x,y,end)=mean(tmp(tmp>3)); % mean axon diameter (>3µm);
        end
    end
end
sFields{end+1}='Number_axons';
sFields{end+1}='MeanDiameterOver3mu';


        