function varargout = AxonSeg(varargin)

% AxonSeg: Axon Segmentation Toolbox
%   AxonSeg() starts the Graphical User Interface (GUI)
%
%   AxonSeg( fname ) starts the GUI and load image fname (e.g. image.tif)
%   AxonSeg( fname, SegParameters ) load the parameters from SegParameters
%   file (e.g. SegParameters.mat)
%   AxonSeg( fname, SegParameters, '-nogui' ) starts the segmentation
%   of the myelin (nogui)
%   AxonSeg( fname, SegParameters, '-nogui', '-skipmyelin' ) starts the segmentation
%   of the axons only (nogui)
%   AxonSeg( {fname, axon_mask_fname}, SegParameters, '-nogui' ) starts the
%   myelin segmentation
% ----------------------------------------------------------------------------------------------------
% Example:
%   Segment and generate a SegParameters.mat file:
%     AxonSeg test_image_OM_crop.tif
%
%   Segment a new image using the same SegParameters:
%     AxonSeg test_image_2.tif SegParameters.mat -nogui
%
%   Segment myelin using a corrected axon mask:
%     AxonSeg({'RawImage.tif','Seg_mask_axon_corr.tif'}, 'SegParameters.mat', '-nogui')
% ----------------------------------------------------------------------------------------------------
%
% Reference: Zaimi A, Duval T, Gasecka A, Cote D, Stikov N and Cohen-Adad J (2016). AxonSeg: open source software for axon and myelin segmentation and morphometric analysis. Front. Neuroinform. 10:37. doi: 10.3389/fninf.2016.00037
% Copyright (c) 2016 NeuroPoly (Polytechnique Montreal) and DCClab (Universite Laval)
%
% See Also : as_Segmentation_full_image, myelinInitialSegmention

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @AxonSeg_OpeningFcn, ...
    'gui_OutputFcn',  @AxonSeg_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if ~nargin
    FileName= uigetimagefile_v2;
    if isempty(FileName), return; end
    varargin{1}=FileName;
end

nogui = strcmp(varargin,'-nogui');
if nargin>2 && max(nogui)
    varargin(nogui) = [];
    skipmyelin = strcmp(varargin,'-skipmyelin');
    if max(skipmyelin)
        varargin(skipmyelin) = [];
        as_Segmentation_full_image(varargin{1},varargin{2},[],[],[],true)
    else
        as_Segmentation_full_image(varargin{:})
    end
    return;
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AxonSeg is made visible.
function AxonSeg_OpeningFcn(hObject, eventdata, handles, varargin)
% read input
handles.varargin=varargin{1};
set(handles.go_full_image,'String', '<html>Segment full image <br>(uncropped)</html>');
[handles.outputdir,handles.fname]=fileparts(handles.varargin); if isempty(handles.outputdir), handles.outputdir=[pwd filesep]; else handles.outputdir = [handles.outputdir, filesep]; end
handles.fname = matlab.lang.makeValidName(handles.fname);

if length(varargin)>1, LoadSegParam_Callback(hObject, eventdata, handles, varargin{2}); end
% read image
if ~isfield(handles,'data') || ~isfield(handles.data,'raw')
    handles.data.raw=imresize(imread(handles.varargin),2);
end
handles.data.img=handles.data.raw;

if length(size(handles.data.img))==3
    handles.data.img=rgb2gray(handles.data.img(:,:,1:3));
end
axes(handles.plotseg);

handles.reducefactor=max(1,floor(size(handles.data.img,1)/1000));
imshow(handles.data.img(1:handles.reducefactor:end,1:handles.reducefactor:end));

% undock figure
set(gcf,'windowstyle','modal');
set(gcf,'windowstyle','normal');

% Update handles structure
set(gcf,'windowStyle','normal');
movegui(gcf,'center')
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function AxonSeg_OutputFcn(hObject, eventdata, handles)

% --- Executes on slider movement.
function Transparency_Callback(hObject, eventdata, handles)
if handles.display.type==2
    GUI_display(2,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1, handles.display.seg2, handles.display.opt2);
else
    GUI_display(1,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1);
end
guidata(hObject, handles);




function PixelSize_Callback(hObject, eventdata, handles)
px_tmp=str2num(get(hObject,'String'));
if max(isempty(px_tmp)) || (length(px_tmp(:))>1) %if text --> put default value
    set(hObject,'String',num2str(get(hObject,'Value')));
else
    set(hObject,'Value',px_tmp);
end

