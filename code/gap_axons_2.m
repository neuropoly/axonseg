

function [mean_gap_axon]=gap_axons_2(axonlist,PixelSize,nbr_of_neighbours,img)
% [mean_gap_axon]=gap_axons(axonlist,PixelSize,2);

for i=1:size(cat(1,axonlist.Centroid),1)

tic    
origin_centroid=axonlist(i).Centroid;

% here add smaller neighbourhood (10x current axon diameter circle)

mask=false(size(img));

if round(origin_centroid(1))-100>0 && round(origin_centroid(1))+100<size(img,1) && round(origin_centroid(2))-100>0 && round(origin_centroid(2))+100<size(img,2)
    mask(round(origin_centroid(1))-100:round(origin_centroid(1))+100,round(origin_centroid(2))-100:round(origin_centroid(2))+100)=true;
else
    mask(round(origin_centroid(1))-10:round(origin_centroid(1))+10,round(origin_centroid(2))-10:round(origin_centroid(2))+10)=true;
end

[Index, ~]=as_stats_Roi(axonlist, [], ~mask);
axonlist_i=axonlist(Index);

%----------------------------------------------------------------

for j=1:size(cat(1,axonlist_i.Centroid),1)
     
X=[origin_centroid;axonlist(j).Centroid];
dist_vector(j,1)=j;
dist_vector(j,2)=pdist(X,'euclidean');
dist_vector(j,2)=dist_vector(j,2)*PixelSize;

end   
    
    

Sorted_distances=sortrows(dist_vector,2);    
    
neighbour_axons=Sorted_distances(1:nbr_of_neighbours+1,:);


for k=2:size(neighbour_axons,1)

% tmp=axonlist(neighbour_axons(k)).Centroid;
gap_axon(k-1,1)=neighbour_axons(k,2)-0.5*(axonlist(i).axonEquivDiameter)-axonlist(i).myelinThickness...
    -0.5*(axonlist(neighbour_axons(k)).axonEquivDiameter) - axonlist(neighbour_axons(k)).myelinThickness;

gap_axon(gap_axon<0)=0;

end

mean_gap_axon(i,1)=mean(gap_axon);
toc


hist(mean_gap_axon,50); title([num2str(nbr_of_neighbours),' neighbours, ' 'Mean=', num2str(mean(mean_gap_axon)), ' ,std= ', num2str(std(mean_gap_axon)), ' ,median= ', num2str(median(mean_gap_axon)), ]);
end

