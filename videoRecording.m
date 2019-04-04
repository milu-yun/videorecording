function varargout = videoRecording(varargin)
% VIDEORECORDING MATLAB code for videoRecording.fig
%      VIDEORECORDING, by itself, creates a new VIDEORECORDING or raises the existing
%      singleton*.
%
%      H = VIDEORECORDING returns the handle to a new VIDEORECORDING or the handle to
%      the existing singleton*.
%
%      VIDEORECORDING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIDEORECORDING.M with the given input arguments.
%
%      VIDEORECORDING('Property','Value',...) creates a new VIDEORECORDING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before videoRecording_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to videoRecording_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help videoRecording

% Last Modified by GUIDE v2.5 30-Mar-2019 21:27:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @videoRecording_OpeningFcn, ...
                   'gui_OutputFcn',  @videoRecording_OutputFcn, ...
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

% --- Executes just before videoRecording is made visible.
function videoRecording_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to videoRecording (see VARARGIN)

% Choose default command line output for videoRecording
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes videoRecording wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = videoRecording_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in previewbutton.
function previewbutton_Callback(hObject, eventdata, handles)
% hObject    handle to previewbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.view);
cla;

camera_sel_index = get(handles.cameraList, 'Value');
global vid src
vid = videoinput('winvideo', camera_sel_index);
src = getselectedsource(vid);
vidRes = vid.VideoResolution;
nBands = vid.NumberOfBands;
hObject = image( zeros(vidRes(2), vidRes(1), nBands) );
preview(vid,hObject);
srcinfo = propinfo(src);
set(handles.brgslider,'min',srcinfo.Brightness.ConstraintValue(1))
set(handles.brgslider,'max',srcinfo.Brightness.ConstraintValue(2))
set(handles.brgslider, 'Value',src.Brightness)
set(handles.contslider,'min',srcinfo.Contrast.ConstraintValue(1))
set(handles.contslider,'max',srcinfo.Contrast.ConstraintValue(2))
set(handles.contslider, 'Value',src.Contrast)
set(handles.satuslider,'min',srcinfo.Saturation.ConstraintValue(1))
set(handles.satuslider,'max',srcinfo.Saturation.ConstraintValue(2))
set(handles.satuslider, 'Value',src.Saturation)
set(handles.shapslider,'min',srcinfo.Sharpness.ConstraintValue(1))
set(handles.shapslider,'max',srcinfo.Sharpness.ConstraintValue(2))
set(handles.shapslider, 'Value',src.Sharpness)
% set(handles.gamslider,'min',srcinfo.Gamma.ConstraintValue(1))
% set(handles.gamslider,'max',srcinfo.Gamma.ConstraintValue(2))
% set(handles.gamslider, 'Value',src.Gamma)


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in cameraList.
function cameraList_Callback(hObject, eventdata, handles)
% hObject    handle to cameraList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns cameraList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cameraList


% --- Executes during object creation, after setting all properties.
function cameraList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cameraList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end
imaqreset
camerainfo = imaqhwinfo('winvideo');
camera = camerainfo.DeviceInfo;
cameraList = {camera(:).DeviceName};
set(hObject, 'String', cameraList);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over cameraList.
function cameraList_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to cameraList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in recordbutton.
function recordbutton_Callback(hObject, eventdata, handles)
% hObject    handle to recordbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.recordbutton, 'Enable', 'off');
set(handles.previewbutton, 'Enable', 'off');
set(handles.stopbutton, 'Enable', 'on');
global vid
vid.FramesPerTrigger = 30;
vid.LoggingMode = 'disk';
vid.TriggerRepeat = Inf;
fileDir = 'D:\Data\Classical_conditioning\eye\';
realTime = clock;
handles.fileName = [fileDir get(handles.mouseName,'String'), '_', num2str(realTime, '%4d%02d%02d_%02d%02d%02.0f')];
diskLogger = VideoWriter(handles.fileName, 'MPEG-4');
vid.Tag = handles.fileName;
vid.DiskLogger = diskLogger;
vid.FramesAcquiredFcnCount = 10;
vid.FramesAcquiredFcn = {'timerecord'};
vid.StopFcn = {'timerecord'};
fileDir = 'D:\Data\Classical_conditioning\eye';
realTime = clock;
handles.fileName = [fileDir get(handles.mouseName,'String'), '_', num2str(realTime, '%4d%02d%02d_%02d%02d%02.0f')];
set(handles.starttime,'String', num2str(num2str(realTime, '%4d%02d%02d_%02d%02d%02.0f')))
set(handles.endtime,'String', ' ')

start(vid);

% --- Executes on button press in stopbutton.
function stopbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stopbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
stop(vid);
set(handles.endtime,'String', num2str(num2str(clock, '%4d%02d%02d_%02d%02d%02.0f')))
fileDir = 'D:\Data\Classical_conditioning\eye\';
handles.filename = [fileDir, get(handles.mouseName,'String'), '_', get(handles.starttime,'String'), '_eventlog.mat'];
eventlog = vid.EventLog;
save(handles.filename, 'eventlog')
set(handles.recordbutton, 'Enable', 'on');
set(handles.previewbutton, 'Enable', 'on');
set(handles.stopbutton, 'Enable', 'off');
stoppreview(vid)
delete(vid)


% --- Executes during object creation, after setting all properties.
function view_CreateFcn(hObject, eventdata, handles)
% hObject    handle to view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate view


% --- Executes on mouse press over axes background.
function view_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function brgslider_Callback(hObject, eventdata, handles)
% hObject    handle to brgslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global src
brgv = get(handles.brgslider, 'Value');
src.Brightness=brgv;

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function brgslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to brgslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function contslider_Callback(hObject, eventdata, handles)
% hObject    handle to contslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global src
contv = get(handles.contslider, 'Value');
src.Contrast = contv;
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function contslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function gamslider_Callback(hObject, eventdata, handles)
% hObject    handle to gamslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global src
gamv = get(handles.gamslider, 'Value');
src.Gamma = gamv;
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function gamslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function shapslider_Callback(hObject, eventdata, handles)
% hObject    handle to shapslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global src
shapv = get(handles.shapslider, 'Value');
src.Sharpness = shapv;
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function shapslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shapslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function satuslider_Callback(hObject, eventdata, handles)
% hObject    handle to satuslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global src
satuv = get(handles.satuslider, 'Value');
src.Saturation = satuv;
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function satuslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to satuslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function mouseName_Callback(hObject, eventdata, handles)
% hObject    handle to mouseName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mouseName as text
%        str2double(get(hObject,'String')) returns contents of mouseName as a double


% --- Executes during object creation, after setting all properties.
function mouseName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mouseName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function recordstart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recordstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in graycheck.
function graycheck_Callback(hObject, eventdata, handles)
% hObject    handle to graycheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
if (get(handles.graycheck,'Value'))
    vid.ReturnedColorSpace = 'grayscale';
else
    vid.ReturnedColorSpace = 'rgb';
end

% Hint: get(hObject,'Value') returns toggle state of graycheck
