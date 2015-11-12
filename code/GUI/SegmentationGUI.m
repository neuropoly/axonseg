function varargout = SegmentationGUI(varargin)
%SEGMENTATIONGUI M-file for SegmentationGUI.fig
%      SEGMENTATIONGUI, by itself, creates a new SEGMENTATIONGUI or raises the existing
%      singleton*.
%
%      H = SEGMENTATIONGUI returns the handle to a new SEGMENTATIONGUI or the handle to
%      the existing singleton*.
%
%      SEGMENTATIONGUI('Property','Value',...) creates a new SEGMENTATIONGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to SegmentationGUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SEGMENTATIONGUI('CALLBACK') and SEGMENTATIONGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SEGMENTATIONGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SegmentationGUI

% Last Modified by GUIDE v2.5 12-Nov-2015 13:40:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SegmentationGUI_OpeningFcn, ...
    'gui_OutputFcn',  @SegmentationGUI_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if ~nargin
    FileName= uigetimagefile;
    varargin{1}=FileName;
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SegmentationGUI is made visible.
function SegmentationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for SegmentationGUI
if isempty(varargin)
handles.varargin = uigetfile;
end

handles.output = hObject;
handles.varargin=varargin{1};
handles.outputdir=fileparts(handles.varargin); if isempty(handles.outputdir), handles.outputdir='./'; else handles.outputdir = [handles.outputdir, filesep]; end
if ~isfield(handles,'data') || ~isfield(handles.data,'raw')
    handles.data.raw=imread(handles.varargin);
end
handles.data.img=handles.data.raw;

if length(size(handles.data.img))==3
    handles.data.img=rgb2gray(handles.data.img(:,:,1:3));
end
axes(handles.plotseg);

handles.reducefactor=max(1,floor(size(handles.data.img,1)/1000));
imshow(handles.data.img(1:handles.reducefactor:end,1:handles.reducefactor:end));

% set some default parameters
set(handles.histEq,'Value',0);
set(handles.Transparency,'Value',0.7);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SegmentationGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SegmentationGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function PixelSize_Callback(hObject, eventdata, handles)
% hObject    handle to PixelSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PixelSize as text
%        str2double(get(hObject,'String')) returns contents of PixelSize as a double
px_tmp=str2double(get(hObject,'String'));
if isnan(px_tmp) %if text --> put default value
    set(hObject,'String',num2str(get(hObject,'Value')));
else
    set(hObject,'Value',px_tmp);
end


% --- Executes during object creation, after setting all properties.
function PixelSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PixelSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in cropImage.
function cropImage_Callback(hObject, eventdata, handles)
% hObject    handle to cropImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.img=as_improc_cutFromRect(handles.data.img, handles.reducefactor);
axes(handles.plotseg);
handles.reducefactor=max(1,floor(size(handles.data.img,1)/1000));   % Max 1000 pixels size set for imshow
imshow(handles.data.img(1:handles.reducefactor:end,1:handles.reducefactor:end));
guidata(hObject, handles);


% --- Executes on button press in invertColor.
function handles=invertColor_Callback(hObject, eventdata, handles)
% hObject    handle to invertColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% handles.state.invertColor=get(handles.invertColor,'Value');
axes(handles.plotseg);
imshow(imcomplement(handles.data.img(1:handles.reducefactor:end,1:handles.reducefactor:end)));

guidata(hObject, handles);


% --- Executes on button press in histEq.
function handles=histEq_Callback(hObject, eventdata, handles)
% hObject    handle to histEq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% handles.state.histEq=get(handles.histEq,'Value');
if get(handles.histEq,'Value'), tmp=histeq(handles.data.img,1); else tmp=handles.data.img; end

axes(handles.plotseg)
imshow(tmp(1:handles.reducefactor:end,1:handles.reducefactor:end));
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of histEq
    


% --- Executes on slider movement.
function Deconv_Callback(hObject, eventdata, handles)
% hObject    handle to Deconv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



fprintf('*** Warning *** : Computing deconvolution. This may take time. \n');

tic;
set(handles.Deconv,'Value',round(get(handles.Deconv,'Value'))); % ensure int
if get(handles.histEq,'Value'), tmp=histeq(handles.data.img,1); else tmp=handles.data.img; end
tmp=Deconv(tmp,get(handles.Deconv,'Value'));
axes(handles.plotseg)
imshow(tmp)

toc;

guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider



