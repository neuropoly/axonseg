function [img_cluster1,img_cluster2]=as_clustering(img_BW)
% [img_cluster1,img_cluster2]=as_clustering(AxonSeg_step2);


% img_path_1 = uigetimagefile;
% axonSeg_step1 = imread(img_path_1);
% 
% img_path_2 = uigetimagefile;
% axonSeg_segCorrected = imread(img_path_2);

img_BW = im2bw(img_BW);
img_BW = bwmorph(img_BW,'clean');

[Stats_size, names] = as_stats_axons(img_BW);

Stats_size_used = rmfield(Stats_size,setdiff(names, {'Area', 'Perimeter', 'EquivDiameter', 'Solidity', 'MajorAxisLength',...
    'MinorAxisLength','Eccentricity'}));

Stats_size_used = struct2array(Stats_size_used);

[~,U] = fcm(Stats_size_used,2);

maxU = max(U);
index1 = find(U(1,:) == maxU);
index2 = find(U(2,:) == maxU);


img_cluster1 = ismember(bwlabel(img_BW),index1);
img_cluster2 = ismember(bwlabel(img_BW),index2);

% hist(Stats_size_used(index1),Stats_size_used(index1,2),'ob')


end