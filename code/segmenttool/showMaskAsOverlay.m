function varargout = showMaskAsOverlay(opacity, mask, overlaycolor, varargin)
% Show segmentation (mask) with user-specified transparency/color as overlay on image
%
% Using optional input DELEMASK argument, one can
% easily show multiple segmentation masks on a single image.
%
% SYNTAX:
%
% SHOWMASKASOVERLAY(OPACITY, MASK, OVERLAYCOLOR)
%     Operates on the image in the current figure, overlays a
%     MASK of opacity OPACITY and of color OVERLAYCOLOR.
%
% SHOWMASKASOVERLAY(OPACITY, MASK, OVERLAYCOLOR, IMG)
%     Takes a handle to an image or axes, or an image itself.
%
% SHOWMASKASOVERLAY(OPACITY, MASK, OVERLAYCOLOR, IMG, DELEMASKS)
%     DELEMASKS is a logical binary, indicating whether existing masks
%     should be deleted before new masks are displayed. Default is TRUE.
%
% SHOWMASKASOVERLAY(OPACITY, MASK, OVERLAYCOLOR, IMG, DELEMASKS, PARENT)
%     By default, showMaskAsOverlay operates on the current axes in the
%     current figure. Use the optional PARENT argument to specify the AXES
%     you want to show the mask on.
%
% SHOWMASKOVERLAY(OPACITY)
%     If an overlayed mask already exists in the current figure,
%     this shorthand command will modify its opacity.
%
% HNDLS = SHOWMASKASOVERLAY(...)
%     Returns a structure of handles to the original image (FIRST) and
%     generated overlays in the current axes.
%
% [HNDLS, IMGOUT] = SHOWMASKASOVERLAY(...)
%     Also returns an RGB image of class double, capturing the combined IMG
%     and OVERLAY(s) as image IMGOUT.
%
% INPUTS:
%
%     OPACITY       The complement of transparency; a variable on [0,1]
%                   describing how opaque the overlay should be. A
%                   mask of opacity of 0 is 100% transparent. A mask
%                   of opacity 1 is completely solid.
%     MASK          A binary image to be shown on the image of
%                   interest. (Must be the same size as the image operated
%                   on.)
%     OVERLAYCOLOR  A triplet of [R G B] value indicating the color
%                   of the overlay. (Standard "color strings"
%                   like 'r','g','b','m' are supported.) Default
%                   is red.
%     IMG           (Optional) A handle to an image-containing axes, or an
%                   image. By default, SHOWIMAGEASOVERLAY operates on the
%                   image displayed in the current axes. (If this argument
%                   is omitted, or if the current axes does not contain an
%                   image, an error will be thrown.)
%
%                   Alternatively, IMG may be an image, in which case a new
%                   figure is generated, the image is displayed, and the
%                   overlay is generated on top of it.
%
%     DELEMASKS     Delete previously displayed masks?
%                   This operates at a figure-level. (Default = 1.)
%
% OUTPUTS:
%
%     HNDLS         A structure containing handles of all images (including
%                   overlays) in the current axes. The structure will have
%                   fields:
%                      Original:   The underlying (non-overlaid) image in
%                                  the parent axes.
%                      Overlays:   All overlays created by
%                                  SHOWMASKASOVERLAY.
%                   (NOTE: To get the IMAGES themselves, extract
%                   the CDATA from the image handles.)
%
%     NEWIMG        An output image, matching the class of
%                   the input image, of the color-coded
%                   mask.
%
% EXAMPLES:
% 1)
%                   I = imread('rice.png');
%                   I2 = imtophat(I, ones(15, 15));
%                   I2 = im2bw(I2, graythresh(I2));
%                   I2 = bwareaopen(I2, 5);
%                   figure;
%                   imshow(I);
%                   showMaskAsOverlay(0.4,I2)
%                   title('showMaskAsOverlay')
%
% 2)
%                   I = imread('rice.png');
%                   AllGrains = imtophat(I, ones(15, 15));
%                   AllGrains = im2bw(AllGrains, graythresh(AllGrains));
%                   AllGrains = bwareaopen(AllGrains, 5);
%                   PeripheralGrains = AllGrains -imclearborder(AllGrains);
%                   InteriorGrains = AllGrains - PeripheralGrains;
%                   figure;
%                   subplot(2,2,1.5)
%                   imshow(I); title('Original')
%                   subplot(2,2,3)
%                   imshow(I)
%                   showMaskAsOverlay(0.4,AllGrains)
%                   title('All grains')
%                   subplot(2,2,4)
%                   imshow(I)
%                   % Note: I set DELEMASKS explicity to 0 here so
%                   % 'AllGrains' mask is not cleared from figure
%                   showMaskAsOverlay(0.4,InteriorGrains,[1 1 0],[],0)
%                   showMaskAsOverlay(0.4,PeripheralGrains,'g',[],0)
%                   title('Interior and Peripheral Grains')
%
% 3)                I = imread('peppers.png');
%                   mask = im2bw(I(:,:,1),graythresh(I(:,:,1)));
%                   imshow(I);
%                   [h,newImg] = showMaskAsOverlay(1,mask,[0.65 0.47 0.69]);
%                   cla;
%                   imshow(newImg);

% Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% V 1.0 07/05/2007
% V 1.5 03/02/2009: Modified to provide the new-colored image as
% an output, matching the class of the underlying image (over
% which the overlay is displayed).
% V 1.6 10/19/2011: Fixed casting problem for optional
% "burned" output image.
% V 1.7 12/18/2011: Replaced deprecated IPTCHECKINPUTS with
% VALIDATEATTRIBUTES.
% V 1.8 10/12/2012: Allow for optional specification of parent axes.