% --- Executes on button press in roi_add.
function roi_add_Callback(hObject, eventdata, handles)
% hObject    handle to roi_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~, roi]=as_tools_getroi(handles.data.img);
handles.data.img(~roi)=0;
axes(handles.plotseg)
imshow(handles.data.img(1:handles.reducefactor:end,1:handles.reducefactor:end));
guidata(hObject, handles);



% --- Executes on button press in cut_greymatter.
function roi_substract_Callback(hObject, eventdata, handles)
% hObject    handle to cut_greymatter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~, roi]=as_tools_getroi(handles.data.img);
handles.data.img(roi)=0;
axes(handles.plotseg)
imshow(handles.data.img(1:handles.reducefactor:end,1:handles.reducefactor:end));
guidata(hObject, handles);




% --- Executes on button press in Go_0_to_1.
function Go_0_to_1_Callback(hObject, eventdata, handles)
% hObject    handle to Go_0_to_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.Step1=handles.data.img;

if get(handles.invertColor,'Value'), handles.data.Step1=imcomplement(handles.data.Step1); end
if get(handles.Smoothing,'Value'), handles.data.Step1=as_gaussian_smoothing(handles.data.Step1); end


% handles.data.Step1=imcomplement(handles.data.img);
handles.data.Step1=Deconv(handles.data.Step1,get(handles.Deconv,'Value'));

% handles.state.histEq=get(handles.histEq,'Value');
if get(handles.histEq,'Value'), handles.data.Step1=histeq(handles.data.Step1,get(handles.histEq,'Value')); end
imshow(handles.data.Step1(1:handles.reducefactor:end,1:handles.reducefactor:end))

%--------------------------------------------------------------------------

% if get(handles.LevelSet_check,'Value')==1
%     set(handles.initSeg, 'Visible', 'off');
%     set(handles.diffMaxMin, 'Visible', 'off');
%     set(handles.threshold, 'Visible', 'off');
% 
% end


%--------------------------------------------------------------------------



set(handles.uipanel1, 'Visible', 'on')
set(handles.uipanel0, 'Visible', 'off')
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Deconv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Deconv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in resetStep0.
function resetStep0_Callback(hObject, eventdata, handles)
% hObject    handle to resetStep0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SegmentationGUI_OpeningFcn(hObject, eventdata, handles, handles.varargin)

% --- Executes on button press in Go_1_to_2.
function Go_1_to_2_Callback(hObject, eventdata, handles)
% hObject    handle to Go_1_to_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

%--------------------------------------------------------------------------
if get(handles.LevelSet_step1,'Value')==1
%     test=double(handles.data.Step1);
    handles.data.Step2_seg=as_LevelSet_method(handles.data.Step1); 
   
else
    
handles.data.Step2_seg=step1(handles.data.Step1,get(handles.initSeg,'Value'), get(handles.diffMaxMin,'Value'), get(handles.threshold,'Value'));    

end
%--------------------------------------------------------------------------
axes(handles.plotseg)

sc(get(handles.Transparency,'Value')*sc(handles.data.Step2_seg,'y',handles.data.Step2_seg)+sc(handles.data.Step1));
% sc(sc(handles.data.Step1)+sc(handles.data.Step2_seg,'y',handles.data.Step2_seg));

% imshow(imfuse(handles.data.Step1,handles.data.Step2_seg))
guidata(hObject, handles);
fprintf('Step 1 Done \n');

set(handles.uipanel2, 'Visible', 'on')
set(handles.uipanel1, 'Visible', 'off')

guidata(hObject, handles);


% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in resetStep1.
function resetStep1_Callback(hObject, eventdata, handles)
% hObject    handle to resetStep1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% warndlg('Reseting Step 1 will erase segmentation parameters previously defined','Warning');
fprintf('*** WARNING *** Reseting Step 1 will erase segmentation parameters previously defined.');

axes(handles.plotseg);
imshow(handles.data.img);

set(handles.uipanel0, 'Visible', 'on')
set(handles.uipanel1, 'Visible', 'off')
guidata(hObject, handles);


% --- Executes on slider movement.
function initSeg_Callback(hObject, eventdata, handles)
% hObject    handle to initSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--------------------------------------------------------------------------
tmp=initseg(handles.data.Step1, get(handles.initSeg,'Value'));
tmp=imfill(tmp,'holes'); %imshow(initialBW)

%--------------------------------------------------------------------------
axes(handles.plotseg)

sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1));
% imshow(imfuse(handles.data.Step1,tmp))
guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min')  and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function initSeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Function initseg that 
function im_out=initseg(im_in,heigthThresh)

