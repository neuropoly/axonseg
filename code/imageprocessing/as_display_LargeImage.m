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
Data.img = img; Data.img_zoom = img;

figure(76);
Data.reducefactor=max(1,floor(size(Data.img,1)/1000));   % Max 1000 pixels size set for imshow
imagesc(img(1:Data.reducefactor:end,1:Data.reducefactor:end,:))
axis image
guidata(76,Data)
uicontrol('Style','pushbutton','String','reset','Callback',@(src,event) resestimg)
uicontrol('Style','pushbutton','String','zoom','Callback',@(src,event) displayimg,'Position',[90 20 60 20])
set(gcf,'toolbar','figure');

end

function displayimg
Data = guidata(76);

Data.img_zoom=as_improc_cutFromRect(Data.img_zoom, Data.reducefactor);

Data.reducefactor=max(1,floor(size(Data.img_zoom,1)/1000));   % Max 1000 pixels size set for imshow
imagesc(Data.img_zoom(1:Data.reducefactor:end,1:Data.reducefactor:end,:));
axis image

guidata(76,Data)
end

function resestimg
Data = guidata(76);
Data.reducefactor=max(1,floor(size(Data.img,1)/1000));   % Max 1000 pixels size set for imshow

imagesc(Data.img(1:Data.reducefactor:end,1:Data.reducefactor:end,:))
axis image

Data.img_zoom = Data.img;
guidata(76,Data)
end
