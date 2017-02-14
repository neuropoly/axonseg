function tessttttt



srcFiles = dir('/Users/alzaia/Desktop/20161005_DOG_panorama/data/*.png');  % the folder in which ur images exists
for i = 1:length(srcFiles)
    filename = strcat('/Users/alzaia/Desktop/20161005_DOG_panorama/data/',srcFiles(i).name);
    I = imread(filename); % maybe not useful for axonseg segmentation
    BW = im2bw(I, 110/255);
%     imwrite(BW,'/Users/alzaia/Desktop/20161005_DOG_panorama/data/','tif')
    write_dir = strcat('/Users/alzaia/Desktop/20161005_DOG_panorama/data/myelin/', srcFiles(i).name,'.tif');
    imwrite(BW,write_dir);
    
end