% im_out1 = imextendedmin(im_in,distThresh);
% im_out2 = imextendedmin(im_in,distThresh-5);
% im_out3 = imextendedmin(im_in,distThresh+5);
% im_out=im_out1 | im_out2 | im_out3;
% im_out=adaptivethreshold(im_in,7,distThresh);

% Performs initial segmentation of axons & outputs the resulting image
% (binary image with axon separation vs background)
[im_out, handles.data.initialRejectBW] = axonInitialSegmentation(im_in, heigthThresh);


% --- Executes when user moves the diffmaxMin slider
function diffMaxMin_Callback(hObject, eventdata, handles)
% hObject    handle to diffMaxMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Perform initial segmentation of the axons based on diffMaxMin value
tmp=initseg(handles.data.Step1, get(handles.diffMaxMin,'Value'));

% Show updated axon segmentation on screen
axes(handles.plotseg);
sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1));
% imshow(imfuse(handles.data.Step1,tmp));

% Update handles
guidata(hObject, handles);



% --- Executes on slider movement.
function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


tmp=handles.data.Step1<prctile(handles.data.Step1(:),100*get(handles.threshold,'Value'));
tmp=bwmorph(tmp,'fill'); tmp=bwmorph(tmp,'close'); tmp=bwmorph(tmp,'hbreak'); tmp = bwareaopen(tmp,5); %imshow(tmp)

sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1));
% imshow(imfuse(handles.data.Step1,tmp));



% --- Executes on button press in Go_2_to_3.
function Go_2_to_3_Callback(hObject, eventdata, handles)
% hObject    handle to Go_2_to_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% handles.state.minSize=get(handles.minSize,'Value');
% handles.state.Circularity=get(handles.Circularity,'Value');
% handles.state.Solidity=get(handles.Solidity,'Value');

% DO SAVE HERE FOR INITIAL SEG IMAGE---------------------------------------




handles.data.Step3_seg=step2(handles.data.Step2_seg, get(handles.minSize,'Value'), get(handles.Circularity,'Value'), ...
    get(handles.Solidity,'Value'), get(handles.ellipRatio,'Value'), get(handles.MinorAxis,'Value'), ...
    get(handles.MajorAxis,'Value'));

% DO SAVE HERE FOR INITIAL SEG IMAGE---------------------------------------
handles.data.DA_final = handles.data.Step3_seg;
% DO SAVE HERE FOR INITIAL SEG IMAGE---------------------------------------



axes(handles.plotseg)

sc(get(handles.Transparency,'Value')*sc(handles.data.Step3_seg,'y',handles.data.Step3_seg)+sc(handles.data.Step1));
% imshow(imfuse(handles.data.Step1,handles.data.Step3_seg))

% Segmentation parameters to save for future use (full image seg.)---------

handles.segParam.invertColor=get(handles.invertColor,'Value');
handles.segParam.histEq=get(handles.histEq,'Value');
handles.segParam.Deconv=get(handles.Deconv,'Value');
handles.segParam.Smoothing=get(handles.Smoothing,'Value');

handles.segParam.LevelSet=get(handles.LevelSet_step1,'Value');

handles.segParam.initSeg=get(handles.initSeg,'Value');
handles.segParam.diffMaxMin=get(handles.diffMaxMin,'Value');
handles.segParam.threshold=get(handles.threshold,'Value');

handles.segParam.minSize=get(handles.minSize,'Value');
handles.segParam.Circularity=get(handles.Circularity,'Value');
handles.segParam.Solidity=get(handles.Solidity,'Value');

handles.segParam.ellipRatio=get(handles.ellipRatio,'Value');
handles.segParam.MinorAxis=get(handles.MinorAxis,'Value');
handles.segParam.MajorAxis=get(handles.MajorAxis,'Value');

% handles.segParam.parameters=get(handles.parameters,'Value');
% handles.segParam.DA_classifier=get(handles.DA_classifier,'Value');


SegParameters=handles.segParam; 
PixelSize=get(handles.PixelSize,'Value');


save([handles.outputdir 'SegParameters.mat'], 'SegParameters', 'PixelSize');

fprintf('Step 2 Done \n');

set(handles.uipanel3, 'Visible', 'on');
set(handles.uipanel2, 'Visible', 'off');

guidata(hObject, handles);


% --- Executes on button press in resetStep2.
function resetStep2_Callback(hObject, eventdata, handles)
% hObject    handle to resetStep2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.plotseg);