handles.segParam.PixelSize=str2num(get(handles.PixelSize,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function PixelSize_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PixelSize_button.
function PixelSize_button_Callback(hObject, eventdata, handles)
% hObject    handle to PixelSize_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PixelSize=as_improc_pixelsize/handles.reducefactor;
PixelSize = PixelSize*2; % Image is oversampled by 2 in AxonSeg.
if PixelSize
    set(handles.PixelSize,'String',PixelSize);
    set(handles.PixelSize,'Value',PixelSize);
end

handles.segParam.PixelSize=str2num(get(handles.PixelSize,'String'));

guidata(hObject, handles);

% --- Executes on button press in cropImage.
function cropImage_Callback(hObject, eventdata, handles)

handleArray = [handles.LoadSegParam, handles.PixelSize_button, handles.Transparency,...
    handles.histEq, handles.invertColor, handles.Smoothing, handles.Go_0_to_1, handles.resetStep0, handles.Deconv];

set(handleArray,'Enable','off');
drawnow;


handles.data.img=as_improc_cutFromRect(handles.data.img, handles.reducefactor);
axes(handles.plotseg);
handles.reducefactor=max(1,floor(size(handles.data.img,1)/1000));   % Max 1000 pixels size set for imshow
imshow(handles.data.img(1:handles.reducefactor:end,1:handles.reducefactor:end));


set(handleArray,'Enable','on');

guidata(hObject, handles);


function show_pre_process(handles)
% function that controls the pre-processing options of the GUI and updates
% the displays

im_pre=handles.data.img;

if get(handles.invertColor,'Value')==1
    im_pre=imcomplement(handles.data.img);
end

if get(handles.histEq,'Value')==1
    im_pre=histeq(im_pre,1);
end

if get(handles.Smoothing,'Value')==1
    im_pre=as_gaussian_smoothing(im_pre);
end

axes(handles.plotseg);
imshow(im_pre(1:handles.reducefactor:end,1:handles.reducefactor:end));


% --- Executes on button press in invertColor.
function handles=invertColor_Callback(hObject, eventdata, handles)
show_pre_process(handles);
guidata(hObject, handles);

% --- Executes on button press in histEq.
function handles=histEq_Callback(hObject, eventdata, handles)
show_pre_process(handles);
guidata(hObject, handles);

% --- Executes on button press in Smoothing.
function Smoothing_Callback(hObject, eventdata, handles)
show_pre_process(handles);
guidata(hObject,handles);

% --- Executes on slider movement.
function Deconv_Callback(hObject, eventdata, handles)
handleArray = [handles.LoadSegParam, handles.PixelSize_button, handles.Transparency,...
    handles.histEq, handles.invertColor, handles.Smoothing, handles.Go_0_to_1, handles.resetStep0, handles.cropImage];

set(handleArray,'Enable','off');
drawnow;

fprintf('*** Warning *** : Computing deconvolution. This may take time. Please wait. \n');

tic;

set(handles.Deconv,'Value',round(get(handles.Deconv,'Value'))); % ensure int



tmp=handles.data.img;

if get(handles.invertColor,'Value'), tmp=imcomplement(tmp); end
if get(handles.Smoothing,'Value'), tmp=as_gaussian_smoothing(tmp); end
if get(handles.histEq,'Value'), tmp=histeq(tmp,get(handles.histEq,'Value')); end
% if get(handles.histEq,'Value'), tmp=histeq(handles.data.img,1); else tmp=handles.data.img; end

tmp=Deconv(tmp,get(handles.Deconv,'Value'));
axes(handles.plotseg);
imshow(tmp(1:handles.reducefactor:end,1:handles.reducefactor:end));

toc;

set(handleArray,'Enable','on');

guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Deconv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Deconv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

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
handles.data.Step1=handles.data.img;

if get(handles.invertColor,'Value'), handles.data.Step1=imcomplement(handles.data.Step1); end
if get(handles.Smoothing,'Value'), handles.data.Step1=as_gaussian_smoothing(handles.data.Step1); end
if get(handles.histEq,'Value'), handles.data.Step1=histeq(handles.data.Step1,get(handles.histEq,'Value')); end

handles.data.Step1=Deconv(handles.data.Step1,get(handles.Deconv,'Value'));

imshow(handles.data.Step1(1:handles.reducefactor:end,1:handles.reducefactor:end));

% set(handles.panel_LS, 'Visible', 'on');
set(handles.uipanel1, 'Visible', 'on');
set(handles.uipanel0, 'Visible', 'off');
guidata(hObject, handles);

% --- Executes on button press in resetStep0.
function resetStep0_Callback(hObject, eventdata, handles)
AxonSeg_OpeningFcn(hObject, eventdata, handles, handles.varargin)




function LoadSegParam_Callback(hObject, eventdata, handles, Param_fname)
% Select segmentation parameters file to load
if ~exist('Param_fname','var') || ~exist(Param_fname,'file')
    [FileName,PathName] = uigetfile('*.mat*','Select the segmentation parameters you want to use');
else
    [PathName,FileName] = fileparts(Param_fname);
end
segparam_filepath = [PathName FileName];
load(segparam_filepath);

% Get parameters from a SegParameters file
set(handles.PixelSize,'String',SegParameters.PixelSize)
set(handles.invertColor,'Value',SegParameters.invertColor);
set(handles.histEq,'Value',SegParameters.histEq);
set(handles.Deconv,'Value',SegParameters.Deconv);
set(handles.Smoothing,'Value',SegParameters.Smoothing);

set(handles.initSeg,'Value',SegParameters.initSeg);
set(handles.diffMaxMin,'Value',SegParameters.diffMaxMin);
set(handles.threshold,'Value',SegParameters.threshold);

set(handles.minSize,'Value',SegParameters.minSize);
set(handles.Solidity,'Value',SegParameters.Solidity);
set(handles.Ellipticity,'Value',SegParameters.Ellipticity);

if isfield(SegParameters,'parameters')
    
    handles.parameters=SegParameters.parameters;
    if isfield(SegParameters,'DA_classifier')
        handles.classifier_final=SegParameters.DA_classifier;
    end
end

% Update handles
guidata(hObject,handles);


%%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%%%------------------- STEP 1 ------------------------------------------%%%
%%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


% --- Executes on slider movement.
function initSeg_Callback(hObject, eventdata, handles)
% hObject    handle to initSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handleArray = [handles.LoadSegParam,  handles.PixelSize_button, handles.Transparency,...
    handles.diffMaxMin, handles.Go_1_to_2, handles.resetStep1];

set(handleArray,'Enable','off');
drawnow;

%--------------------------------------------------------------------------
tmp=initseg(handles.data.Step1, get(handles.initSeg,'Value'));
tmp=imfill(tmp,'holes'); %imshow(initialBW)

%--------------------------------------------------------------------------
axes(handles.plotseg)

% -1-

handles.display.opt1=[1 1 0];
handles.display.seg1=tmp;
handles.display.type=1;

GUI_display(1,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1);

% example inputs: transparency=get(handles.Transparency,'Value'), img=handles.data.img,
% seg1=handles.display.seg1, opt1=handles.display.opt1, ...


% sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1));
% imshow(imfuse(handles.data.Step1,tmp))

