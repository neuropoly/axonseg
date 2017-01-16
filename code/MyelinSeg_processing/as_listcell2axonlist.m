function [ axonlist ] = as_listcell2axonlist( listcell, blocksize, overlap)
% as_myelinseg_blocks_bw2list( myelin_seg_results , PixelSize, blocksize, overlap)

% change origin of each block
for nb=1:length(listcell(:))
    [X,Y]=ind2sub(size(listcell),nb);
    rm=find(cellfun(@isempty,{listcell{nb}.Centroid}));
    if ~isempty(rm), listcell{nb}(rm)=[]; end
    listcell_seg{nb}.seg=as_axonlist_changeorigin(listcell{nb},[(X-1)*(blocksize-overlap) (Y-1)*(blocksize-overlap)]);
end
% list of cell 2 one list only
axonlist(length(listcell(:)))=listcell_seg{end};
[axonlist.seg]=deal(listcell_seg{:});
axonlist=cat(2,axonlist.seg); axonlist=cat(2,axonlist.seg); axonlist=axonlist(logical([axonlist.myelinAera])); % weird but works (fast).. keep everything

% remove axons that have been segmented twice
centroids=cat(1,axonlist.Centroid);
if ~isempty(centroids)
    [~,~,axonlistcell]=as_stats_downsample(axonlist,[max(centroids(:,1)) max(centroids(:,2))],1,1000, 0);
    rm=false(length(axonlist),1);
    for x=1:size(axonlistcell,1)
        for y=1:size(axonlistcell,2)
            rm(axonlistcell{x,y})=as_axonlist_distance_closerthandiameter(axonlist(axonlistcell{x,y}),0.5);
        end
    end
    axonlist(rm)=[]; % if axons have been segmented twice.. careful
end


end