sc(get(handles.Transparency,'Value')*sc(handles.data.Step2_seg,'y',handles.data.Step2_seg)+sc(handles.data.Step1));
% imshow(imfuse(handles.data.Step1,handles.data.Step2_seg));
set(handles.uipanel1, 'Visible', 'on')
set(handles.uipanel2, 'Visible', 'off')
guidata(hObject, handles);


% --- Executes on button press in PixelSize_button.
function PixelSize_button_Callback(hObject, eventdata, handles)
% hObject    handle to PixelSize_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PixelSize=as_improc_pixelsize/handles.reducefactor;
if PixelSize
    set(handles.PixelSize,'String',PixelSize);
    set(handles.PixelSize,'Value',PixelSize);
end

guidata(hObject, handles);


% --- Executes on slider movement.
function circularity_Callback(hObject, eventdata, handles)
% hObject    handle to circularity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=circTest(handles.data.Step2_seg,get(handles.circularity,'Value'));
axes(handles.plotseg)

imshowpair(sc(get(handles.Transparency,'Value')*sc(handles.data.Step2_seg,'y',handles.data.Step2_seg)+sc(handles.data.Step1)),sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1)),'montage');
% imshowpair(imfuse(handles.data.Step1,handles.data.Step2_seg),imfuse(handles.data.Step1,tmp),'montage')
guidata(hObject, handles);





% --- Executes during object creation, after setting all properties.
function circularity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to circularity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes during object creation, after setting all properties.
function diffMaxMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diffMaxMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function maxSize_Callback(hObject, eventdata, handles)
% hObject    handle to maxSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handle.data.proc=maxSize(handles.data.Step2_seg,get(handles.maxSize,'Value'));
axes(handles.plotseg)

imshowpair(sc(get(handles.Transparency,'Value')*sc(handles.data.Step2_seg,'y',handles.data.Step2_seg)+sc(handles.data.Step1)),sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1)),'montage');
% imshowpair(imfuse(handles.data.Step1,handles.data.Step2_seg),imfuse(handles.data.Step1,tmp),'montage')
guidata(hObject, handles);

function im_out=maxSize(im_in,sizeMax)
eqDiam=regionprops(im_in,'EquivDiameter');
rm=find([eqDiam.EquivDiameter]<sizeMax);

[axonLabel, numAxon] = bwlabel(im_in);
im_out(ismember(axonLabel,rm))=false;


function maxSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Circularity_Callback(hObject, eventdata, handles)
% hObject    handle to Circularity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Only select axons that validate the circularity criterion defined by user
tmp = axonValidateCircularity(handles.data.Step2_seg, get(handles.Circularity,'Value'));

% Show side-by-side segmentation obtained after step 2 VS segmentation
% corrected by the circularity criterion
axes(handles.plotseg)

imshowpair(sc(get(handles.Transparency,'Value')*sc(handles.data.Step2_seg,'y',handles.data.Step2_seg)+sc(handles.data.Step1)),sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1)),'montage');
% imshowpair(imfuse(handles.data.Step1,handles.data.Step2_seg),imfuse(handles.data.Step1,tmp),'montage')

% handles.state.Circularity = get(handles.Circularity,'Value'); 

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Circularity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Circularity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function im_out=circTest(im_in,Circ)
im_out = axonValidateCircularity(im_in, Circ);


% --- Executes on slider movement.
function Solidity_Callback(hObject, eventdata, handles)
% hObject    handle to Solidity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


tmp=solidityTest(handles.data.Step2_seg,get(handles.Solidity,'Value'));

% handles.state.Solidity = get(handles.Solidity,'Value'); % ajoutee

axes(handles.plotseg)
imshowpair(sc(get(handles.Transparency,'Value')*sc(handles.data.Step2_seg,'y',handles.data.Step2_seg)+sc(handles.data.Step1)),sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1)),'montage');
% imshowpair(imfuse(handles.data.Step1,handles.data.Step2_seg),imfuse(handles.data.Step1,tmp),'montage')
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Solidity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Solidity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





% --- Executes on slider movement.
function minSize_Callback(hObject, eventdata, handles)
% hObject    handle to minSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=sizeTest(handles.data.Step2_seg,get(handles.minSize,'Value'));

% handles.state.minSize = get(handles.minSize,'Value'); % ajoutee


axes(handles.plotseg)