set(handleArray,'Enable','on');

guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min')  and get(hObject,'Max') to determine range of slider

% Function initseg
function im_out=initseg(im_in,heigthThresh)
% Performs initial segmentation of axons & outputs the resulting image
% (binary image with axon separation vs background)
[im_out, handles.data.initialRejectBW] = axonInitialSegmentation(im_in, heigthThresh);


% --- Executes when user moves the diffmaxMin slider
function diffMaxMin_Callback(hObject, eventdata, handles)
% hObject    handle to diffMaxMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handleArray = [handles.LoadSegParam,  handles.PixelSize_button, handles.Transparency,...
    handles.initSeg, handles.Go_1_to_2, handles.resetStep1];

set(handleArray,'Enable','off');
drawnow;

% Perform initial segmentation of the axons based on diffMaxMin value
tmp=initseg(handles.data.Step1, get(handles.diffMaxMin,'Value'));

% Show updated axon segmentation on screen
axes(handles.plotseg);

handles.display.opt1=[1 1 0];
handles.display.seg1=tmp;
handles.display.type=1;

GUI_display(1,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1);


% -1-
% sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1));
% imshow(imfuse(handles.data.Step1,tmp));

set(handleArray,'Enable','on');

% Update handles
guidata(hObject, handles);

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
function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tmp=handles.data.Step1<prctile(handles.data.Step1(:),100*get(handles.threshold,'Value'));
tmp=bwmorph(tmp,'fill'); tmp=bwmorph(tmp,'close'); tmp=bwmorph(tmp,'hbreak'); tmp = bwareaopen(tmp,5); %imshow(tmp)

% -4-

handles.display.opt1=[1 1 0];
handles.display.seg1=tmp;
handles.display.type=1;

GUI_display(1,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1);

% --- Executes on button press in Go_1_to_2.
function Go_1_to_2_Callback(hObject, eventdata, handles)
    
handles.data.Step2_seg=step1(handles);    
[handles.stats_step2, handles.stats_cc]=axon_stats_step2(handles.data.Step2_seg);

%--------------------------------------------------------------------------

axes(handles.plotseg);


handles.display.opt1=[1 1 0];
handles.display.seg1=handles.data.Step2_seg;
handles.display.type=1;

GUI_display(1,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1);

guidata(hObject, handles);
fprintf('Step 1 Done \n');

% set(handles.panel_LS, 'Visible', 'off');
set(handles.uipanel2, 'Visible', 'on');
set(handles.uipanel1, 'Visible', 'off');
set(handles.text_legend, 'Visible','on');


guidata(hObject, handles);


% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in resetStep1.
function resetStep1_Callback(hObject, eventdata, handles)
axes(handles.plotseg);
imshow(handles.data.img(1:handles.reducefactor:end,1:handles.reducefactor:end));

set(handles.uipanel0, 'Visible', 'on')
set(handles.uipanel1, 'Visible', 'off')
guidata(hObject, handles);





%%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%%%------------------- STEP 2 ------------------------------------------%%%
%%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


% --- Executes on button press in Go_2_to_3.
function Go_2_to_3_Callback(hObject, eventdata, handles)

% DO SAVE HERE FOR INITIAL SEG IMAGE---------------------------------------

handles.data.Step3_seg=step2(handles);

% DO SAVE HERE FOR INITIAL SEG IMAGE---------------------------------------

axes(handles.plotseg);

handles.display.opt1=[0 0.75 0];
handles.display.seg1=handles.data.Step3_seg;
handles.display.type=1;

GUI_display(1,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1);

% Segmentation parameters to save for future use (full image seg.)---------

