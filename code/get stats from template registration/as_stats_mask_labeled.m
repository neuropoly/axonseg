function indexes=as_stats_mask_labeled(axonlist, mask_reg_labeled)

% index1=find(seg==1);
% Mask1 = ismember(seg,index1);

% for i=1:9
% mask(i)=seg==i;
% end

max_regions = max(max(mask_reg_labeled));

% mask9=imresize(img_reg_labeled==9, reduced);
% mask9=mask9(1:size(img,1),1:size(img,2),:);



% [Index9, Stats9] = as_stats_Roi(axonlist, [], mask9);


for i=5:7
    
% for i=1:2
%     
%     
% i=4;

tic
P=mask2poly(mask_reg_labeled==i);
toc

tic
% Get the axon centroids
Centroid=cat(1,axonlist.Centroid);
% Get the x values of the centroids
Centroidx=Centroid(:,1);
% Get the y values of the centroids
Centroidy=Centroid(:,2);
% Get the x values of the polygon
Px=P(:,2);
% Get the y values of the polygon
Py=P(:,1);

% P_4=P;


Px=downsample(Px,110);
Py=downsample(Py,110);


% Verify if the axons defined by their centroids are included in the
% polygon area

indexes{i}=inpolygon(Centroidx,Centroidy,Px,Py);
toc

% indexes{i}=inpolygon(Centroidx,Centroidy,Px*reduced,Py*reduced);



end