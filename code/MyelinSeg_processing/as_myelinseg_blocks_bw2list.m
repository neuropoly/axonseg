function [ axonlist ] = as_myelinseg_blocks_bw2list( myelin_seg_results , PixelSize, blocksize, overlap)
% as_myelinseg_blocks_bw2list( myelin_seg_results , PixelSize, blocksize, overlap)

%% Extract metrics from segmentation:
listcell=as_blockwise_fun(@(x) as_myelinseg2axonlist(x,PixelSize),myelin_seg_results,0,0);

%% Post processing
% change origin of each block
for nb=1:length(listcell(:))
    [X,Y]=ind2sub(size(listcell),nb);
    rm=find(cellfun(@isempty,{listcell{nb}.seg.Centroid}));
    if ~isempty(rm), listcell{nb}.seg(rm)=[]; end
    listcell{nb}.seg=as_axonlist_changeorigin(listcell{nb}.seg,[(X-1)*(blocksize-overlap) (Y-1)*(blocksize-overlap)]);
end
% list of cell 2 one list only
axonlist(length(listcell(:)))=listcell{end};
[axonlist.seg]=deal(listcell{:});
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