handles.segParam.invertColor=get(handles.invertColor,'Value');
handles.segParam.histEq=get(handles.histEq,'Value');
handles.segParam.Deconv=get(handles.Deconv,'Value');
handles.segParam.Smoothing=get(handles.Smoothing,'Value');

handles.segParam.initSeg=get(handles.initSeg,'Value');
handles.segParam.diffMaxMin=get(handles.diffMaxMin,'Value');
handles.segParam.threshold=get(handles.threshold,'Value');

handles.segParam.minSize=get(handles.minSize,'Value');
handles.segParam.Solidity=get(handles.Solidity,'Value');
% handles.segParam.AreaRatio=get(handles.AreaRatio,'Value');
handles.segParam.Ellipticity=get(handles.Ellipticity,'Value');
handles.segParam.Regularize=get(handles.Regularize,'Value');
% handles.segParam.parameters=get(handles.parameters,'Value');
% handles.segParam.DA_classifier=get(handles.DA_classifier,'Value');

fprintf('Step 2 Done \n');

set(handles.uipanel3, 'Visible', 'on');
set(handles.uipanel2, 'Visible', 'off');
set(handles.text_legend, 'Visible','on');


guidata(hObject, handles);


% --- Executes on button press in resetStep2.
function resetStep2_Callback(hObject, eventdata, handles)
% hObject    handle to resetStep2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.plotseg);

handles.display.opt1=[1 1 0];
handles.display.seg1=handles.data.Step2_seg;
handles.display.type=1;

GUI_display(1,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1);

set(handles.uipanel1, 'Visible', 'on');
set(handles.uipanel2, 'Visible', 'off');

set(handles.text_legend, 'Visible','off');

guidata(hObject, handles);

% --- Executes on slider movement.
function maxSize_Callback(hObject, eventdata, handles)
% hObject    handle to maxSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handle.data.proc=maxSize(handles.data.Step2_seg,get(handles.maxSize,'Value'));
axes(handles.plotseg)

%-1-
imshowpair(sc(get(handles.Transparency,'Value')*sc(handles.data.Step2_seg,'y',handles.data.Step2_seg)+sc(handles.data.Step1)),sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1)),'montage');
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


function im_out=circTest(im_in,Circ)
im_out = axonValidateCircularity(im_in, Circ);


% --- Executes on slider movement.
function Solidity_Callback(hObject, eventdata, handles)

handleArray = [handles.LoadSegParam, handles.PixelSize_button, handles.Transparency,...
                handles.minSize, handles.Ellipticity, handles.Go_2_to_3, handles.resetStep2];

set(handleArray,'Enable','off');
drawnow;

tmp=handles.data.Step2_seg;
metric=handles.stats_step2.Solidity;
p=find(metric<get(handles.Solidity,'Value'));
tmp(ismember(handles.stats_cc,p)==1)=0;

axes(handles.plotseg);

handles.display.opt1=[1 0.5 0];
handles.display.seg1=im2bw(handles.data.Step2_seg-tmp);

handles.display.opt2=[0 0.75 0];
handles.display.seg2=tmp;
handles.display.type=2;

GUI_display(2,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1, handles.display.seg2, handles.display.opt2);

set(handleArray,'Enable','on');

guidata(hObject, handles);



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


handleArray = [handles.LoadSegParam, handles.PixelSize_button, handles.Transparency,...
                handles.Ellipticity, handles.Solidity, handles.Go_2_to_3, handles.resetStep2];

set(handleArray,'Enable','off');
drawnow;

% tmp ---> the axons accepted
% handles.data.step2_seg ---> all axons


tmp=handles.data.Step2_seg;
metric=handles.stats_step2.EquivDiameter;
p=find(metric<get(handles.minSize,'Value'));
tmp(ismember(handles.stats_cc,p)==1)=0;

% tmp=sizeTest(handles.data.Step2_seg,get(handles.minSize,'Value'));

% handles.state.minSize = get(handles.minSize,'Value'); % ajoutee

axes(handles.plotseg);

handles.display.opt1=[1 0.5 0];
handles.display.seg1=im2bw(handles.data.Step2_seg-tmp);

handles.display.opt2=[0 0.75 0];
handles.display.seg2=tmp;
handles.display.type=2;

GUI_display(2,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1, handles.display.seg2, handles.display.opt2);

set(handleArray,'Enable','on');

guidata(hObject, handles);


% --- Executes on slider movement.
function Ellipticity_Callback(hObject, eventdata, handles)
% hObject    handle to Ellipticity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handleArray = [handles.LoadSegParam, handles.PixelSize_button, handles.Transparency,...
    handles.minSize, handles.Solidity, handles.Go_2_to_3, handles.resetStep2];

set(handleArray,'Enable','off');
drawnow;

tmp=handles.data.Step2_seg;
metric=handles.stats_step2.MinorMajorRatio;
p=find(metric<get(handles.Ellipticity,'Value'));
tmp(ismember(handles.stats_cc,p)==1)=0;

% Only select axons that validate the circularity criterion defined by user
% tmp = axonValidateMinorAxis(handles.data.Step2_seg, get(handles.Ellipticity,'Value'));

% Show side-by-side segmentation obtained after step 2 VS segmentation
% corrected by the circularity criterion


