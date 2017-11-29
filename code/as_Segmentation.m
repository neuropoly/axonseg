function out=as_Segmentation(im_in,segParam)
% axonlist = as_Segmentation(im_in,segParam)
% inputs
%   im_in           [double] grayscale image
%   segParam        [struct] Segmentation Parameters
% outputs
%   axonlist        [struct] list that contains coordonates of objects        
%
% TIPS: if segParam contains a field segParam.skipmyelin = true -->
% MyelinSeg is skipped (much faster). the outputs is AxSeg:
%   AxSeg           [logical] mask of axons 


% Apply initial parameters (invertion, histogram equalization, convolution)
% to the full image
if size(im_in,3)==2, AxSeg = logical(im_in(:,:,2)); im_in = im_in(:,:,1); end
if segParam.invertColor, im_in=imcomplement(im_in); end
if segParam.histEq, im_in=histeq(im_in,segParam.histEq); end;
if segParam.Deconv,im_in=Deconv(im_in,segParam.Deconv); end;
if segParam.Smoothing, im_in=as_gaussian_smoothing(im_in); end;

% Step1 - initial axon segmentation using the 3 parameters given

if ~exist('AxSeg','var')
    AxSeg=step1_full(imresize(im_in,2),segParam);
    
    
    % Step 2 - discrimination for axon segmentation
    %
    if isfield(segParam,'parameters') && isfield(segParam,'DA_classifier')
        AxSeg = as_AxonSeg_predict(AxSeg,segParam.DA_classifier, segParam.parameters,imresize(im_in,2));
    else
        AxSeg=step2_full(AxSeg,segParam);
    end
    
    AxSeg = imresize(AxSeg,0.5);
end

%Myelin Segmentation
[AxSeg_rb,~]=RemoveBorder(AxSeg,segParam.PixelSize);
backBW=AxSeg & ~AxSeg_rb; % backBW = axons that have been removed by RemoveBorder
if isfield(segParam,'skipmyelin') && segParam.skipmyelin
    out = AxSeg;
else
    out = myelinInitialSegmention(im_in, AxSeg_rb, backBW,0,segParam.Regularize,2/3,0,segParam.PixelSize);
end
