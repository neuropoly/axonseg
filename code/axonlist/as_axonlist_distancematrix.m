function Mdist=as_axonlist_distancematrix(Centroids)
% Mdist=as_axonlist_distancematrix(Centroids)
% EXAMPLE: Mdist=as_axonlist_distancematrix(cat(1,axonlist.Centroid))
Mdist=squareform(pdist(Centroids));
Mdist(diag(true(1,size(Centroids,1))))=nan;