axes(handles.plotseg);

handles.display.opt1=[1 0.5 0];
handles.display.seg1=im2bw(handles.data.Step2_seg-tmp);

handles.display.opt2=[0 0.75 0];
handles.display.seg2=tmp;
handles.display.type=2;

GUI_display(2,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1, handles.display.seg2, handles.display.opt2);

set(handleArray,'Enable','on');

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Ellipticity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ellipticity (see GCBO)
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




%%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%%%----------------- STEP 3 --------------------------------------------%%%
%%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -










% --- Executes on button press in Add.
function Add_Callback(hObject, eventdata, handles)
% hObject    handle to Add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


axes(handles.plotseg);
set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'off')

handles.display.opt1=[0 0.75 0];
handles.display.seg1=handles.data.Step3_seg;
handles.display.type=1;

GUI_display(1,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1);

manualBW=as_axonSeg_manual;
handles.data.Step3_seg = imresize(manualBW,size(handles.data.Step3_seg)) | handles.data.Step3_seg;


%--------------------------------------------------------------------------


axes(handles.plotseg);

handles.display.opt1=[0 0.75 0];
handles.display.seg1=handles.data.Step3_seg;
handles.display.type=1;

GUI_display(1,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1);

set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'on')

guidata(hObject, handles);




% --- Executes on button press in remove.
function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.plotseg);

handles.display.opt1=[0 0.75 0];
handles.display.seg1=handles.data.Step3_seg;
handles.display.type=1;

GUI_display(1,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1);

% -1-
% imshow(sc(get(handles.Transparency,'Value')*sc(handles.data.Step3_seg,[0 0.75 0],handles.data.Step3_seg)...
%     +sc(handles.data.Step1)));

[Label, ~]  = bwlabel(handles.data.Step3_seg);
set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'off')

[c,r,err] = impixel; err = max(isnan(err),[],2);
c = c(~err); r=r(~err);
rm=diag(Label(r*handles.reducefactor,c*handles.reducefactor));

rejected=im2bw(handles.data.Step3_seg-(~ismember(Label,[0;rm])));
handles.data.Step3_seg=~ismember(Label,[0;rm]);

%--------------------------------------------------------------------------

guidata(hObject, handles);

% axes(handles.plotseg);
% imshow(sc(get(handles.Transparency,'Value')*sc(handles.data.Step3_seg,[0 0.75 0],handles.data.Step3_seg)...
%     +sc(handles.data.Step1)));

axes(handles.plotseg);

handles.display.opt1=[1 0.5 0];
handles.display.seg1=rejected;

handles.display.opt2=[0 0.75 0];
handles.display.seg2=handles.data.Step3_seg;
handles.display.type=2;

GUI_display(2,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1, handles.display.seg2, handles.display.opt2);

% -1-
% imshow(sc(get(handles.Transparency,'Value')*sc(rejected,[1 0.5 0],rejected)...
%     +get(handles.Transparency,'Value')*sc(handles.data.Step3_seg,[0 0.75 0],handles.data.Step3_seg)+sc(handles.data.Step1)));

set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'on')
guidata(hObject, handles);


% --- Executes on button press in resetStep3.
function resetStep3_Callback(hObject, eventdata, handles)
% hObject    handle to resetStep3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles.segParam,'DA_classifier')
    handles.segParam=rmfield(handles.segParam,{'parameters', 'DA_classifier'});
    set(handles.DiscriminantAnalysis,'Value',0)
end

set(handles.slider_ROC_plot, 'Visible','off');
set(handles.text_slider_ROC_plot, 'Visible','off');

set(handles.Panel_manual_modifs, 'Visible','on');
set(handles.text_legend, 'Visible','on');

set(handles.ROC_Panel, 'Visible','off');
legend(handles.ROC_curve, 'hide');
cla(handles.ROC_curve);

set(handles.uipanel2, 'Visible', 'on')
set(handles.uipanel3, 'Visible', 'off')
axes(handles.plotseg)

handles.display.opt1=[1 1 0];
handles.display.seg1=handles.data.Step2_seg;
handles.display.type=1;

GUI_display(1,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1);

% imshow(sc(get(handles.Transparency,'Value')*sc(handles.data.Step2_seg,'y',handles.data.Step2_seg)+sc(handles.data.Step1)));
% imshow(imfuse(handles.data.Step1,handles.data.Step2_seg));



% --- Executes on button press in MyelinSeg.
function MyelinSeg_Callback(hObject, eventdata, handles)
% hObject    handle to MyelinSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Launch Seg

set(findobj('Name','AxonSeg'),'pointer', 'watch');
drawnow;



%---

if get(handles.DiscriminantAnalysis,'value')
    AxSeg = handles.data.DA_accepted;
else
    AxSeg = handles.data.Step3_seg;
end
AxSeg = imresize(AxSeg,0.5);  % return to original size.
[AxSeg_noborder,border_removed_mask]=RemoveBorder(AxSeg,str2num(get(handles.PixelSize,'String')));
backBW=AxSeg & ~AxSeg_noborder;

