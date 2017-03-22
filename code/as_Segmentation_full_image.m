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
    blocksize=4097;
end
if ~exist('overlap','var') || isempty(overlap)
    overlap=100;
end
blocksize = blocksize + overlap;
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
PixelSize = SegParameters.PixelSize;
save([output 'axonlist_full_image.mat'], 'axonlist', 'img', 'PixelSize','-v7.3')


% save jpeg
% save axon display
currentdir = pwd;
cd(output);
as_display_label(axonlist, size(img),'axonEquivDiameter','axon',img);

% save myelin display
as_display_label(axonlist, size(img),'axonEquivDiameter','myelin',img);
cd(currentdir);
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

AxSeg=step1_full(imresize(im_in,2),segParam);    
    
% end


% Step 2 - discrimination for axon segmentation
% 
if isfield(segParam,'parameters') && isfield(segParam,'DA_classifier')
    AxSeg = as_AxonSeg_predict(AxSeg,segParam.DA_classifier, segParam.parameters,imresize(im_in,2));
else
    AxSeg=step2_full(AxSeg,segParam);
end

AxSeg = imresize(AxSeg,0.5);


%Myelin Segmentation
[AxSeg_rb,~]=RemoveBorder(AxSeg,segParam.PixelSize);
backBW=AxSeg & ~AxSeg_rb; % backBW = axons that have been removed by RemoveBorder
[axonlist] = myelinInitialSegmention(im_in, AxSeg_rb, backBW,0,segParam.Regularize,2/3,0,segParam.PixelSize);
