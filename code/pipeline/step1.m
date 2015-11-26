function im_out =step1(handles)
% Function that takes the 3 segmentation parameters chosen by user
% (initSeg, diffmaxMin & threshold) & applies an initial axon segmentation
% based on these.
% state (IN) is the struct containing the values of the 3 parameters
% im_in (IN) is the image to segment

im_in=handles.data.Step1;
initSeg=get(handles.initSeg,'Value');
diffMaxMin=get(handles.diffMaxMin,'Value');
threshold=get(handles.threshold,'Value');




im1 = axonInitialSegmentation(im_in, initSeg);
im1=imfill(im1,'holes'); %imshow(initialBW)

im2 = axonInitialSegmentation(im_in, diffMaxMin);

im3=im_in<prctile(im_in(:),100*threshold);
im3=bwmorph(im3,'fill'); 
im3=bwmorph(im3,'close'); 
im3=bwmorph(im3,'hbreak'); 
im3 = bwareaopen(im3,5); %imshow(im3)
 

if get(handles.Only_LevelSet,'Value')
    
im4=as_LevelSet_method(im_in);
im_out=im4.img;

elseif get(handles.LevelSet_step1,'Value')

im4=as_LevelSet_method(im_in);
im_out= im1 | im2 | im3 | im4.img;

else
    
im_out= im1 | im2 | im3;

end