img = imresize(handles.data.Step1,0.5);  % return to original size.
[axonlist,handles.data.seg,Step3_seg] = myelinInitialSegmention(img, AxSeg_noborder, backBW,0,get(handles.Regularize,'Value'),2/3,0,str2num(get(handles.PixelSize,'String')));

axes(handles.plotseg);
handles.display.seg1 = imresize(handles.data.seg,2,'nearest');
handles.display.opt1 = cat(1,[0 0 0],jet(255));
handles.display.seg2 = imresize(border_removed_mask,2);
handles.display.opt2 = [0.5 0.4 0.4];
handles.display.type = 2;
GUI_display(2,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1, handles.display.seg2, handles.display.opt2);


%% SAVE

% save SegParam
odir = uigetdir(handles.outputdir,'Save Results in this directory');
if odir
    handles.outputdir = odir;
    handles.outputdir = [handles.outputdir filesep];
    
    savedir=[handles.outputdir handles.fname '_AxonSeg_cropped' filesep];
    mkdir(savedir);
    
    currentdir=pwd;
    cd(savedir);
    % save SegParameters
    PixelSize=str2num(get(handles.PixelSize,'String'));
    handles.segParam.PixelSize=PixelSize;
    SegParameters=handles.segParam;
    save([pwd filesep 'SegParameters.mat'], 'SegParameters');
    
    
    % axonlist structure
    % clean axonlist (if 0 gRatio & 0 axon diameter)
    axonlist=axonlist([axonlist.gRatio]~=0);
    axonlist=axonlist([axonlist.axonEquivDiameter]~=0);
    
    PixelSize = str2num(get(handles.PixelSize,'String'));
    
    save('axonlist.mat', 'axonlist', 'img', 'PixelSize','-v7.3');
    
    % excel
    handles.stats = as_stats(handles.data.seg,str2num(get(handles.PixelSize,'String')));
    handles.stats = struct2table(handles.stats);
    writetable(handles.stats,'Stats.csv')
    
    % AxonDiameter Labelled
    img = imresize(handles.data.img,.5);
    bw_axonseg_myelin=as_display_label(axonlist,size(img),'axonEquivDiameter','myelin',img);
    imwrite(im2bw(bw_axonseg_myelin,0),'Seg_mask_myelin.tif');
    bw_axonseg_axon=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
    imwrite(im2bw(bw_axonseg_axon,0),'Seg_mask_axon.tif');
    
    %--------------------------------------------------------------------------
    imwrite(imresize(handles.data.img,.5),'RawImage.tif');
    imwrite(imresize(handles.data.Step1,.5),'Step_1_Pre_Processing.tif');
    imwrite(imresize(handles.data.Step2_seg,.5),'Step_2_Initial_AxonSeg.tif');
    imwrite(Step3_seg,'Step_3_Final_AxonSeg.tif');
    
    cd(currentdir);
    
    
    %--------------------------------------------------------------------------
end
set(findobj('Name','AxonSeg'),'pointer', 'arrow');

guidata(hObject, handles);

% --- Executes on button press in go_full_image.
function go_full_image_Callback(hObject, eventdata, handles)

set(findobj('Name','AxonSeg'),'pointer', 'watch');
drawnow;

set(handles.ROC_Panel, 'Visible','off');
legend(handles.ROC_curve, 'hide');
cla(handles.ROC_curve);

set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'off')


drawnow;


%------------------

odir = uigetdir(handles.outputdir,'Save Results in this directory');
if odir, handles.outputdir = odir; else set(findobj('Name','AxonSeg'),'pointer', 'arrow'); return; end
handles.outputdir = [handles.outputdir filesep];
savedir=[handles.outputdir handles.fname '_AxonSeg_full' filesep];
mkdir(savedir);
% save SegParameters
PixelSize=str2num(get(handles.PixelSize,'String'));
handles.segParam.PixelSize=PixelSize;
SegParameters=handles.segParam;
save([savedir 'SegParameters.mat'], 'SegParameters');
% AxonSeg
as_Segmentation_full_image(handles.varargin,[savedir 'SegParameters.mat'],[],[],savedir);

set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'on')
set(findobj('Name','AxonSeg'),'pointer', 'arrow');


function text20_CreateFcn(hObject, eventdata, handles)
function text20_ButtonDownFcn(hObject, eventdata, handles)


% --- Executes on button press in DiscriminantAnalysis.
function DiscriminantAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to DiscriminantAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% All possible parameters :
%{'Area', 'Perimeter', 'EquivDiameter', 'Solidity','Circularity','MajorAxisLength','MinorMajorRatio',...
%'MinorAxisLength','Eccentricity','ConvexArea','Orientation','Extent','FilledArea','Intensity_std', ...
%'Intensity_mean','Perimeter_ConvexHull','PPchRatio','AAchRatio','Intensity_std', 'Intensity_mean',...
%'Neighbourhood_mean','Neighbourhood_std','Contrast','Skewness'}

% {'EquivDiameter', 'Solidity','Circularity','MinorMajorRatio','Intensity_std', 'Intensity_mean','Neighbourhood_mean','Neighbourhood_std','Contrast','Skewness'}


