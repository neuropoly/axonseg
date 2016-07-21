

function [mean_gap_axon]=gap_axons(axonlist,PixelSize,nbr_of_neighbours)
% [mean_gap_axon]=gap_axons(axonlist,PixelSize,2);
tic
% for each axon in axonlist

mean_gap_axon=zeros(size(cat(1,axonlist.Centroid),1),1);

for i=1:size(cat(1,axonlist.Centroid),1)

% tic

% identify origin of current axon
origin_centroid=axonlist(i).Centroid;

dist_vector=zeros(size(cat(1,axonlist.Centroid),1),1);

% for each axon in the axonlist
    for j=1:size(cat(1,axonlist.Centroid),1)
     
        % make X vector with origin centroid and each axon centroid
        X=[origin_centroid;axonlist(j).Centroid];
        % create a distance vector with distance from each other axon
        dist_vector(j,1)=j;
        dist_vector(j,2)=pdist(X,'euclidean')*PixelSize;
    
    end   
% sort distances from close to far    
Sorted_distances=sortrows(dist_vector,2);    
% only keep the N neighbours specified in input (dont count the first one = distance between axon & itself)    
neighbour_axons=Sorted_distances(1:nbr_of_neighbours+1,:);

gap_axon=zeros(nbr_of_neighbours,1);

for k=2:size(neighbour_axons,1)

gap_axon(k-1,1)=neighbour_axons(k,2)-0.5*(axonlist(i).axonEquivDiameter)-axonlist(i).myelinThickness...
    -0.5*(axonlist(neighbour_axons(k)).axonEquivDiameter) - axonlist(neighbour_axons(k)).myelinThickness;

gap_axon(gap_axon<0)=0;

end

mean_gap_axon(i,1)=mean(gap_axon);
% toc


hist(mean_gap_axon,50); title([num2str(nbr_of_neighbours),' neighbours, ' 'Mean=', num2str(mean(mean_gap_axon)), ' ,std= ', num2str(std(mean_gap_axon)), ' ,median= ', num2str(median(mean_gap_axon)), ]);

end

toc





