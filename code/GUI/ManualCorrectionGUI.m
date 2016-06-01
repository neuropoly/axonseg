function varargout = ManualCorrectionGUI(varargin)

% Example: ----------------------------------------------------------------
%
% path_img = uigetimagefile;
% img_BW_test = imread(path_img);
% 
% path_ctrl = uigetimagefile;
% img_BW_control = imread(path_ctrl);
% 
% ManualCorrectionGUI(path_img,path_ctrl);
%
%--------------------------------------------------------------------------

% MANUALCORRECTIONGUI MATLAB code for ManualCorrectionGUI.fig
%      MANUALCORRECTIONGUI, by itself, creates a new MANUALCORRECTIONGUI or raises the existing
%      singleton*.
%
%      H = MANUALCORRECTIONGUI returns the handle to a new MANUALCORRECTIONGUI or the handle to
%      the existing singleton*.
%
%      MANUALCORRECTIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALCORRECTIONGUI.M with the given input arguments.
%
%      MANUALCORRECTIONGUI('Property','Value',...) creates a new MANUALCORRECTIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ManualCorrectionGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ManualCorrectionGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ManualCorrectionGUI

% Last Modified by GUIDE v2.5 18-May-2016 16:33:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ManualCorrectionGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ManualCorrectionGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT


% --- Executes just before ManualCorrectionGUI is made visible.
function ManualCorrectionGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ManualCorrectionGUI (see VARARGIN)

% Choose default command line output for ManualCorrectionGUI
handles.output = hObject;

% Input 1 expected to be the image
if strfind(varargin{1},'.nii')
    handles.img = load_nii_data(varargin{1});
else
    handles.img = imread(varargin{1});
end

% Image is enhanced to help manual segmentation
handles.img=adapthisteq(handles.img);

% Input 2 expected to be initial binary mask
handles.axsegfname=varargin{2};
if strfind(handles.axsegfname,'.nii')
    handles.bw_axonseg = load_nii_data(handles.axsegfname);
else
    handles.bw_axonseg = imread(handles.axsegfname);
end

% Display image and initial mask on GUI
axes(handles.axes1);
sc(get(handles.alpha,'Value')*sc(handles.bw_axonseg,'y',handles.bw_axonseg)+sc(handles.img));

% zoom(handles.axes1,2);

% Make a copy of image for other operations in GUI
handles.img2=handles.img;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes ManualCorrectionGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ManualCorrectionGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Select transparency value for display
function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

axes(handles.axes1);


length_y=handles.length_y;
length_x=handles.length_x;

display_img=handles.img(get(handles.slider_x,'Value')+1:get(handles.slider_x,'Value')+length_y,get(handles.slider_y,'Value')+1:get(handles.slider_y,'Value')+length_x);
display_mask=handles.bw_axonseg(get(handles.slider_x,'Value')+1:get(handles.slider_x,'Value')+length_y,get(handles.slider_y,'Value')+1:get(handles.slider_y,'Value')+length_x);
sc(get(handles.alpha,'Value')*sc(display_mask,'y',display_mask)+sc(display_img));

% zoom(handles.axes1,2);


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on button press in add.
function add_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bw=4;
uiresume

while(sum(sum(bw))>2 && get(handles.add,'Value') && ~get(handles.remove,'Value'))
    try
        
        if get(handles.freehand,'Value')==1
        roi_free=imfreehand;
        elseif get(handles.polygon,'Value')==1
        roi_free=impoly;
%         elseif get(handles.ellipse,'Value')==1
%         roi_free=imellipse;
        end
        
        coords=roi_free.getPosition;
        
        %%
        
%         if isfield(handles, 'current_mask')
        
        % binary mask of the new axon in zoomed image
        bw_added=poly2mask(coords(:,1),coords(:,2),size(handles.current_mask,1),size(handles.current_mask,2));
        
%         else
%             
%         bw=poly2mask(coords(:,1),coords(:,2),size(handles.bw_axonseg,1),size(handles.bw_axonseg,2));
%         
%         end
        
        %%
        roi_free.delete
    catch err
        break
    end
    