imshowpair(sc(get(handles.Transparency,'Value')*sc(handles.data.Step2_seg,'y',handles.data.Step2_seg)+sc(handles.data.Step1)),sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1)),'montage');
% imshowpair(imfuse(handles.data.Step1,handles.data.Step2_seg),imfuse(handles.data.Step1,tmp),'montage')
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function minSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





% --- Executes on button press in Add.
function Add_Callback(hObject, eventdata, handles)
% hObject    handle to Add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.plotseg)

imshow(sc(get(handles.Transparency,'Value')*sc(handles.data.Step3_seg,'y',handles.data.Step3_seg)+sc(handles.data.Step1)));
% imshow(imfuse(handles.data.Step1,handles.data.Step3_seg));
manualBW=as_axonSeg_manual;
handles.data.Step3_seg = manualBW | handles.data.Step3_seg;

% IMAGE FOR DA ------------------------------------------------------------

handles.data.DA_final = handles.data.Step3_seg;

%--------------------------------------------------------------------------

guidata(hObject, handles);
imshow(sc(get(handles.Transparency,'Value')*sc(handles.data.Step3_seg,'y',handles.data.Step3_seg)+sc(handles.data.Step1)));
% imshow(imfuse(handles.data.Step1, handles.data.Step3_seg));

guidata(hObject, handles);




% --- Executes on button press in remove.
function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.plotseg)

imshow(sc(get(handles.Transparency,'Value')*sc(handles.data.Step3_seg,'y',handles.data.Step3_seg)+sc(handles.data.Step1)));
% imshow(imfuse(handles.data.Step1,handles.data.Step3_seg));

[Label, numAxonObj]  = bwlabel(handles.data.Step3_seg);
[c,r,~] = impixel;
rm=diag(Label(r,c));
handles.data.Step3_seg=~ismember(Label,[0;rm]);

% IMAGE FOR DA ------------------------------------------------------------

handles.data.DA_final = handles.data.Step3_seg;

%--------------------------------------------------------------------------

guidata(hObject, handles);
imshow(sc(get(handles.Transparency,'Value')*sc(handles.data.Step3_seg,'y',handles.data.Step3_seg)+sc(handles.data.Step1)));
% imshow(imfuse(handles.data.Step1,handles.data.Step3_seg));

guidata(hObject, handles);


% --- Executes on button press in resetStep3.
function resetStep3_Callback(hObject, eventdata, handles)
% hObject    handle to resetStep3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.panel_select_ROC, 'Visible','off');
set(handles.ROC_panel, 'Visible','off');
set(handles.ROC_curve, 'Visible','off');
cla(handles.ROC_curve);

set(handles.uipanel2, 'Visible', 'on')
set(handles.uipanel3, 'Visible', 'off')
axes(handles.plotseg)

imshow(sc(get(handles.Transparency,'Value')*sc(handles.data.Step2_seg,'y',handles.data.Step2_seg)+sc(handles.data.Step1)));
% imshow(imfuse(handles.data.Step1,handles.data.Step2_seg));



% --- Executes on button press in MyelinSeg.
function MyelinSeg_Callback(hObject, eventdata, handles)
% hObject    handle to MyelinSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Launch Seg

set(handles.panel_select_ROC, 'Visible','off');
set(handles.ROC_panel, 'Visible','off');
set(handles.ROC_curve, 'Visible','off');
cla(handles.ROC_curve);

tmp=RemoveBorder(handles.data.Step3_seg);
backBW=handles.data.Step3_seg & ~tmp;
[handles.data.seg] = myelinInitialSegmention(handles.data.Step1, tmp, backBW,0,1);
handles.data.seg = myelinCleanConflict(handles.data.seg,1,0.5);

handles.data.Step3_seg = as_myelinseg_to_axonseg(handles.data.seg);

axes(handles.plotseg);
sc(sc(handles.data.Step1)+sc(sum(handles.data.seg,3),'copper'));

handles.data.labelseg=zeros(size(handles.data.seg,1), size(handles.data.seg,2));
for i=1:size(handles.data.seg,3)
    handles.data.labelseg(logical(handles.data.seg(:,:,i)))=i;
end



%% SAVE
savedir=[handles.outputdir 'results_croped' filesep];
mkdir(savedir);
% axonlist structure
axonlist=as_myelinseg2axonlist(handles.data.seg,get(handles.PixelSize,'Value'));
PixelSize = handles.PixelSize;
img=handles.data.img;
save([savedir, 'axonlist.mat'], 'axonlist', 'img', 'PixelSize','-v7.3');

