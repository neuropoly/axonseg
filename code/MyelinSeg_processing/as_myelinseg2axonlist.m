function axonlist=as_myelinseg2axonlist(seg,Pixelsize, myelin)
% list=as_myelinseg_bw2list(seg,Pixelsize)

if ~exist('myelin','var'), myelin=1; end

disp(size(seg,3))
emptyseg = find(~sum(sum(seg,1),2)); if ~isempty(emptyseg), seg(:,:,emptyseg)=[]; end
if isempty(seg)
    seg=zeros(size(seg,1),size(seg,2));
end


if myelin
    stats=as_stats(seg,Pixelsize);
    sfields=as_stats_fields;
    
    for iaxon=size(seg,3):-1:1
        [axonlist(iaxon).data(:,1), axonlist(iaxon).data(:,2)]=find(seg(:,:,iaxon));
        axonlist(iaxon).myelinAera=size(axonlist(iaxon).data,1);
        axonlist(iaxon).axonID=repmat(iaxon,[axonlist(iaxon).myelinAera,1]);
        tmp=regionprops(seg(:,:,iaxon),'Centroid');
        if isempty(tmp), axonlist(iaxon).Centroid=[];
        else
            axonlist(iaxon).Centroid=tmp(1).Centroid([2 1]);
        end
        for istat=1:length(sfields)
            tmp=stats.(sfields{istat});
            axonlist(iaxon).(sfields{istat})=tmp(iaxon);
        end
    end
else
   
    [bw, num_axons]=bwlabel(seg);
    axonlist=regionprops(seg,'Centroid');
    
    prop =regionprops(bw, {'Area', 'EquivDiameter'});
    
    for iaxon=1:num_axons
        axonlist(iaxon).axonEquivDiameter = (prop(iaxon).EquivDiameter)*Pixelsize;
        axonlist(iaxon).axonArea = prop(iaxon).Area;
        
        [axonlist(iaxon).data(:,1), axonlist(iaxon).data(:,2)] = find(bwmorph(bw==iaxon,'remove'));
        axonlist(iaxon).myelinAera = length(axonlist(iaxon).data(:,1));
    end
end