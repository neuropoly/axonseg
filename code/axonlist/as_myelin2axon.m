function ind=as_myelin2axon(index)
%ind=as_myelin2axon(index)
% index is a Nx2 matrix --> coordinates X/Y of the myelin
%
% See also: as_myelinseg_to_axonseg, as_display_label
%
[myelin,indminx,indminy]=as_index2mask(index);

Axon=imfill(myelin,'holes')-myelin;

clear ind
[xa,ya]=find(Axon);
ind(:,1)=xa+indminx;
ind(:,2)=ya+indminy;

