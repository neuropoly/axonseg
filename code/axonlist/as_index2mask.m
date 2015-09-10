function [mask,indminx,indminy]=as_index2mask(index)
% [mask,indminx,indminy]=as_index2mask(index)
% index is a Nx2 matrix --> coordinates X/Y of binary object

indminx=min(index(:,1))-1;
indminy=min(index(:,2))-1;

sizeax=[max(index(:,1))-indminx max(index(:,2))-indminy];
mask=false(sizeax);
ind=sub2ind(sizeax,index(:,1)-indminx,index(:,2)-indminy);
mask(ind)=true;
