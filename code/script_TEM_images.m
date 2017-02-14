%% script TEM images GT


img=uigetimagefile;
img=imread(img);

myelin=uigetimagefile;
myelin=imread(myelin);

imshow(imfuse(img,myelin));


%%

a=logical(myelin);
imshow(a);

a=imcomplement(a);
imshow(a);

a=myelin-a;
a=logical(a);
imshow(a);



www=logical(myelin);
imwrite(www,'test_myelin.tif');



%% test after paint



file_name=uigetimagefile;
% file_name=[ooo,eee];
test=imread(file_name);

[aa,bb,cc]=fileparts(file_name);







mask=test(:,:,1);
% imshow(mask);

mask2=mask;

mask2(mask==237)=1;
mask2(mask~=237)=0;

axon=logical(mask2);
% imshow(axon);




save_name=[aa,'/',bb,'_axon',cc];

imwrite(axon,save_name);











%%

% Binarize and Invert the image: 
binaryImage = myelin < 128;
imshow(binaryImage);

% Call imfill(binaryImage, 'holes')
binaryImage = imfill(binaryImage, 'holes');
imshow(binaryImage);

% Get areas
labeledImage = bwlabel(binaryImage);
measurements = regionprops(labeledImage, 'Area');

% Sort based on areas
[sortedAreas, sortIndexes] = sort([measurements.Area], 'Descend');
keeperBlobsImage = ismember(labeledImage, sortIndexes(2:end));
imshow(keeperBlobsImage);


myelin=logical(myelin);

axon=keeperBlobsImage-myelin;
imshow(axon);

% 

both=imfill(myelin,'holes');
imshow(both);

test=both+keeperBlobsImage;
imshow(test);

axon_1=test;
axon_1=logical(axon_1);
imshow(axon_1);

axon_final=axon_1-myelin;
imshow(axon_final);





% Get bounding boxes of the border blobs.  Need to relabel again.
[labeledImage, numberOfBlobs] = bwlabel(keeperBlobsImage);
measurements = regionprops(labeledImage, 'BoundingBox', 'Centroid');

hold on;
for b1 = 1 : numberOfBlobs
	x = measurements(b1).Centroid(1);
	y = measurements(b1).Centroid(2);
	text(x, y, num2str(b1));
end




%%





bw_a = padarray(myelin,[1 1],1,'pre');
bw_a_filled = imfill(bw_a,'holes');
bw_a_filled = bw_a_filled(2:end,2:end);
imshow(bw_a_filled);

bw_b = padarray(padarray(myelin,[1 0],1,'pre'),[0 1],1,'post');
bw_b_filled = imfill(bw_b,'holes');
bw_b_filled = bw_b_filled(2:end,1:end-1);
imshow(bw_b_filled);

bw_c = padarray(myelin,[1 1],1,'post');
bw_c_filled = imfill(bw_c,'holes');
bw_c_filled = bw_c_filled(1:end-1,1:end-1);
imshow(bw_c_filled);

bw_d = padarray(padarray(myelin,[1 0],1,'post'),[0 1],1,'pre');
bw_d_filled = imfill(bw_d,'holes');
bw_d_filled = bw_d_filled(1:end-1,2:end);
imshow(bw_d_filled);



both=imfill(myelin,'holes');
imshow(both);

axon=both-myelin;
imshow(axon);


%% SEM samples

img=PANO_HIGHRES;
imshow(img);

sss=img(900:1450,6870:7500,:);
imshow(sss);

imwrite(sss,'PANO_HIGHRES_900_1450_6870_7500.tif');


sss=img(1400:3000,6000:7500,:);
imshow(sss);

imwrite(sss,'Panorama_rat_20161102_uint8_1400_3000_6000_7500.tif');



%% uint8 to bw



file_name=uigetimagefile;
% file_name=[ooo,eee];
test=imread(file_name);

[aa,bb,cc]=fileparts(file_name);





axon=im2bw(test);
% imshow(axon);






save_name=[aa,'/',bb,cc];

imwrite(axon,save_name);



%% cars samples

imshow(RAT_lumbar);

img1=RAT_lumbar(5400:5916,837:1300);
imshow(img1);
imwrite(img1,'RAT_lumbar_5400_5916_837_1300.tif');

img2=RAT_lumbar(4140:4700,1450:1890);
imshow(img2);
imwrite(img2,'RAT_lumbar_4140_4700_1450_1890.tif');