% excel
handles.stats = as_stats(handles.data.seg,get(handles.PixelSize,'Value'));
handles.stats = struct2table(handles.stats);
writetable(handles.stats,[savedir 'Stats.csv'])

% AxonDiameter Labelled
AxCaliberLabelled=as_display_label(axonlist,size(handles.data.img),'axonEquivDiameter');
imwrite(sc(sc(handles.data.img)+sc(AxCaliberLabelled,'Hot')),[savedir 'Seg_labelled.jpg']);

%--------------------------------------------------------------------------

imwrite(handles.data.Step1,[savedir 'AxonSeg_step1.jpg']);
imwrite(handles.data.Step2_seg,[savedir 'AxonSeg_step2.jpg']);
imwrite(handles.data.Step3_seg,[savedir 'AxonSeg_step3.jpg']);
% imwrite(handles.data.DA, [savedir 'AxonSeg_DA.jpg']);
imwrite(handles.data.DA_final, [savedir 'AxonSeg_DA_final.jpg']);

%--------------------------------------------------------------------------


guidata(hObject, handles);



% --- Executes on button press in go_full_image.
function go_full_image_Callback(hObject, eventdata, handles)
% hObject    handle to go_full_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.panel_select_ROC, 'Visible','off');
set(handles.ROC_panel, 'Visible','off');
set(handles.ROC_curve, 'Visible','off');
cla(handles.ROC_curve);

blocksize=1500;
overlap=100;
savedir=[handles.outputdir, 'results_full', filesep];
mkdir(savedir);
as_Segmentation_full_image(handles.varargin,[handles.outputdir 'SegParameters.mat'],blocksize,overlap,savedir);


% --- Executes during object creation, after setting all properties.
function text20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes during object creation, after setting all properties.
function threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text20.
function text20_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in LoadSegParam.
function LoadSegParam_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSegParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Select segmentation parameters file to load

[FileName,PathName,FilterIndex] = uigetfile('*.mat*','Select the segmentation parameters you want to use');
segparam_filepath = [PathName FileName];
load(segparam_filepath);

% % Disable buttons in step 0 to keep only the segmentation parameters loaded
% 
% set(handles.invertColor,'Enable','off');
% set(handles.histEq,'Enable','off');
% set(handles.Deconv,'Enable','off');


% Get parameters from a SegParameters file
set(handles.invertColor,'Value',SegParameters.invertColor);
set(handles.histEq,'Value',SegParameters.histEq);
set(handles.Deconv,'Value',SegParameters.Deconv);
set(handles.Smoothing,'Value',SegParameters.Smoothing);

handles.segParam.LevelSet=get(handles.LevelSet_step1,'Value');

set(handles.initSeg,'Value',SegParameters.initSeg);
set(handles.diffMaxMin,'Value',SegParameters.diffMaxMin);
set(handles.threshold,'Value',SegParameters.threshold);

set(handles.minSize,'Value',SegParameters.minSize);
set(handles.Circularity,'Value',SegParameters.Circularity);
set(handles.Solidity,'Value',SegParameters.Solidity);

set(handles.ellipRatio,'Value',SegParameters.ellipRatio);
set(handles.MinorAxis,'Value',SegParameters.MinorAxis);
set(handles.MajorAxis,'Value',SegParameters.MajorAxis);

% Update handles
guidata(hObject,handles);


% % --- Executes on button press in LevelSetSeg.
% function LevelSetSeg_Callback(hObject, eventdata, handles)
% % hObject    handle to LevelSetSeg (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% tic
% tmp=as_LevelSet_method(handles.data.Step1);
% toc
% tmp=imfill(tmp,'holes'); %imshow(initialBW)
% 
% axes(handles.plotseg)
% 
% imshow(sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1)));
% % imshow(imfuse(handles.data.Step1,tmp))
% % imshow(tmp)
% guidata(hObject, handles);




% --- Executes on slider movement.
function ellipRatio_Callback(hObject, eventdata, handles)
% hObject    handle to ellipRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Only select axons that validate the circularity criterion defined by user
tmp = axonValidateEllipsity(handles.data.Step2_seg, get(handles.ellipRatio,'Value'));

% Show side-by-side segmentation obtained after step 2 VS segmentation
% corrected by the circularity criterion
axes(handles.plotseg)

imshowpair(sc(get(handles.Transparency,'Value')*sc(handles.data.Step2_seg,'y',handles.data.Step2_seg)+sc(handles.data.Step1)),sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1)),'montage');

