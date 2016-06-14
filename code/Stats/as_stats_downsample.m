function [stats_downsample, sFields, axonlistcell]=as_stats_downsample(axonlist,matrixsize,PixelSize,resolution, outputstats)
%[stats_downsample, statsname]=as_stats_downsample(axonlist,matrixsize(µm),PixelSize(µm),resolution)
%
% IN:   -axonlist (output structure from AxonSeg, containing axon & myelin
%       info
%       -matrixsize (size x and y of image in axonlist)      
%       -PixelSize (size of one pixel, output of AxonSeg, comes with
%       axonlist)
%       -resolution (um value of downsampled image, i.e. you can take the
%       resolution of your MRI image, can take different resolutions for x
%       and y)
%       -outputstats (true if you want the output stats)
%
% Ex: [stats_downsample, sFields, axonlistcell]=as_stats_downsample(axonlist,size(img),0.8,30);
%
%--------------------------------------------------------------------------

% outputstats is true by default
if ~exist('outputstats','var'), outputstats=1; end

% Calculate nbr of pixels for each sub-region in the downsampled image
dsx=resolution(1)/(PixelSize);
dsy=resolution(end)/(PixelSize);

% Get the x & y coordsfor each sub-region
Xcoords=1:dsx:matrixsize(1);
Ycoords=1:dsy:matrixsize(2);

% Use the centroids of the axons to determine position of axons
Centroids=cat(1,axonlist.Centroid);

% get stats fields we're using (axonArea, axonDiam,...)
sFields=as_stats_fields;

% init. matrix that will contain downsampled values for each stat (3D)
stats_downsample=zeros([length(Xcoords) length(Ycoords) length(sFields)+5]);

% create cell array with same size as downsample image
axonlistcell=cell(length(Xcoords),length(Ycoords));

% for each downsample cell, calculate mean stats from axonlist
for x=1:length(Xcoords)
    for y=1:length(Ycoords)
        
        % identify centroids (axons) that are in the current downsample
        % cell
        inpixel=Centroids(:,1)>Xcoords(x) & Centroids(:,1)<Xcoords(min(x+1,end)) & Centroids(:,2)>Ycoords(y) & Centroids(:,2)<Ycoords(min(y+1,end));
        
        % copy identified centroids in related axonlist cell
        axonlistcell{x,y}=inpixel;
        
        % if outputstats true
        if outputstats
            
            % for each stat field, take the mean of the stat for axons in
            % current downsample cell
            for istat=1:length(sFields)
                stats_downsample(x,y,istat)=mean([axonlist(inpixel).(sFields{istat})]);
            end
            
            % One of the stats = nbr of axons in each downsample cell
            stats_downsample(x,y,end-4)=nnz(inpixel);
            
            % Another stat added = std of axon diameter
            tmp=[axonlist(inpixel).axonEquivDiameter];
            stats_downsample(x,y,end-3)=std(tmp);
            
            % Another stat added = sum(AxonDiam.^3)./sum(AxonDiam.^2)
            stats_downsample(x,y,end-2)=sum(tmp.^3)./sum(tmp.^2);
            
            % If there are axons in downsample cell
            if sum(inpixel)
                
                % 
                cellsize=ceil([Xcoords(min(x+1,end))-Xcoords(x), Ycoords(min(y+1,end))-Ycoords(y)]);
                % Myelin display of cell
                myelinseg=~~as_display_label(as_axonlist_changeorigin(axonlist(inpixel),-[Xcoords(x) Ycoords(y)]),cellsize,'axonEquivDiameter','myelin',0,0);
                % Calculate myelin volume fraction = myelin pixels / total
                % pixels of cell
                MTV=sum(myelinseg(:))/(cellsize(1)*cellsize(2));
                % Another stat added = MTV in each downsample cell
                stats_downsample(x,y,end-1)=MTV;
                % Get axon display of current cell
                axonseg=~~as_display_label(as_axonlist_changeorigin(axonlist(inpixel),-[Xcoords(x) Ycoords(y)]),cellsize,'axonEquivDiameter','axon',0,0);
                % calculate fr = AVF/(1-MVF) and add it as stat
                fr=sum(axonseg(:))/(cellsize(1)*cellsize(2))/(1-MTV);
                stats_downsample(x,y,end)=fr;
            end
        end
    end
end

% specify fields for added stats (not in original axonlist)
sFields{end+1}='Number_axons';
sFields{end+1}='axonEquivDiameter_std';
sFields{end+1}='axonEquivDiameter_axonvolumeCorrected';
sFields{end+1}='MTV';
sFields{end+1}='fr';

% if outputstats true
if outputstats
    % set all existing NAN to 0
    stats_downsample(isnan(stats_downsample))=0;
    
    % create mask
    
    figure
    sc(stats_downsample(:,:,7))
    msgbox({'Use the slider to generate mask' 'Press any key when you are done..'})
    hsl = uicontrol('Style','slider','Min',0,'Max',1000,...
        'SliderStep',[1 1]./50,'Value',100,...
        'Position',[20 20 200 20]);
    set(hsl,'Callback',@(hObject,eventdata) sc(stats_downsample(:,:,7),'r',stats_downsample(:,:,7)>get(hObject,'Value')))
    pause
    
    mask=stats_downsample(:,:,7)>get(hsl,'Value');
    close
    stats_downsample(~repmat(mask,[1 1 size(stats_downsample,3)]))=0;
end


