function segment=as_myelinseg_bw2list(seg,Pixelsize)
% list=as_myelinseg_bw2list(seg,Pixelsize)
disp(size(seg,3))
emptyseg = find(~sum(sum(seg,1),2)); if ~isempty(emptyseg), seg(:,:,emptyseg)=[]; end
stats=as_stats(seg,Pixelsize);
if isempty(seg)
    seg=zeros(size(seg,1),size(seg,2));
end
sfields=as_stats_fields;

for iaxon=size(seg,3):-1:1
    [segment(iaxon).data(:,1), segment(iaxon).data(:,2)]=find(seg(:,:,iaxon));
    segment(iaxon).myelinAera=size(segment(iaxon).data,1);
    segment(iaxon).axonID=repmat(iaxon,[segment(iaxon).myelinAera,1]);
    tmp=regionprops(seg(:,:,iaxon),'Centroid');
    if isempty(tmp), segment(iaxon).Centroid=[];
    else
            segment(iaxon).Centroid=tmp(1).Centroid([2 1]);
    end
    for istat=1:length(sfields)
        tmp=stats.(sfields{istat});
        segment(iaxon).(sfields{istat})=tmp(iaxon);
    end
end
    