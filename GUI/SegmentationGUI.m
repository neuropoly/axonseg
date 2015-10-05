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

% Last Modified by GUIDE v2.5 10-Sep-2015 13:48:46

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
handles.state.invertColor=0;
set(handles.invertColor,'Value',0);

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

% --- Executes on button press in cutImage.
function cutImage_Callback(hObject, eventdata, handles)
% hObject    handle to cutImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.img=as_improc_cutFromRect(handles.data.img, handles.reducefactor);
axes(handles.plotseg);
handles.reducefactor=max(1,floor(size(handles.data.img,1)/1000));
imshow(handles.data.img(1:handles.reducefactor:end,1:handles.reducefactor:end));
guidata(hObject, handles);


% --- Executes on button press in invertColor.
function invertColor_Callback(hObject, eventdata, handles)
% hObject    handle to invertColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.state.invertColor=get(handles.invertColor,'Value');
handles.data.img=imcomplement(handles.data.img);
axes(handles.plotseg);
imshow(handles.data.img(1:handles.reducefactor:end,1:handles.reducefactor:end));
guidata(hObject, handles);


% --- Executes on button press in histEq.
function histEq_Callback(hObject, eventdata, handles)
% hObject    handle to histEq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.state.histEq=get(handles.histEq,'Value');
if handles.state.histEq, handles.tmp=histeq(handles.data.img,1); else handles.tmp=handles.data.img; end

axes(handles.plotseg)
imshow(handles.tmp(1:handles.reducefactor:end,1:handles.reducefactor:end));
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of histEq
    


% --- Executes on slider movement.
function Deconv_Callback(hObject, eventdata, handles)
% hObject    handle to Deconv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Deconv,'Value',round(get(handles.Deconv,'Value'))); % ensure int
if ~isfield(handles,'tmp'), handles.tmp=handles.data.img; end
tmp=Deconv(handles.tmp,get(handles.Deconv,'Value'));
axes(handles.plotseg)
imshow(tmp)
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




% --- Executes on button press in GoStep0.
function GoStep0_Callback(hObject, eventdata, handles)
% hObject    handle to GoStep0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.state.Deconv=get(handles.Deconv,'Value');
handles.data.Step1=Deconv(handles.data.img,handles.state.Deconv);

handles.state.histEq=get(handles.histEq,'Value');
if handles.state.histEq, handles.data.Step1=histeq(handles.data.Step1,handles.state.histEq); end


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







% --- Executes on button press in goStep1.
function goStep1_Callback(hObject, eventdata, handles)
% hObject    handle to goStep1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
handles.state.invertColor=get(handles.invertColor,'Value');
handles.state.initSeg=get(handles.initSeg,'Value');
handles.state.diffMaxMin=get(handles.diffMaxMin,'Value');
handles.state.threshold=get(handles.threshold,'Value');
handles.data.Step2_seg=step1(handles.data.Step1,handles.state);

axes(handles.plotseg)
imshow(imfuse(handles.data.Step1,handles.data.Step2_seg))
guidata(hObject, handles);
fprintf('Etape 1 Done \n');

set(handles.uipanel2, 'Visible', 'on')
set(handles.uipanel1, 'Visible', 'off')

guidata(hObject, handles);


% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in resetStep1.
function resetStep1_Callback(hObject, eventdata, handles)
% hObject    handle to resetStep1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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
tmp=initseg(handles.data.Step1, get(handles.initSeg,'Value'));
tmp=imfill(tmp,'holes'); %imshow(initialBW)

axes(handles.plotseg)
imshow(imfuse(handles.data.Step1,tmp))
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



function im_out=initseg(im_in,heigthThresh)
% im_out1 = imextendedmin(im_in,distThresh);
% im_out2 = imextendedmin(im_in,distThresh-5);
% im_out3 = imextendedmin(im_in,distThresh+5);
% im_out=im_out1 | im_out2 | im_out3;
% im_out=adaptivethreshold(im_in,7,distThresh);
[im_out, handles.data.initialRejectBW] = axonInitialSegmentation(im_in, heigthThresh);
% --- Executes on slider movement.

function diffMaxMin_Callback(hObject, eventdata, handles)
% hObject    handle to diffMaxMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=initseg(handles.data.Step1, get(handles.diffMaxMin,'Value'));
axes(handles.plotseg)
imshow(imfuse(handles.data.Step1,tmp))
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider



% --- Executes on slider movement.
function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
tmp=handles.data.Step1<prctile(handles.data.Step1(:),100*get(handles.threshold,'Value'));
tmp=bwmorph(tmp,'fill'); tmp=bwmorph(tmp,'close'); tmp=bwmorph(tmp,'hbreak'); tmp = bwareaopen(tmp,5); %imshow(tmp)

imshow(imfuse(handles.data.Step1,tmp))



% --- Executes on button press in goStep2.
function goStep2_Callback(hObject, eventdata, handles)
% hObject    handle to goStep2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.state.minSize=get(handles.minSize,'Value');
handles.state.Circularity=get(handles.Circularity,'Value');
handles.state.Solidity=get(handles.Solidity,'Value');
handles.data.Step3_seg=step2(handles.data.Step2_seg,handles.state);

axes(handles.plotseg)
imshow(imfuse(handles.data.Step1,handles.data.Step3_seg))

SegParameters=handles.state; PixelSize=get(handles.PixelSize,'Value');
save([handles.outputdir 'SegParameters.mat'], 'SegParameters', 'PixelSize');