if get(handles.DiscriminantAnalysis,'Value')==1
    
    [~,N]=bwlabel(handles.data.Step3_seg);
    if N<3, errordlg('not enough axons. Go back to step 1 or 2'); return; end
    % Get discriminant analysis type chosen by user
    if get(handles.Linear,'Value')
        type = 'linear';
    else
        type = 'pseudoQuadratic';
    end
    
    tic;
    fprintf('*** COMPUTING DISCRIMINANT ANALYSIS *** PLEASE WAIT *** \n');
    
    set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'off')

    drawnow;
    
    % Create a set of classifiers for the given data for each possible
    % sensivity value
    [classifier, handles.parameters,ROC_values] = as_axonSeg_make_DA_classifier(handles.data.Step2_seg,handles.data.Step3_seg,handles.data.Step1,...
        {'EquivDiameter','Solidity','Circularity','MinorMajorRatio','Intensity_std', 'Intensity_mean','Neighbourhood_mean','Neighbourhood_std','Contrast','Skewness'},type,1);
    
    % [classifier, handles.parameters,ROC_values] = as_axonSeg_make_DA_classifier(handles.data.Step2_seg,handles.data.DA_final,handles.data.Step1,...
    %     {'Area', 'Perimeter', 'EquivDiameter', 'Solidity','Circularity','MajorAxisLength','MinorMajorRatio', 'MinorAxisLength','Eccentricity','ConvexArea','Perimeter_ConvexHull','PPchRatio','AAchRatio','Intensity_std', 'Intensity_mean','Neighbourhood_mean','Neighbourhood_std','Contrast','Skewness'},type,1);
    
    % Set slider_ROC_plot parameters depending on the DA analysis
    set(handles.slider_ROC_plot,'Max',size(ROC_values,1));
    
    if size(ROC_values,1)~=1
        set(handles.slider_ROC_plot, 'SliderStep', [1/(size(ROC_values,1)-1) , 1/(size(ROC_values,1)-1)]);
    end
    
    set(handles.slider_ROC_plot,'Value',size(ROC_values,1));
    
    % Select classifier depending on sensitivity defined by the ROC slider
    handles.classifier_final=classifier{get(handles.slider_ROC_plot,'Value')};
    handles.classifiers=classifier;
    
    % Apply selected classifier to the given data
    [Accepted_axons_img,Rejected_axons_img,Classification,~,~]=as_axonSeg_apply_DA_classifier(handles.data.Step2_seg,handles.data.Step1,handles.classifier_final,handles.parameters);
    
    % Plot ROC curve
    handles.ROC_values = ROC_values;
    % axes(handles.ROC_curve);
    % as_plot_ROC_curve_DA(handles.ROC_values,get(handles.slider_ROC_plot,'Value'));
    
    % Set dafault ROC metric for DA (case 8 -> min euclidian distance)
    set(handles.popupmenu_ROC,'Value',8);
    popupmenu_ROC_Callback(hObject, eventdata, handles);
    
    
    % Select accepted axons given by classifier
    handles.data.DA_accepted = Accepted_axons_img;
    
    % Add classifier chosen & parameters to the segmentation parameters struct
    
    handles.segParam.parameters=handles.parameters;
    handles.segParam.DA_classifier=handles.classifier_final;
    
    
    
    
    % Update visibility of widgets
    set(handles.ROC_Panel, 'Visible','on');
    set(handles.text_legend, 'Visible','off');
    
    if size(ROC_values,1)~=1
        set(handles.slider_ROC_plot, 'Visible','on');
        set(handles.text_slider_ROC_plot, 'Visible','on');
    end
    
    toc;
    fprintf('Discriminant analysis done. \n');
    
    % Display axon discrimination result
    axes(handles.plotseg);
    
    handles.display.opt1=[0 0.75 0];
    handles.display.seg1=handles.data.DA_accepted;
    
    handles.display.opt2=[1 0.5 0];
    handles.display.seg2=Rejected_axons_img;
    handles.display.type=2;
    
    GUI_display(2,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1, handles.display.seg2, handles.display.opt2);
    
    
    set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'on')
    set(handles.remove, 'Visible', 'off')
    
else
    set(handles.ROC_Panel, 'Visible','off');
    set(handles.text_legend, 'Visible','on');
    set(handles.remove, 'Visible', 'on')
    handles.segParam=rmfield(handles.segParam,'parameters');
    handles.segParam=rmfield(handles.segParam,'DA_classifier');
    
end

guidata(hObject,handles);





% --- Executes on button press in LevelSet_step1.
function LevelSet_step1_Callback(hObject, eventdata, handles)
% hObject    handle to LevelSet_step1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LevelSet_step1

% if get(handles.LevelSet_step1,'Value')
%
% tmp=as_LevelSet_method(handles.data.Step1);
%
% axes(handles.plotseg);
%
% imshow(sc(get(handles.Transparency,'Value')*sc(tmp,'y',tmp)+sc(handles.data.Step1)));
%
% end
% imshow(imfuse(handles.data.Step1,handles.data.Step2_seg));

guidata(hObject,handles);




% --- Executes on button press in Precision.
function Precision_Callback(hObject, eventdata, handles)
guidata(hObject,handles);

