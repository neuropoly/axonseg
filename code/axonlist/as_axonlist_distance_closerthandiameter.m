function [torm,Mtooclose]=as_axonlist_distance_closerthandiameter(axonlist,criteria)
% distance matrix
Mdist=as_axonlist_distancematrix(cat(1,axonlist.Centroid));
% minimal distance is mean diameter:
diams=cat(1,axonlist.axonEquivDiameter);
diams=repmat(diams,[1,length(diams)]);
diams=mean(cat(3,diams,diams'),3)*criteria;

% convert to logical
Mtooclose=(Mdist-diams)<0;

torm=max(tril(Mtooclose),[],1);

