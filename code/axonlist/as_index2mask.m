function [mask,indminx,indminy]=as_index2mask(index)
% [mask,indminx,indminy]=as_index2mask(index)
% index is a Nx2 matrix --> coordinates X/Y of binary object

% Get min x coordinate of object
indminx=min(index(:,1))-1;
% Get min y coordinate of object
indminy=min(index(:,2))-1;

% Set mask size by using object boundaries (myelin limits)
sizeax=[max(index(:,1))-indminx max(index(:,2))-indminy];
% Initialize mask with correct size
mask=false(sizeax);
% 
ind=sub2ind(sizeax,index(:,1)-indminx,index(:,2)-indminy);
% Set myelin coordinates (x,y) to true
mask(ind)=true;
