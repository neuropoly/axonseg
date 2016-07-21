
function [mean_gap_axon]=gap_axons_3(axonlist,PixelSize,img,nbr_of_neighbours,screening_factor)
% [mean_gap_axon]=gap_axons_3(axonlist,PixelSize,img,2,300);

% init. vector that is going to store mean gap for each axon
mean_gap_axon=zeros(size(cat(1,axonlist.Centroid),1),1);

% extract centroids from 
Centroid=cat(1,axonlist.Centroid);

Centroidx=Centroid(:,1);
Centroidy=Centroid(:,2);

mean_axon_diam=mean(cat(1,axonlist.axonEquivDiameter));

for i=1:size(cat(1,axonlist.Centroid),1)

tic    
origin_centroid=axonlist(i).Centroid;

% here add smaller neighbourhood (10x current axon diameter circle)

a=round(origin_centroid(2)-mean_axon_diam*screening_factor);
b=round(origin_centroid(2)+mean_axon_diam*screening_factor);
c=round(origin_centroid(1)-mean_axon_diam*screening_factor);
d=round(origin_centroid(1)+mean_axon_diam*screening_factor);

if a<=0, a=1; end;
if b>size(img,2), b=size(img,2); end;
if c<=0, c=1; end;
if d>size(img,1), d=size(img,1); end;

Px=[a,a,b,b];
Py=[c,d,c,d];

imshow(img);
hold on;
scatter(Px,Py,'*');
hold off;

Index=inpolygon(Centroidx,Centroidy,Py,Px);
axonlist_i=axonlist(Index);

dist_vector=zeros(size(cat(1,axonlist_i.Centroid),1),1);

for j=1:size(cat(1,axonlist_i.Centroid),1)
     
X=[origin_centroid;axonlist_i(j).Centroid];

dist_vector(j,1)=j;
dist_vector(j,2)=pdist(X,'euclidean')*PixelSize;

end   
    
Sorted_distances=sortrows(dist_vector,2);    
    



neighbour_axons=Sorted_distances(1:nbr_of_neighbours+1,:);





gap_axon=zeros(nbr_of_neighbours,1);

for k=2:size(neighbour_axons,1)

gap_axon(k-1,1)=neighbour_axons(k,2)-0.5*(axonlist_i(i).axonEquivDiameter)-axonlist_i(i).myelinThickness...
    -0.5*(axonlist_i(neighbour_axons(k)).axonEquivDiameter) - axonlist_i(neighbour_axons(k)).myelinThickness;

gap_axon(gap_axon<0)=0;

end

mean_gap_axon(i,1)=mean(gap_axon);
toc


hist(mean_gap_axon,50); 
title([num2str(nbr_of_neighbours),' neighbours, ' 'Mean=', num2str(mean(mean_gap_axon)), ' ,std= ',...
    num2str(std(mean_gap_axon)), ' ,median= ', num2str(median(mean_gap_axon)), ]);
end






