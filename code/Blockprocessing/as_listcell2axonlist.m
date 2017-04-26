function [ axonlist ] = as_listcell2axonlist( axonlistcell, blocksize, overlap, PixelSize)
% as_listcell2axonlist( axonlistcell, blocksize, overlap, PixelSize)
% as_listcell2axonlist( axonlistcell, neworiginmatrix, [], PixelSize)


% change origin of each block
for nb=1:length(axonlistcell(:))
    [X,Y]=ind2sub(size(axonlistcell),nb);
    rm=find(cellfun(@isempty,{axonlistcell{nb}.Centroid}));
    if ~isempty(rm), axonlistcell{nb}(rm)=[]; end
    if max(size(blocksize))==1 % blocksize
        neworigin = [(X-1)*(blocksize-overlap) (Y-1)*(blocksize-overlap)];
    else
        neworigin = blocksize(nb,:); % neworiginmatrix
    end
    
    listcell_seg{nb}.seg=as_axonlist_changeorigin(axonlistcell{nb},neworigin);
end
% remove empty 
rm = ~cellfun(@length,axonlistcell(:));
if min(rm) % no axons in any block
    axonlist = axonlistcell{1}; return
else
    listcell_seg(rm)=[];
end

% list of cell 2 one list only
axonlist(length(listcell_seg))=listcell_seg{end};
[axonlist.seg]=deal(listcell_seg{:});
axonlist=cat(2,axonlist.seg); axonlist=cat(2,axonlist.seg); axonlist=axonlist(logical([axonlist.myelinAera])); % weird but works (fast).. keep everything

% remove axons that have been segmented twice
centroids=cat(1,axonlist.Centroid);
if ~isempty(centroids)
    [~,~,axonlistcell]=as_stats_downsample(axonlist,[max(centroids(:,1)) max(centroids(:,2))],1,1000, 0);
    rm=false(length(axonlist),1);
    for x=1:size(axonlistcell,1)
        for y=1:size(axonlistcell,2)
            rm(axonlistcell{x,y})=as_axonlist_distance_closerthandiameter(axonlist(axonlistcell{x,y}),0.5,PixelSize);
        end
    end
    axonlist(rm)=[]; % if axons have been segmented twice.. careful
end


end