% bw_empty=zeros(size(handles.bw_axonseg,1),size(handles.bw_axonseg,2));

% if handles.zoom_value==1
%     bw=bw_zoom;
% else

% if isfield(handles, 'current_mask')
% bw(handles.mask_position(1):handles.mask_position(2),handles.mask_position(3):handles.mask_position(4))=bw_zoom;
% end

% end

% 
% bw_zoom=bw_zoom|bw_added;

handles.bw_axonseg(handles.mask_position(1):handles.mask_position(2),handles.mask_position(3):handles.mask_position(4))=...
    handles.bw_axonseg(handles.mask_position(1):handles.mask_position(2),handles.mask_position(3):handles.mask_position(4))|bw_added;

% handles.bw_axonseg=handles.bw_axonseg | bw;


% alpha_Callback(hObject, eventdata, handles)

guidata(hObject, handles);

if isfield(handles, 'current_mask')

length_y=handles.length_y;
length_x=handles.length_x;

display_img=handles.img(get(handles.slider_x,'Value')+1:get(handles.slider_x,'Value')+length_y,get(handles.slider_y,'Value')+1:get(handles.slider_y,'Value')+length_x);
display_mask=handles.bw_axonseg(get(handles.slider_x,'Value')+1:get(handles.slider_x,'Value')+length_y,get(handles.slider_y,'Value')+1:get(handles.slider_y,'Value')+length_x);
sc(get(handles.alpha,'Value')*sc(display_mask,'y',display_mask)+sc(display_img));

else
    
display_img=handles.img;
display_mask=handles.bw_axonseg;
sc(get(handles.alpha,'Value')*sc(display_mask,'y',display_mask)+sc(display_img));

end



end
set(handles.add,'Value',0)

guidata(hObject, handles);


% --- Executes on button press in remove.
function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume
BW2=bwmorph(handles.bw_axonseg,'shrink',3);
sc(handles.img,'r',BW2);
try
    handles.bw_axonseg=as_obj_remove(handles.bw_axonseg);
end
alpha_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strfind(handles.axsegfname,'.nii')
    save_nii_v2(handles.bw_axonseg,[sct_tool_remove_extension(handles.axsegfname,1) '_cor.nii.gz'],handles.axsegfname)
else
    [basename,~, ext]=sct_tool_remove_extension(handles.axsegfname,1);
    imwrite(handles.bw_axonseg,[basename '_cor' ext]);
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in show_grid.
function show_grid_Callback(hObject, eventdata, handles)
% hObject    handle to show_grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.show_grid,'Value')==1
    grid_size=3;    
    grid_row=round(length(handles.img2(:,1))/grid_size);
    grid_col=round(length(handles.img2(1,:))/grid_size);
    handles.img2(grid_row:grid_row:end,:,:)=255;       
    handles.img2(:,grid_col:grid_col:end,:)=255;       
    sc(get(handles.alpha,'Value')*sc(handles.bw_axonseg,'copper')+sc(handles.img2))
end
guidata(hObject, handles);


% 
% if handles.Grid ==1 
%     grid_size = 3;    
%     grid_row = round(length(handles.img2(:,1))/grid_size);
%     grid_col = round(length(handles.img2(1,:))/grid_size);
%     handles.img2(grid_row:grid_row:end,:,:) = 255;       %# creat 3x3 grid over image to facilitate segmentation process
%     handles.img2(:,grid_col:grid_col:end,:) = 255;       
%     sc(get(handles.alpha,'Value')*sc(handles.bw_axonseg,'copper')+sc(handles.img2))
% else
%     grid_size = 1;
%     sc(get(handles.alpha,'Value')*sc(handles.bw_axonseg,'copper')+sc(handles.img))
% end


% Hint: get(hObject,'Value') returns toggle state of show_grid


