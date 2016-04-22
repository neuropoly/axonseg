
function bwpaint1(A)
 
imagesc(A(:,:,1:3));

colormap('default'); 
% colormap(gray);
% 
nz=round(size(A,3)/3);

if nz>1
h0 = uicontrol('Style', 'text', ...
     'Position', [100 0 200 50], ...
     'String','Slice No. (slide to change image slice',...
     'Tag','txtErase');
h = uicontrol('Style', 'slider', ...
     'Position', [100 50 200 50], ...
     'Value',0,...
     'Max',nz-1,...
     'Min',0,...
     'Tag','sliderZ',...
     'SliderStep',[(1/(nz-1)) (1/(nz-1))],...
     'Callback', @display);
else
    h = uicontrol('Style', 'slider', ...
     'Position', [100 50 200 50], ...
     'Value',0,...
     'Max',0,...
     'Min',0,...
     'Tag','sliderZ',...
     'SliderStep',[1 1],...
     'Callback', @display);
end
h1 = uicontrol('Style', 'pushbutton', ...
     'Position', [100 100 200 50], ...
     'String','Export RGB image matrix to A.mat...',...
     'Callback', @export);
%  h2 = uicontrol('Style', 'togglebutton', ...
%      'Position', [100 150 200 50], ...
%      'String','Draw',...
%      'Tag','pbDraw',...
%      'Callback', @pbDraw_Callback);
%  
%  h3 = uicontrol('Style', 'togglebutton', ...
%      'Position', [100 200 200 50], ...
%      'String','Erase',...
%      'Tag','pbErase',...
%      'Callback', @pbErase_Callback);
 h4 = uicontrol('Style', 'text', ...
     'Position', [100 250 200 50], ...
     'String','Brush Size (slide to change bruch size, left click on image to paint, right click to erase...',...
     'Tag','txtErase');
 
 h5 = uicontrol('Style', 'slider', ...
     'Position', [100 300 200 50], ...
     'Value',0,...
     'Max',5,...
     'Min',0,...
     'Tag','sizeErase',...
     'SliderStep',[0.2  0.2]);
 

axis image;
%%%

m=size(A,1);n=size(A,2);%size of the image

xlim([1 n]);
ylim([1 m]);
 

% Unpack gui object
gui = get(gcf,'UserData');

% 
% cc=NaN(16,16);
% cc(1:9,1:9)=2;
% 
% set(gcf,'PointerShapeCData',cc);
set(gcf,'Pointer','arrow');

% Make a fresh figure window
set(gcf,'WindowButtonDownFcn',@startmovit);

% Store gui object
set(gcf,'UserData',{gui;A});
% function pbDraw_Callback(hObject, eventdata, handles)
% 
% set(hObject,'Value',1);
% pbErase=findobj(gcf,'Tag','pbErase');
% set(pbErase,'Value',0);
% 
% function pbErase_Callback(hObject, eventdata, handles)
% 
% set(hObject,'Value',1);
% pbDraw=findobj(gcf,'Tag','pbDraw');
% set(pbDraw,'Value',0);

function export(src,evnt)
% Unpack gui object
 

temp = get(gcf,'UserData');
gui=temp{1};
A=temp{2};

save ('A.mat','A');

function display(src,evnt)
% Unpack gui object
 

temp = get(gcf,'UserData');
gui=temp{1};
A=temp{2};

% 
a=findobj(gcf,'Style','Slider','-and','Tag','sliderZ');
% cz=get(a,'Value');
% 
% cz=round(get(a,'Value')*3)

imagesc(A(:,:,round(get(a,'Value'))*3+1:round(get(a,'Value'))*3+3));
colormap('default');
axis image;

function startmovit(src,evnt)
% Unpack gui object
temp = get(gcf,'UserData');
gui=temp{1};
A=temp{2};

hr=findobj(gcf,'Style','Slider','-and','Tag','sizeErase');
r=get(hr,'Value');
a=findobj(gcf,'Style','Slider','-and','Tag','sliderZ');
im2=A(:,:,round(get(a,'Value'))*3+2);

pos = get(gca,'CurrentPoint');
flag_btn=get(src,'SelectionType');
% disp(flag_btn);

[m,n]=size(A);

cm=round(pos(1,2));
cn=round(pos(1,1));

% A(max(cm,1):min(cm+2,m),max(cn,1):min(cn+2,n))=1; 

if strcmp(flag_btn,'normal')
im2(max(cm-r,1):min(cm+r,m),max(cn-r,1):min(cn+r,n))=1; 
elseif strcmp(flag_btn,'alt')
im2(max(cm-r,1):min(cm+r,m),max(cn-r,1):min(cn+r,n))=0; 
end

A(:,:,round(get(a,'Value'))*3+2)=im2;
 
imagesc(A(:,:,round(get(a,'Value'))*3+1:round(get(a,'Value'))*3+3));
colormap('default');
axis image;


% Set callbacks
gui.currenthandle = src;
thisfig = gcbf();
set(thisfig,'WindowButtonMotionFcn',@movit);
set(thisfig,'WindowButtonUpFcn',@stopmovit);
 
% Store gui object
set(gcf,'UserData',{gui;A});



function movit(src,evnt)
% Unpack gui object
ud = get(gcf,'UserData');


flag_btn=get(src,'SelectionType');


try
if isequal(gui.startpoint,[])
    return
end
catch
end
 
pos = get(gca,'CurrentPoint');
% disp(flag_btn);



img=ud{2};
hr=findobj(gcf,'Style','Slider','-and','Tag','sizeErase');
r=get(hr,'Value');
a=findobj(gcf,'Style','Slider','-and','Tag','sliderZ');
im2=img(:,:,round(get(a,'Value'))*3+2);
[m,n]=size(im2);

cm=round(pos(1,2));
cn=round(pos(1,1));

if strcmp(flag_btn,'normal')
im2(max(cm-r,1):min(cm+r,m),max(cn-r,1):min(cn+r,n))=1; 
elseif strcmp(flag_btn,'alt')
im2(max(cm-r,1):min(cm+r,m),max(cn-r,1):min(cn+r,n))=0; 
end

img(:,:,round(get(a,'Value'))*3+2)=im2;
 
imagesc(img(:,:,round(get(a,'Value'))*3+1:round(get(a,'Value'))*3+3));
colormap('default');
axis image;




ud{2}=img;
 
% Store gui object
set(gcf,'UserData',ud);
 

function stopmovit(src,evnt)

% Clean up the evidence ...

thisfig = gcbf();
ud = get(gcf,'UserData'); 
 
set(thisfig,'WindowButtonUpFcn','');
set(thisfig,'WindowButtonMotionFcn','');
 
 
axis image;

set(gcf,'UserData',ud);