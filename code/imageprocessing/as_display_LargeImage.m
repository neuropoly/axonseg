function img_zoom = as_display_LargeImage(img)
% img_zoom = as_display_LargeImage(img)
%   Example 1
%   ---------
%   Display a very large image and zoom in a selected region
%
%       AS_DISPLAY_LARGEIMAGE(img)
%
%   Example 2
%   ---------
%   Double step zoom: zoom twice in an image
%
%       AS_DISPLAY_LARGEIMAGE(AS_DISPLAY_LARGEIMAGE(img))

figure(76);
Data.reducefactor=max(1,floor(size(img,1)/1000));   % Max 1000 pixels size set for imshow
imagesc(img(1:Data.reducefactor:end,1:Data.reducefactor:end,:))
axis image
setappdata(76,'Data',Data)
setappdata(76,'img',img)

uicontrol('Style','pushbutton','String','reset','Callback',@(src,event) resestimg)
uicontrol('Style','pushbutton','String','zoom','Callback',@(src,event) displayimg,'Position',[90 20 60 20])
set(gcf,'toolbar','figure');

end

function displayimg
Data = getappdata(76,'Data');
img_zoom = getappdata(76,'img_zoom');
h=getPosition(imrect)*Data.reducefactor; h = round(h);
if ~isempty(img_zoom) 
    img_zoom=img_zoom(max(h(2),1):min(h(2)+h(4),end),max(h(1),1):min(h(1)+h(3),end),:);
else
    img = getappdata(76,'img');
    img_zoom=img(max(h(2),1):min(h(2)+h(4),end),max(h(1),1):min(h(1)+h(3),end),:);
end

Data.reducefactor=max(1,floor(size(img_zoom,1)/1000));   % Max 1000 pixels size set for imshow
imagesc(img_zoom(1:Data.reducefactor:end,1:Data.reducefactor:end,:));
axis image

setappdata(76,'Data',Data)
setappdata(76,'img_zoom',img_zoom)
end

function resestimg
Data = getappdata(76,'Data');
img = getappdata(76,'img');
Data.reducefactor=max(1,floor(size(img,1)/1000));   % Max 1000 pixels size set for imshow

imagesc(img(1:Data.reducefactor:end,1:Data.reducefactor:end,:))
axis image

setappdata(76,'Data',Data)
setappdata(76,'img_zoom','')
end