% --- Executes on button press in split.
function split_Callback(hObject, eventdata, handles)
% hObject    handle to split (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of split



function zoom_scale_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zoom_scale as text
%        str2double(get(hObject,'String')) returns contents of zoom_scale as a double

% Read zoom value entered by user
px_tmp=str2double(get(hObject,'String'));
if isnan(px_tmp) %if text --> put default value
    set(hObject,'String',num2str(get(hObject,'Value')));
else
    set(hObject,'Value',px_tmp);
end

handles.zoom_value=get(handles.zoom_scale,'Value');
zoom_val=handles.zoom_value;

length_y=round(size(handles.img,1)/zoom_val);
length_x=round(size(handles.img,2)/zoom_val);

handles.length_x=length_x;
handles.length_y=length_y;
  
% 
% display_img=handles.img(1:round(end/zoom_val),1:round(end/zoom_val));
% display_mask=handles.bw_axonseg(1:round(end/zoom_val),1:round(end/zoom_val));
% 


% sc(get(handles.alpha,'Value')*sc(display_mask,'copper')+sc(display_img));


% set 2 sliders x and y


if zoom_val>1

set(handles.slider_x, 'Visible','on');
set(handles.slider_y, 'Visible','on');
set(handles.text3, 'Visible','on');
set(handles.text4, 'Visible','on');

set(handles.slider_x,'Max',size(handles.img,1)-length_y);
set(handles.slider_x, 'SliderStep', [1/(size(handles.img,1)-length_y) , 20/(size(handles.img,1)-length_y) ]);   
set(handles.slider_x,'Value',0);

set(handles.slider_y,'Max',size(handles.img,2)-length_x);
set(handles.slider_y, 'SliderStep', [1/(size(handles.img,2)-length_x) , 20/(size(handles.img,2)-length_x) ]);   
set(handles.slider_y,'Value',0);

update_display(hObject, eventdata, handles);

else
    
set(handles.slider_x, 'Visible','off');
set(handles.slider_y, 'Visible','off');
set(handles.text3, 'Visible','off');
set(handles.text4, 'Visible','off');
    
display_img=handles.img;
display_mask=handles.bw_axonseg;
sc(get(handles.alpha,'Value')*sc(display_mask,'y',display_mask)+sc(display_img));
    
end

% handles.current_img=display_img;
% handles.current_mask=display_mask;

% handles.mask_position=[get(handles.slider_x,'Value')+1,get(handles.slider_x,'Value')+length_x,get(handles.slider_y,'Value')+1,get(handles.slider_y,'Value')+length_y];




guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function zoom_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zoom_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_x_Callback(hObject, eventdata, handles)
% hObject    handle to slider_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

update_display(hObject, eventdata, handles);

% --- Executes on slider movement.
function slider_y_Callback(hObject, eventdata, handles)
% hObject    handle to slider_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

update_display(hObject, eventdata, handles);



% --- Executes during object creation, after setting all properties.
function slider_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function slider_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function update_display(hObject, eventdata, handles)

length_y=handles.length_y;
length_x=handles.length_x;

display_img=handles.img(get(handles.slider_x,'Value')+1:get(handles.slider_x,'Value')+length_y,get(handles.slider_y,'Value')+1:get(handles.slider_y,'Value')+length_x);
display_mask=handles.bw_axonseg(get(handles.slider_x,'Value')+1:get(handles.slider_x,'Value')+length_y,get(handles.slider_y,'Value')+1:get(handles.slider_y,'Value')+length_x);
sc(get(handles.alpha,'Value')*sc(display_mask,'y',display_mask)+sc(display_img));

handles.current_img=display_img;
handles.current_mask=display_mask;

handles.mask_position=[get(handles.slider_x,'Value')+1,get(handles.slider_x,'Value')+length_y,get(handles.slider_y,'Value')+1,get(handles.slider_y,'Value')+length_x];
% handles.mask_position=[get(handles.slider_y,'Value')+1,get(handles.slider_y,'Value')+length_y,get(handles.slider_x,'Value')+1,get(handles.slider_x,'Value')+length_x];

guidata(hObject, handles);


% --- Executes on button press in reset_mask.
function reset_mask_Callback(hObject, eventdata, handles)
% hObject    handle to reset_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aaa=logical(zeros(size(handles.bw_axonseg,1),size(handles.bw_axonseg,2)));
handles.bw_axonseg=aaa;



guidata(hObject, handles);