% imshowpair(imfuse(handles.data.Step1,handles.data.Step2_seg),imfuse(handles.data.Step1,tmp),'montage')

% handles.state.Circularity = get(handles.Circularity,'Value'); 

guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function ellipRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ellipRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function MinorAxis_Callback(hObject, eventdata, handles)
% hObject    handle to MinorAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Only select axons that validate the circularity criterion defined by user
tmp = axonValidateMinorAxis(handles.data.Step2_seg, get(handles.MinorAxis,'Value'));

% Show side-by-side segmentation obtained after step 2 VS segmentation
% corrected by the circularity criterion
axes(handles.plotseg)

imshowpair(sc(get(handles.Transparency,'Value')*sc(handles.data.Step2_seg,'y',handles.data.Step2_seg)+sc(handles.data.Step1)),sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1)),'montage');

% imshowpair(imfuse(handles.data.Step1,handles.data.Step2_seg),imfuse(handles.data.Step1,tmp),'montage')

% handles.state.Circularity = get(handles.Circularity,'Value'); 

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function MinorAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinorAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function MajorAxis_Callback(hObject, eventdata, handles)
% hObject    handle to MajorAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Only select axons that validate the circularity criterion defined by user
tmp = axonValidateMajorAxis(handles.data.Step2_seg, get(handles.MajorAxis,'Value'));

% Show side-by-side segmentation obtained after step 2 VS segmentation
% corrected by the circularity criterion
axes(handles.plotseg)

imshowpair(sc(get(handles.Transparency,'Value')*sc(handles.data.Step2_seg,'y',handles.data.Step2_seg)+sc(handles.data.Step1)),sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1)),'montage');

% imshowpair(imfuse(handles.data.Step1,handles.data.Step2_seg),imfuse(handles.data.Step1,tmp),'montage')

% handles.state.Circularity = get(handles.Circularity,'Value'); 

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function MajorAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MajorAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in DiscriminantAnalysis.
function DiscriminantAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to DiscriminantAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



if get(handles.Linear,'Value')
    type = 'linear';
else
    type = 'quadratic';
end

   
[~, ~, ~, ~, ~, ~, ~,ROC_values] = ...
    as_axonseg_validate(handles.data.Step2_seg,handles.data.DA_final,{'Perimeter', 'EquivDiameter', 'Solidity', 'MajorAxisLength', 'MinorAxisLength','Eccentricity','ConvexArea','Orientation','Extent','FilledArea'},type,1);


%--- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

[~,best_indexes]=as_find_max_ROC_metrics(ROC_values);

if get(handles.Precision,'Value') && ~get(handles.Accuracy,'Value')

    sensitivity_to_use=ROC_values(best_indexes(1),1);
    set(handles.Enter_sensitivity,'Value',sensitivity_to_use);

elseif ~get(handles.Precision,'Value') && get(handles.Accuracy,'Value')     
    
    sensitivity_to_use=ROC_values(best_indexes(2),1);
    set(handles.Enter_sensitivity,'Value',sensitivity_to_use);

end   

%--- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

[~, Accepted_axons_img, classifier_final, Classification, ~, ~, parameters,~] = ...
    as_axonseg_validate(handles.data.Step2_seg,handles.data.DA_final,{'Perimeter', 'EquivDiameter', 'Solidity', 'MajorAxisLength', 'MinorAxisLength','Eccentricity','ConvexArea','Orientation','Extent','FilledArea'},type,get(handles.Enter_sensitivity,'Value'));





% Plot ROC curve

axes(handles.ROC_curve);
as_plot_ROC_curve_DA(ROC_values);

% Get sensitivity to use for discriminant analysis

% [selected_x, selected_y] = getpts(handles.ROC_curve);
% [selected_x, selected_y] = ginput(1);
% CP = get(gca, 'CurrentPoint');
% x  = CP(1);
% y  = CP(2);

% handles.parameters = parameters;

handles.data.Step3_seg = Accepted_axons_img;

% handles.DA_classifier = classifier_final;

handles.segParam.invertColor=get(handles.invertColor,'Value');
handles.segParam.histEq=get(handles.histEq,'Value');
handles.segParam.Deconv=get(handles.Deconv,'Value');
handles.segParam.Smoothing=get(handles.Smoothing,'Value');

handles.segParam.LevelSet=get(handles.LevelSet_step1,'Value');

handles.segParam.initSeg=get(handles.initSeg,'Value');
handles.segParam.diffMaxMin=get(handles.diffMaxMin,'Value');
handles.segParam.threshold=get(handles.threshold,'Value');

