function as_Segmentation_full_image(im_fname,SegParameters,blocksize,overlap,output)
% as_Segmentation_full_image(im_fname,SegParameters,blocksize (# of pixels),overlap,output)
% as_Segmentation_full_image('Control_2.tif', 'SegParameters.mat',2000,100,'Control_2_results')
%
% im_fname: input image (filename)
% SegParameters: output of SegmentationGUI
% blocksize: input image is divided in smaller pieces in order to limit memory usage..
% See also: SegmentationGUI

%% INPUTS
if ~exist('im_fname','var') || isempty(im_fname)
    im_fname=uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' });
end

if ~exist('SegParameters','var') || isempty(SegParameters)
    SegParameters=uigetfile({'*.mat'});
end

load(SegParameters);

if ~exist('blocksize','var') || isempty(blocksize)
    blocksize=1000;
end
if ~exist('overlap','var') || isempty(overlap)
    overlap=200;
end
if ~exist('output','var') || isempty(output)
    [~,name]=fileparts(im_fname);
    output=[name '_Segmentation'];
end

if ~exist(output,'dir'), mkdir(output); end
output=[output filesep];

disp('reading the image')
handles.data.img=imread(im_fname);
if length(size(handles.data.img))==3
    handles.data.img=rgb2gray(handles.data.img(:,:,1:3));
end

%% SEGMENTATION

disp('Starting segmentation..')
axonlist_cell=as_improc_blockwising(@(x) fullimage(x,SegParameters),handles.data.img,blocksize,overlap,0);

[ axonlist ] = as_listcell2axonlist( axonlist_cell, blocksize, overlap,SegParameters.PixelSize);
img = imadjust(handles.data.img);
% img=cell2mat(cellfun(@(x) x.img, myelin_seg_results,'Uniformoutput',0));
% img=as_improc_rm_overlap(img,blocksize,overlap);


%% SAVE
% save axonlist
save([output 'axonlist_full_image.mat'], 'axonlist', 'img', 'PixelSize','-v7.3')


% save jpeg
% save axon display
axons_map=as_display_label(axonlist, size(img),'axonEquivDiameter','axon');
maxdiam=ceil(prctile(cat(1,axonlist.axonEquivDiameter),99));
RGB = ind2rgb8(axons_map,hot(maxdiam*10));
img_diam=0.5*RGB+0.5*repmat(img,[1 1 3]);
reducefactor=max(1,floor(max(size(img))/25000));   img_diam=img_diam(1:reducefactor:end,1:reducefactor:end,:); % reduce resolution to Max 25000 pixels --> some bugs in large images: https://www.mathworks.com/matlabcentral/answers/299662-imwrite-generates-incorrect-files-by-mixing-up-colors
imwrite(img_diam,[output 'axonEquivDiameter_(axons)_0µm_' num2str(maxdiam) 'µm.jpg'])

% save myelin display
myelin_map=as_display_label(axonlist, size(img),'axonEquivDiameter','myelin');
RGB = ind2rgb8(myelin_map,hot(maxdiam*10));
img_diam = 0.5*RGB+0.5*repmat(img,[1 1 3]);
reducefactor=max(1,floor(max(size(img))/25000));   img_diam=img_diam(1:reducefactor:end,1:reducefactor:end,:); % reduce resolution to Max 25000 pixels --> some bugs in large images: https://www.mathworks.com/matlabcentral/answers/299662-imwrite-generates-incorrect-files-by-mixing-up-colors
imwrite(img_diam,[output 'axonEquivDiameter_(myelins)_0µm_' num2str(maxdiam) 'µm.jpg']);
copyfile(which('colorbarhot.png'),output)

function [axonlist,AxSeg]=fullimage(im_in,segParam)

% Apply initial parameters (invertion, histogram equalization, convolution)
% to the full image

if segParam.invertColor, im_in=imcomplement(im_in); end
if segParam.histEq, im_in=histeq(im_in,segParam.histEq); end;
if segParam.Deconv,im_in=Deconv(im_in,segParam.Deconv); end;
if segParam.Smoothing, im_in=as_gaussian_smoothing(im_in); end;

% Step1 - initial axon segmentation using the 3 parameters given

% if segParam.LevelSet
%     
%     LevelSet_results=as_LevelSet_method(im_in);
%     AxSeg=LevelSet_results.img;
% 
% else
    
AxSeg=step1_full(im_in,segParam);    
    
% end


% Step 2 - discrimination for axon segmentation

if isfield(segParam,'parameters') && isfield(segParam,'DA_classifier')
    AxSeg = as_AxonSeg_predict(AxSeg,segParam.DA_classifier, segParam.parameters,im_in);
else
    AxSeg=step2_full(AxSeg,segParam);
end



%Myelin Segmentation
[AxSeg_rb,~]=RemoveBorder(AxSeg,segParam.PixelSize);
backBW=AxSeg & ~AxSeg_rb; % backBW = axons that have been removed by RemoveBorder
[axonlist] = myelinInitialSegmention(im_in, AxSeg_rb, backBW,0,1,2/3,0,segParam.PixelSize);
