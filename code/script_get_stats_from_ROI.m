


% load axonlist into the workspace

imshow(img);

% draw rectangle on image to create mask
[Pos, maskroi]=as_tools_getroi(img,'rect');

% create the cropped image
img_cropped=img(Pos(3):Pos(4),Pos(1):Pos(2));
imshow(img_cropped);

% get indexes of axons belonging to the mask
[Index, ~] = as_stats_Roi(axonlist, [], maskroi);

% get the axonlist of axons in the mask
axonlist_ROI= axonlist(Index);

% compute stats from the region
mask_stats=compute_stats_from_axonlist(axonlist_ROI,PixelSize,img_cropped);



mask_table=struct2table(mask_stats);