handles.segParam.minSize=get(handles.minSize,'Value');
handles.segParam.Circularity=get(handles.Circularity,'Value');
handles.segParam.Solidity=get(handles.Solidity,'Value');

handles.segParam.ellipRatio=get(handles.ellipRatio,'Value');
handles.segParam.MinorAxis=get(handles.MinorAxis,'Value');
handles.segParam.MajorAxis=get(handles.MajorAxis,'Value');

handles.segParam.parameters=parameters;
handles.segParam.DA_classifier=classifier_final;


SegParameters=handles.segParam; 
PixelSize=get(handles.PixelSize,'Value');

save([handles.outputdir 'SegParameters.mat'], 'SegParameters', 'PixelSize');

%--------------------------------------------------------------------------

[ROC_stats] = ROC_calculate(Classification);

set(handles.Sensitivity,'String',num2str(ROC_stats(1)));
set(handles.Specificity,'String',num2str(ROC_stats(2)));

set(handles.ROC_panel, 'Visible','on');
set(handles.ROC_curve, 'Visible','on');
set(handles.panel_select_ROC, 'Visible','on');
%--------------------------------------------------------------------------


guidata(hObject,handles);


% --- Executes on button press in Smoothing.
function Smoothing_Callback(hObject, eventdata, handles)
% hObject    handle to Smoothing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject,handles);
axes(handles.plotseg);

imshow(as_gaussian_smoothing(handles.data.img));



guidata(hObject,handles);


% --- Executes on button press in LevelSet_step1.
function LevelSet_step1_Callback(hObject, eventdata, handles)
% hObject    handle to LevelSet_step1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LevelSet_step1

tmp=as_LevelSet_method(handles.data.Step1);

axes(handles.plotseg);

imshow(sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1)));

% imshow(imfuse(handles.data.Step1,handles.data.Step2_seg));

guidata(hObject,handles);


% --- Executes on slider movement.
function Transparency_Callback(hObject, eventdata, handles)
% hObject    handle to Transparency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Transparency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Transparency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in remove_concavity.
function remove_concavity_Callback(hObject, eventdata, handles)
% hObject    handle to remove_concavity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.plotseg);

imshow(sc(get(handles.Transparency,'Value')*sc(handles.data.Step3_seg,'y',handles.data.Step3_seg)+sc(handles.data.Step1)));
% imshow(imfuse(handles.data.Step1,handles.data.Step3_seg));

CH_total = bwconvhull(handles.data.Step3_seg, 'objects', 8);

[Label, ~]  = bwlabel(CH_total);
[c,r,~] = impixel;

rm=diag(Label(r,c));
CH_others=~ismember(Label,[0;rm]);

CH_object=im2bw(CH_total-CH_others);
handles.data.Step3_seg=im2bw(handles.data.Step3_seg+CH_object);

% IMAGE FOR DA ------------------------------------------------------------

handles.data.DA_final = handles.data.Step3_seg;

%---------------------------UPDATE STEP2 WITH CONVEX FORMS (FOR DA)--------


handles.data.Step2_seg = im2bw(handles.data.Step2_seg+CH_object);


%---------------------------UPDATE STEP2 WITH CONVEX FORMS (FOR DA)--------


guidata(hObject, handles);
imshow(sc(get(handles.Transparency,'Value')*sc(handles.data.Step3_seg,'y',handles.data.Step3_seg)+sc(handles.data.Step1)));
% imshow(imfuse(handles.data.Step1,handles.data.Step3_seg));

guidata(hObject,handles);


% --- Executes on button press in Precision.
function Precision_Callback(hObject, eventdata, handles)
% hObject    handle to Precision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Precision
guidata(hObject,handles);

% --- Executes on button press in Accuracy.
function Accuracy_Callback(hObject, eventdata, handles)
% hObject    handle to Accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Accuracy
guidata(hObject,handles);

function Enter_sensitivity_Callback(hObject, eventdata, handles)
% hObject    handle to Enter_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Enter_sensitivity as text
%        str2double(get(hObject,'String')) returns contents of Enter_sensitivity as a double



sens_value=str2double(get(hObject,'String'));

if ~isnan(sens_value)&&(sens_value<=1)&&(sens_value>=0) % if text --> put default value
    set(hObject,'Value',sens_value);
else   
    set(hObject,'String',num2str(get(hObject,'Value')));  
end










guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Enter_sensitivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Enter_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
