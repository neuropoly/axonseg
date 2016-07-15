
function [mean_gap_axon]=gap_axons_3(axonlist,PixelSize,nbr_of_neighbours)
% [mean_gap_axon]=gap_axons(axonlist,PixelSize,7);

Centroid=cat(1,axonlist.Centroid);

Centroidx=Centroid(:,1);
Centroidy=Centroid(:,2);


for i=1:size(cat(1,axonlist.Centroid),1)

tic    
origin_centroid=axonlist(i).Centroid;

% here add smaller neighbourhood (10x current axon diameter circle)

Px=[round(origin_centroid(2))-100,round(origin_centroid(2))+100];
Py=[round(origin_centroid(1))-100,round(origin_centroid(1))+100];

in=inpolygon(Centroidx,Centroidy,Py,Px);
Index= in==1;
axonlist_i=axonlist(Index);

for j=1:size(cat(1,axonlist_i.Centroid),1)
     
X=[origin_centroid;axonlist_i(j).Centroid];
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
