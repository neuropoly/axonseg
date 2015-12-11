
img_path_1 = uigetimagefile;
img = imread(img_path_1);

img_path_2 = uigetimagefile;
img_axonseg = imread(img_path_2);

img_path_3 = uigetimagefile;
img_axonseg_all = imread(img_path_3);
img_axonseg_all=im2bw(img_axonseg_all);

seg=edge(img, 'Canny',0.01);
imshow(seg);

seg_sum=(0.4*im2uint8(seg))+img_axonseg_all;
imshow(seg_sum);

imshow(imfuse(img_axonseg, seg));
imshow(imfuse(img_axonseg_all, seg));

edges_axons=edge(img_axonseg_all,'Canny');
imshow(edges_axons);




[cc,num] = bwlabel(img_axonseg_all,8);
props = regionprops(cc,{'Area', 'Perimeter', 'EquivDiameter', 'Solidity','Extrema','Image'});

Extrema=cat(1,props.Extrema);


imshow(img_axonseg_all);
hold on;
plot(Extrema(:,1),Extrema(:,2),'r*');



seg=im2double(seg);

Intensity_means=zeros(num,1);

for i=1:num
    canny_object_values = seg(cc==i);
    Intensity_means(i,:)=mean(canny_object_values);
end


selected=find(Intensity_means(:,1)<=0.2);
  
    
    
%%

[cc,num] = bwlabel(img_axonseg_all,8);
props = regionprops(cc,{'Area', 'Perimeter', 'EquivDiameter', 'Solidity','Extrema','Image'});



Image=props(50).Image;
imshow(Image);

Image_big=imresize(Image,1.2);
imshow(Image_big);



L=watershed(img,8);
imagesc(L);