guidata(hObject, handles);
fprintf('Etape 2 Done \n');

set(handles.uipanel3, 'Visible', 'on')
set(handles.uipanel2, 'Visible', 'off')

guidata(hObject, handles);


% --- Executes on button press in resetStep2.
function resetStep2_Callback(hObject, eventdata, handles)
% hObject    handle to resetStep2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.plotseg);
imshow(imfuse(handles.data.Step1,handles.data.Step2_seg));
set(handles.uipanel1, 'Visible', 'on')
set(handles.uipanel2, 'Visible', 'off')
guidata(hObject, handles);


% --- Executes on button press in PixelSize_button.
function PixelSize_button_Callback(hObject, eventdata, handles)
% hObject    handle to PixelSize_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PixelSize=as_improc_pixelsize/handles.reducefactor;
set(handles.PixelSize,'String',PixelSize);
set(handles.PixelSize,'Value',PixelSize);

guidata(hObject, handles);


% --- Executes on slider movement.
function circularity_Callback(hObject, eventdata, handles)
% hObject    handle to circularity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=circTest(handles.data.Step2_seg,get(handles.circularity,'Value'));
axes(handles.plotseg)
imshowpair(imfuse(handles.data.Step1,handles.data.Step2_seg),imfuse(handles.data.Step1,tmp),'montage')
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
imshowpair(imfuse(handles.data.Step1,handles.data.Step2_seg),imfuse(handles.data.Step1,tmp),'montage')
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
tmp = axonValidateCircularity(handles.data.Step2_seg, get(handles.Circularity,'Value'));
axes(handles.plotseg)
imshowpair(imfuse(handles.data.Step1,handles.data.Step2_seg),imfuse(handles.data.Step1,tmp),'montage')
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

axes(handles.plotseg)
imshowpair(imfuse(handles.data.Step1,handles.data.Step2_seg),imfuse(handles.data.Step1,tmp),'montage')
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

axes(handles.plotseg)
imshowpair(imfuse(handles.data.Step1,handles.data.Step2_seg),imfuse(handles.data.Step1,tmp),'montage')
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





% --- Executes on button press in ellipse.
function ellipse_Callback(hObject, eventdata, handles)
% hObject    handle to ellipse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.plotseg)
imshow(imfuse(handles.data.Step1,handles.data.Step3_seg));
manualBW=as_axonSeg_manual_ellipse
handles.data.Step3_seg = manualBW | handles.data.Step3_seg;
imshow(imfuse(handles.data.Step1, handles.data.Step3_seg));

guidata(hObject, handles);




% --- Executes on button press in remove.
function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.plotseg)
imshow(imfuse(handles.data.Step1,handles.data.Step3_seg));

[Label, numAxonObj]  = bwlabel(handles.data.Step3_seg);
[c,r,~] = impixel;
rm=diag(Label(r,c));
handles.data.Step3_seg=~ismember(Label,[0;rm]);
imshow(imfuse(handles.data.Step1,handles.data.Step3_seg));
guidata(hObject, handles);


% --- Executes on button press in resetStep3.
function resetStep3_Callback(hObject, eventdata, handles)
% hObject    handle to resetStep3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel2, 'Visible', 'on')
set(handles.uipanel3, 'Visible', 'off')
axes(handles.plotseg)
imshow(imfuse(handles.data.Step1,handles.data.Step2_seg));



% --- Executes on button press in MyelinSeg.
function MyelinSeg_Callback(hObject, eventdata, handles)
% hObject    handle to MyelinSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Launch Seg
tmp=RemoveBorder(handles.data.Step3_seg);
backBW=handles.data.Step3_seg & ~tmp;
[handles.data.seg] = myelinInitialSegmention(handles.data.Step1, tmp, backBW,0,1);
handles.data.seg = myelinCleanConflict(handles.data.seg,1,0.5);

handles.data.Step3_seg = as_myelinseg_to_axonseg(handles.data.seg);

axes(handles.plotseg)
sc(sc(handles.data.Step1)+sc(sum(handles.data.seg,3),'copper'))

handles.data.labelseg=zeros(size(handles.data.seg,1), size(handles.data.seg,2));
for i=1:size(handles.data.seg,3)
    handles.data.labelseg(logical(handles.data.seg(:,:,i)))=i;
end



%% SAVE
savedir=[handles.outputdir 'results_croped' filesep];
mkdir(savedir);
% axonlist structure
axonlist=as_myelinseg_bw2list(handles.data.seg,get(handles.PixelSize,'Value'));
PixelSize = handles.PixelSize;
img=handles.data.img;
save([savedir, 'axonlist.mat'], 'axonlist', 'img', 'PixelSize','-v7.3')

% excel
handles.stats = as_stats(handles.data.seg,get(handles.PixelSize,'Value'));
handles.stats = struct2table(handles.stats);
writetable(handles.stats,[savedir 'Stats.csv'])

% AxonDiameter Labelled
AxCaliberLabelled=as_display_label(axonlist,size(handles.data.img),'axonEquivDiameter');
imwrite(sc(sc(handles.data.img)+sc(AxCaliberLabelled,'Hot')),[savedir 'Seg_labelled.jpg']);

guidata(hObject, handles);



% --- Executes on button press in go_full_image.
function go_full_image_Callback(hObject, eventdata, handles)
% hObject    handle to go_full_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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
