function [mask_reg_labeled, P_color]=reg_mask(mask,img)
% For a given mask & an image, the function finds the registration between
% the two. The outputs are the registered & labeled mask (each region of
% the mask has a different label according to the labeling done by the
% user. The second output is the color vector giving the color for each
% labeled region.
%

% Ex: [mask_reg_labeled, P_color]=as_reg_mask(pres0x2E001(:,:,1:3),img);

% mask1 = reg_mask(pres0x2E001(:,:,1:3),img);

% mask=pres0x2E001(:,:,1:3);

reduced=max(1,floor(size(img,1)/1000));

% img=imread('img_lowres.jpg');

[tform,ref]=as_reg_histo2mri(mask,img(1:reduced:end,1:reduced:end,:));

mask_reg=imwarp(mask,tform,'outputview',ref);
imwrite(mask_reg,'Mask_reg_reduced.tif');

% Get the mask with the right size

mask_reg=imresize(mask_reg,reduced);
mask_reg=mask_reg(1:size(img,1),1:size(img,2),:);
imwrite(mask_regions,'Mask_reg_real_size.tif');


imagesc(mask_reg(:,:,1:3)), axis image

P_color = impixel(mask_reg);

mask_reg_labeled=int8(false(size(mask_reg,1),size(mask_reg,2)));
m=20;
for il=1:size(P_color,1)
mask_reg_labeled=mask_reg_labeled+il*int8(mask_reg(:,:,1)>P_color(il,1)-m & mask_reg(:,:,1)<P_color(il,1)+m ...
    & mask_reg(:,:,2)>P_color(il,2)-m & mask_reg(:,:,2)<P_color(il,2)+m & mask_reg(:,:,3)>P_color(il,3)-m & mask_reg(:,:,3)<P_color(il,3)+m);
sc(mask_reg_labeled);
drawnow
end

imshow(mask_reg_labeled);


end

function indexes=as_stats_mask_labeled(axonlist, mask_labeled)


% index1=find(seg==1);
% Mask1 = ismember(seg,index1);




% for i=1:9
% mask(i)=seg==i;
% end

mask9=imresize(img_reg_labeled==9, reduced);
mask9=mask9(1:size(img,1),1:size(img,2),:);



[Index9, Stats9] = as_stats_Roi(axonlist, [], mask9);



for i=1:9
    
P=mask2poly(img_reg_labeled==i);
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

% Verify if the axons defined by their centroids are included in the
% polygon area

in{i}=inpolygon(Centroidx,Centroidy,Px*reduced,Py*reduced);


end

%%

function as_stats_barplot(axonlist,indexes (,P_color))
hold off
cont=0;
for i=1:9
    cont=cont+1;
    diamstd=mean(cat(1,axonlist(in{i}).gRatio));
    bar(cont,diamstd,'FaceColor',P_couleur(i,:)/255)
    hold on
end

hold off
cont=0;
for i=[6 1 2 3 9 4 8 5 7]
    cont=cont+1;
    number=sum(in{i});
    bar(cont,number,'FaceColor',P_couleur(i,:)/255)
    hold on
end















