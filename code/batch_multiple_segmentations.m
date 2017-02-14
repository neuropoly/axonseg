% batch for automatic axon segmentation of multiple images

% srcFiles = dir('/Users/alzaia/Desktop/test_for_batch/*.tif');  % the folder in which ur images exists
% for i = 1 : length(srcFiles)
%     filename = strcat('/Users/alzaia/Desktop/test_for_batch/',srcFiles(i).name);
%     I = imread(filename); % maybe not useful for axonseg segmentation
%     
%     as_Segmentation_full_image_axons_only(filename, 'SegParameters.mat',2000,100); % output folder will have same name as image + '_Segmentation' and be in the current matlab folder
%        
% end

%% PERFORM AXON SEGMENTATION ON EVERY SAMPLE FROM SPECIFIC FOLDER (VERIFY IF SegParameters.do_myelin is 0).

srcFiles = dir('/Users/alzaia/Desktop/20161005_DOG_panorama/data/*.png');  % the folder in which ur images exists
for i = 1:length(srcFiles)
    filename = strcat('/Users/alzaia/Desktop/20161005_DOG_panorama/data/',srcFiles(i).name);
    I = imread(filename); % maybe not useful for axonseg segmentation
    
    as_Segmentation_full_image(filename, 'SegParameters.mat',500,100); % output folder will have same name as image + '_Segmentation' and be in the current matlab folder
       
end

% filename='/Users/alzaia/data/2_test.tif';

% for ddd=1:length(axonlist)
%     if axonlist(ddd).axonEquivDiameter>20
%         axonlist(ddd)=[];
%     end
% end

%% correct axonlist if huge false positives & update axon display image and save it

% load axonlist into workspace before & change name of output folder below

axonlist([axonlist.axonEquivDiameter] > 25) = [];
output='/Users/alzaia/Desktop/20161005_DOG_panorama/data/53_Segmentation/';

save([output 'axonlist_full_image.mat'], 'axonlist', 'img', 'PixelSize','-v7.3');

% then update the axon segmentation display based on the new axonlist

bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','axon'); 
display_1=sc(sc(bw_axonseg,'hot')+sc(img));
% imshow(display_1);

maxdiam=ceil(prctile(cat(1,axonlist.axonEquivDiameter),99));
imwrite(display_1,[output 'axonEquivDiameter_(axons)_0µm_' num2str(maxdiam) 'µm.jpg'])


%%

% reduce size of axonlist - eliminate all unecessary fields

fields_to_remove = {'data','axonID'}; % erasing these 2 fields reduces axonlist size by 90% 1 MB -> 113 KB for example
axonlist_reduced=rmfield(axonlist,fields_to_remove);
% save('axonlist_reduced.mat','axonlist_reduced','-v7.3');


% save('axonlist_original.mat','axonlist','-v7.3');





%% import text file & read data for stitching (x, y) coordinates

filename = '/Users/alzaia/Desktop/20161005_DOG_panorama/TileConfiguration.registered_test.txt';
delimiterIn = ',';
headerlinesIn = 0;

% stitching_info.data contains x & y positions of each tile in 2 columns
% stitching_info.textdata 54x1 cell contains name of each tile

stitching_info=importdata(filename,delimiterIn,headerlinesIn);






%% segment myelin by threshold

srcFiles = dir('/Users/alzaia/Desktop/20161005_DOG_panorama/data/*.png');  % the folder in which ur images exists
for i = 1 : length(srcFiles)
    filename = strcat('/Users/alzaia/Desktop/20161005_DOG_panorama/data/',srcFiles(i).name);
    I = imread(filename); % maybe not useful for axonseg segmentation
    BW = im2bw(I, 110/255);
%     imwrite(BW,'/Users/alzaia/Desktop/20161005_DOG_panorama/data/','tif')
    write_dir = strcat('/Users/alzaia/Desktop/20161005_DOG_panorama/data/myelin', '/', srcFiles(i).name,'.tif');
    imwrite(BW,write_dir);
    
end



% current_sample=imread(filename);
% imhist(current_sample);
% BW = im2bw(current_sample, 110/255);
% imshow(BW);
% imwrite(BW,'16_myelin_seg.tif');

%% blockwising problem

img=imread('DogPano_fullRes_cleaned.tif');
imshow(img);
%function img_zoom = as_display_LargeImage(img)

reducefactor=max(1,floor(size(img,1)/1000));   % Max 1000 pixels size set for imshow
imshow(img(1:reducefactor:end,1:reducefactor:end));

% [img_zoom]=as_improc_cutFromRect(img);

sample_1=img(14000:16000,8000:10000,:);
imshow(sample_1);
imwrite(sample_1,'20161020dog_sample_1.tif');

sample_2=img(12500:14000,13500:15500,:);
imshow(sample_2);
imwrite(sample_2,'20161020dog_sample_2.tif');

% threshold methods

a1=adaptivethreshold(sample_1,100,0.03,0);
imshow(a1);


% filters before or after

imhist(sample_1);
imhist(sample_2);

a1=sample_1>150;
imshow(a1);



ImageSegmenter;




reducefactor=max(1,floor(size(img_zoom,1)/1000));   % Max 1000 pixels size set for imshow
imshow(img_zoom(1:reducefactor:end,1:reducefactor:end));
img=~~imread('Bin_otsuadapt.tif');

Res=as_improc_blockwising(@(img_zoom) sum(img_zoom(:))/size(img_zoom,1)/size(img_zoom,2),img,300,0,0);

imagesc(cell2mat(Res))

axis image

colormap jet

colorbar

save_nii_v2(make_nii(cell2mat(Res)),'MVF_histo')


%% for each small axonlist, 










% srcFiles = dir('/Users/alzaia/Desktop/test_for_batch/*.tif');  % the folder in which ur images exists
% for i = 1 : length(srcFiles)
%     filename = strcat('/Users/alzaia/Desktop/test_for_batch/',srcFiles(i).name);
%     I = imread(filename);
%     figure, imshow(I);
% end