% Copyright 2010-2013 The Mathworks Inc

error(nargchk(1,5,nargin));
if nargin >= 4
    if ~isempty(varargin{1})
        if ishandle(varargin{1})
            imgax = varargin{1};
        else
            figure;
            imshow(varargin{1});
            imgax = imgca;
        end
    else
        imgax = imgca;
    end
    %fig = get(imgax,'parent');
    fig = ancestor(imgax,'figure');
    axes(imgax);
else
    fig = gcf;
    imgax = imgca;
end

if nargin == 5
    deleMasks = logical(varargin{2});
else
    deleMasks = true;
end

%iptcheckinput(opacity, {'double','logical'},{'nonempty'},mfilename, 'opacity', 1);
validateattributes(opacity, {'double','logical'},{'nonempty'},mfilename, 'opacity', 1);
%iptcheckinput(deleMasks, {'logical'},{'nonempty'}, mfilename, 'deleMasks', 5);
validateattributes(deleMasks, {'logical'},{'nonempty'}, mfilename, 'deleMasks', 5);

if nargin == 1
    overlay = findall(gcf,'tag','opaqueOverlay');
    if isempty(overlay)
        error('SHOWMASKASOVERLAY: No opaque mask found in current figure.');
    end
    mask = get(overlay,'cdata');
    newmask = max(0,min(1,double(any(mask,3))*opacity));
    set(overlay,'alphadata',newmask);
    figure(fig);
    %tofront(get(fig,'name'));
    return
else
    %iptcheckinput(mask, {'double','logical'},{'nonempty'}, mfilename, 'mask', 2);
    validateattributes(mask, {'double','logical'},{'nonempty'}, mfilename, 'mask', 2);
end

% If the user doesn't specify the color, use red.
DEFAULT_COLOR = [1 0 0];
if nargin < 3
    overlaycolor = DEFAULT_COLOR;
elseif ischar(overlaycolor)
    switch overlaycolor
        case {'y','yellow'}
            overlaycolor = [1 1 0];
        case {'m','magenta'}
            overlaycolor = [1 0 1];
        case {'c','cyan'}
            overlaycolor = [0 1 1];
        case {'r','red'}
            overlaycolor = [1 0 0];
        case {'g','green'}
            overlaycolor = [0 1 0];
        case {'b','blue'}
            overlaycolor = [0 0 1];
        case {'w','white'}
            overlaycolor = [1 1 1];
        case {'k','black'}
            overlaycolor = [0 0 0];
        otherwise
            disp('Unrecognized color specifier; using default.');
            overlaycolor = DEFAULT_COLOR;
    end
end

figure(fig);
%tofront(get(fig,'name'));
if isempty(imgax)
    tmp = imhandles(fig);
else
    tmp = imhandles(imgax);
end
if isempty(tmp)
    error('There doesn''t appear to be an image in the current figure.');
end
try
    a = imattributes(tmp(1));
catch
    error('There doesn''t appear to be an image in the current figure.');
end
imsz = [str2num(a{2,2}),str2num(a{1,2})]; %#ok

if ~isequal(imsz,size(mask(:,:,1)))
    error('Size mismatch');
end
if deleMasks
    %delete(findall(fig,'tag','opaqueOverlay'))
    delete(findall(imgax,'tag','opaqueOverlay'))
end

overlaycolor = im2double(overlaycolor);
% Ensure that mask is logical
mask = logical(mask);

if size(mask,3) == 1
    newmaskR = zeros(imsz);
    newmaskG = newmaskR;
    newmaskB = newmaskR;
    %Note: I timed this with logical indexing (as currently implemented),
    %with FIND, and with logical indexing after converting the mask to type
    %logical. All three were roughly equivalent in terms of performance.
    newmaskR(mask) = overlaycolor(1);
    newmaskG(mask) = overlaycolor(2);
    newmaskB(mask) = overlaycolor(3);
elseif size(mask,3) == 3
    newmaskR = mask(:,:,1);
    newmaskG = mask(:,:,2);
    newmaskB = mask(:,:,3);
else
    beep;
    disp('Unsupported masktype in showImageAsOverlay.');
    return
end

newmask = im2uint8(cat(3,newmaskR,newmaskG,newmaskB));
hold on;
h = imshow(newmask);
try
    set(h,'alphadata',double(mask)*opacity,'tag','opaqueOverlay');
catch
    set(h,'alphadata',opacity,'tag','opaqueOverlay');
end

if nargout > 0
    % This returns handles to two images, im1 and im2.
    % im1 is the handle of the "COLORED MASK" imge.
    % im2 is the handle of the image over which you are
    % overlaying.
    % To get the actual image for either, refer to the cdata of
    % the image handles.
    varargout{1} = imhandles(imgca);
end
if nargout > 1
    % This returns a "concatenated" rgb image of the
    % color-coded overlaid mask.
    tmp = get(varargout{1}(1),'cdata');
    switch a{3,2}
        case 'uint8'
            mult = 255;
        case 'uint16'
            mult = 2^16;
        otherwise
            mult = 1;
    end
    r = tmp(:,:,1);
    g = tmp(:,:,2);
    b = tmp(:,:,3);
    r(mask) = overlaycolor(1)*mult;
    g(mask) = overlaycolor(2)*mult;
    b(mask) = overlaycolor(3)*mult;
    varargout{2} = cast(cat(3,r,g,b),a{3,2});
end