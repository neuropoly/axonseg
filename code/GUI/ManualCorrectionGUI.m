function varargout = ManualCorrectionGUI(varargin)
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

% Last Modified by GUIDE v2.5 23-Sep-2015 14:59:36

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
if strfind(varargin{1},'.nii')
    handles.img = load_nii_data(varargin{1});
else
    handles.img = imread(varargin{1});
end
handles.img=adapthisteq(handles.img);

handles.axsegfname=varargin{2};
if strfind(handles.axsegfname,'.nii')
    handles.bw_axonseg = load_nii_data(handles.axsegfname);
else
    handles.bw_axonseg = imread(handles.axsegfname);
end
axes(handles.axes1)
sc(get(handles.alpha,'Value')*sc(handles.bw_axonseg,'copper')+sc(handles.img))

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


% --- Executes on slider movement.
function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
axes(handles.axes1)
sc(get(handles.alpha,'Value')*sc(handles.bw_axonseg,'copper')+sc(handles.img))
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
bw = 4;
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
        bw=poly2mask(coords(:,1),coords(:,2),size(handles.bw_axonseg,1),size(handles.bw_axonseg,2));
        roi_free.delete
    catch err
        break
    end
handles.bw_axonseg=handles.bw_axonseg | bw;
alpha_Callback(hObject, eventdata, handles)
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
