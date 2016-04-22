

path_img = uigetimagefile;
img_BW_test = imread(path_img);


path_ctrl = uigetimagefile;
img_BW_control = imread(path_ctrl);

ManualCorrectionGUI(path_img,path_ctrl);


% img_BW_control=as_display_label(axonlist_control,size(img),'axonEquivDiameter','axon');
% 
% img_BW_test=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
% img_BW_test=im2bw(img_BW_test,0);



path_gray = uigetimagefile;
aaa = imread(path_gray);
aaa= rgb2gray(aaa);

gray_11=aaa(1:round(end/2),1:round(end/2));
gray_21=aaa(round(end/2):end,1:round(end/2));

gray_12=aaa(1:round(end/2),round(end/2):end);
gray_22=aaa(round(end/2):end,round(end/2):end);

imwrite(gray_11,'Gray_11.tif');
imwrite(gray_12,'Gray_12.tif');
imwrite(gray_21,'Gray_21.tif');
imwrite(gray_22,'Gray_22.tif');



path_initial = uigetimagefile;
bbb = imread(path_initial);
bbb=im2bw(bbb,0.5);
figure; imshow(bbb);


init_11=bbb(1:round(end/2),1:round(end/2),:);
init_21=bbb(round(end/2):end,1:round(end/2),:);

init_12=bbb(1:round(end/2),round(end/2):end,:);
init_22=bbb(round(end/2):end,round(end/2):end,:);

imwrite(init_11,'Init_11.tif');
imwrite(init_12,'Init_12.tif');
imwrite(init_21,'Init_21.tif');
imwrite(init_22,'Init_22.tif');


% correct 11

path_img = uigetimagefile;
img_BW_test = imread(path_img);


path_ctrl = uigetimagefile;
img_BW_control = imread(path_ctrl);

ManualCorrectionGUI(path_img,path_ctrl);



ttt = uigetimagefile;
tttt = imread(ttt);


bwpaint1(tttt);

mini=tttt(1:200,1:200,:);

SegmentTool(mini);


%% separate initial image in smaller images for manual seg

x_sep=3;
y_sep=4;

size_x=size(img_BW_test,1);
size_y=size(img_BW_test,2);

img11=img_BW_test(1:150,1:150);
img12=img_BW_test(151:300,1:150);
img13=img_BW_test(301:500,1:150);

img21=img_BW_test(1:150,151:350);
img22=img_BW_test(151:300,151:350);
img23=img_BW_test(301:500,151:350);

img31=img_BW_test(1:150,351:600);
img32=img_BW_test(151:300,351:600);
img33=img_BW_test(301:500,351:600);







% The first way to divide an image up into blocks is by using mat2cell().
blockSizeR = 180; % Rows in block.
blockSizeC = 205; % Columns in block.
% Figure out the size of each block in rows. 
% Most will be blockSizeR but there may be a remainder amount of less than that.
wholeBlockRows = floor(size_x / blockSizeR);
blockVectorR = [blockSizeR * ones(1, wholeBlockRows), rem(size_x, blockSizeR)];
% Figure out the size of each block in columns. 
wholeBlockCols = floor(size_y / blockSizeC);
blockVectorC = [blockSizeC * ones(1, wholeBlockCols), rem(size_y, blockSizeC)];
% Create the cell array, ca.  
% Each cell (except for the remainder cells at the end of the image)
% in the array contains a blockSizeR by blockSizeC by 3 color array.
% This line is where the image is actually divided up into blocks.

cell_img = mat2cell(img_BW_test, blockVectorR, blockVectorC);
cell_ctrl = mat2cell(img_BW_control, blockVectorR, blockVectorC);



for i=1:3
    for j=1:3
        
        
        
        
        
    end
end



a11=cell2mat(cell_img(1,1));
imwrite(a11,'CARS_img_11.tif');

b11=cell2mat(cell_ctrl(1,1));
imwrite(b11,'CARS_ctrl_11.tif');













