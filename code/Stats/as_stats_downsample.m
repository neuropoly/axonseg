function [stats_downsample, sFields, axonlistcell]=as_stats_downsample(axonlist,matrixsize,PixelSize,resolution, outputstats)
%[stats_downsample, statsname]=as_stats_downsample(axonlist,matrixsize(µm),PixelSize(µm),resolution)
if ~exist('outputstats','var'), outputstats=1; end
dsx=resolution(1)/(PixelSize);
dsy=resolution(end)/(PixelSize);

Xcoords=1:dsx:matrixsize(1);
Ycoords=1:dsy:matrixsize(2);

Centroids=cat(1,axonlist.Centroid);

sFields=as_stats_fields;

stats_downsample=zeros([length(Xcoords) length(Ycoords) length(sFields)+5]);
axonlistcell=cell(length(Xcoords),length(Ycoords));
for x=1:length(Xcoords)
    for y=1:length(Ycoords)
        inpixel=Centroids(:,1)>Xcoords(x) & Centroids(:,1)<Xcoords(min(x+1,end)) & Centroids(:,2)>Ycoords(y) & Centroids(:,2)<Ycoords(min(y+1,end));
        
        axonlistcell{x,y}=inpixel;
        if outputstats
            for istat=1:length(sFields)
                stats_downsample(x,y,istat)=mean([axonlist(inpixel).(sFields{istat})]);
            end
            stats_downsample(x,y,end-4)=nnz(inpixel); % number of axons in each pixel;
            tmp=[axonlist(inpixel).axonEquivDiameter];
            stats_downsample(x,y,end-3)=std(tmp);
            stats_downsample(x,y,end-2)=sum(tmp.^3)./sum(tmp.^2);
            
            if sum(inpixel)
                cellsize=ceil([Xcoords(min(x+1,end))-Xcoords(x), Ycoords(min(y+1,end))-Ycoords(y)]);
                myelinseg=~~as_display_label(as_axonlist_changeorigin(axonlist(inpixel),-[Xcoords(x) Ycoords(y)]),cellsize,'axonEquivDiameter','myelin',0,0);
                MTV=sum(myelinseg(:))/(cellsize(1)*cellsize(2));
                stats_downsample(x,y,end-1)=MTV;
                axonseg=~~as_display_label(as_axonlist_changeorigin(axonlist(inpixel),-[Xcoords(x) Ycoords(y)]),cellsize,'axonEquivDiameter','axon',0,0);
                fr=sum(axonseg(:))/(cellsize(1)*cellsize(2))/(1-MTV);
                stats_downsample(x,y,end)=fr;
            end
        end
    end
end
sFields{end+1}='Number_axons';
sFields{end+1}='axonEquivDiameter_std';
sFields{end+1}='axonEquivDiameter_axonvolumeCorrected';
sFields{end+1}='MTV';
sFields{end+1}='fr';

if outputstats
    stats_downsample(isnan(stats_downsample))=0;
    
    % create mask
    figure
    sc(stats_downsample(:,:,7))
    msgbox({'Use the slider to generate mask' 'Press any key when are done..'})
    hsl = uicontrol('Style','slider','Min',0,'Max',1000,...
        'SliderStep',[1 1]./50,'Value',100,...
        'Position',[20 20 200 20]);
    set(hsl,'Callback',@(hObject,eventdata) sc(stats_downsample(:,:,7),'r',stats_downsample(:,:,7)>get(hObject,'Value')))
    pause
    
    mask=stats_downsample(:,:,7)>get(hsl,'Value');
    close
    stats_downsample(~repmat(mask,[1 1 size(stats_downsample,3)]))=0;
end