% --- Executes on button press in Distance.
function Distance_Callback(hObject, eventdata, handles)
guidata(hObject,handles);

function Enter_sensitivity_Callback(hObject, eventdata, handles)

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


% --- Executes on button press in Show_LevelSet.
function Show_LevelSet_Callback(hObject, eventdata, handles)
% hObject    handle to Show_LevelSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Show_LevelSet


if get(hObject,'Value')
    
    [LevelSet_results]=as_LevelSet_method(handles.data.Step1,get(handles.LevelSet_slider,'Value'));
    axes(handles.plotseg);
    sc(get(handles.Transparency,'Value')*sc(LevelSet_results.img,'y',LevelSet_results.img)+sc(handles.data.Step1));
    
end

guidata(hObject,handles);


% --- Executes on button press in Only_LevelSet.
function Only_LevelSet_Callback(hObject, eventdata, handles)
% hObject    handle to Only_LevelSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Only_LevelSet
guidata(hObject,handles);


% --- Executes on slider movement.
function LevelSet_slider_Callback(hObject, eventdata, handles)
% hObject    handle to LevelSet_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

[LevelSet_results]=as_LevelSet_method(handles.data.Step1,get(hObject,'Value'));
axes(handles.plotseg);
sc(get(handles.Transparency,'Value')*sc(LevelSet_results.img,'y',LevelSet_results.img)+sc(handles.data.Step1));


guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function LevelSet_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LevelSet_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu_ROC.
function popupmenu_ROC_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ROC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the indexes for the best metrics (precision, accuracy,...)
[~,best_indexes]=as_find_max_ROC_metrics(handles.ROC_values);

% Update ROC slider value depending on the user's choice
switch get(handles.popupmenu_ROC,'Value')
    case 2 % max sensitivity
        set(handles.slider_ROC_plot,'Value',size(handles.ROC_values,1));
    case 3 % max specificity
        set(handles.slider_ROC_plot,'Value',1);
    case 4 % max precision
        set(handles.slider_ROC_plot,'Value',best_indexes(1));
    case 5 % max accuracy
        set(handles.slider_ROC_plot,'Value',best_indexes(2));
    case 6 % max bal accuracy
        set(handles.slider_ROC_plot,'Value',best_indexes(3));
    case 7 % max youden
        set(handles.slider_ROC_plot,'Value',best_indexes(4));
    case 8 % min distance
        set(handles.slider_ROC_plot,'Value',best_indexes(5));
end


% Call the slider_ROC_plot callback function to update classifier, ROC plot
% & axon discrimination display


set(findobj('Name','AxonSeg'),'pointer', 'watch');

drawnow;


slider_ROC_plot_Callback(hObject, eventdata, handles);

set(findobj('Name','AxonSeg'),'pointer', 'arrow');


guidata(hObject,handles);





% --- Executes during object creation, after setting all properties.
function popupmenu_ROC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ROC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.



if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_ROC_plot_Callback(hObject, eventdata, handles)
% hObject    handle to slider_ROC_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(findobj('Name','AxonSeg'),'pointer', 'watch');
drawnow;

% Make sure the slider value is an integer
float_value=get(handles.slider_ROC_plot,'Value');
set(handles.slider_ROC_plot,'Value',round(float_value));

% Select a classifier by using the slider value
handles.classifier_final=handles.classifiers{get(handles.slider_ROC_plot,'Value')};

% Apply the classifier on the axon BW data
[Accepted_axons_img,Rejected_axons_img,Classification,~,~]=as_axonSeg_apply_DA_classifier(handles.data.Step2_seg,handles.data.Step1,handles.classifier_final,handles.parameters);

% Get Sensitivity & Specificity for the classifier selected & display the
% values
[ROC_stats] = ROC_calculate(Classification);
set(handles.Sensitivity,'String',num2str(ROC_stats(1)));
set(handles.Specificity,'String',num2str(ROC_stats(2)));

% Update ROC plot by displaying the current ROC value
axes(handles.ROC_curve);
as_plot_ROC_curve_DA(handles.ROC_values,get(handles.slider_ROC_plot,'Value'));

% Get the accepted axons from the selected classifier
handles.data.DA_accepted = Accepted_axons_img;


% Update the axon discrimination display depending on the classifier used
axes(handles.plotseg);

handles.display.opt1=[0 0.75 0];
handles.display.seg1=handles.data.DA_accepted;

handles.display.opt2=[1 0.5 0];
handles.display.seg2=Rejected_axons_img;
handles.display.type=2;

GUI_display(2,handles.reducefactor,get(handles.Transparency,'Value'), handles.data.Step1, handles.display.seg1, handles.display.opt1, handles.display.seg2, handles.display.opt2);

set(findobj('Name','AxonSeg'),'pointer', 'arrow');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider_ROC_plot_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function listbox_step0_Callback(hObject, eventdata, handles)
function listbox_step0_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_test_Callback(hObject, eventdata, handles)
function edit_test_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Regularize_Callback(hObject, eventdata, handles)
function Transparency_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function initSeg_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function threshold_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function minSize_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end