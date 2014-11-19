function varargout = QuickCLEMOLD(varargin)
% QuickCLEM MATLAB code for QuickCLEM.fig
%      QuickCLEM, by itself, creates a new QuickCLEM or raises the existing
%      singleton*.
%
%      H = QuickCLEM returns the handle to a new QuickCLEM or the handle to
%      the existing singleton*.
%
%      QuickCLEM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QuickCLEM.M with the given input arguments.
%
%      QuickCLEM('Property','Value',...) creates a new QuickCLEM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before QuickCLEM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to QuickCLEM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help QuickCLEM

% Last Modified by GUIDE v2.5 14-Nov-2014 17:08:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @QuickCLEM_OpeningFcn, ...
                   'gui_OutputFcn',  @QuickCLEM_OutputFcn, ...
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


% --- Executes just before QuickCLEM is made visible.
function QuickCLEM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to QuickCLEM (see VARARGIN)

% Choose default command line output for QuickCLEM
handles.output = hObject;
handles.fileName = [];
handles.path = [];

% Update handles structure
guidata(hObject, handles);

addpath_recurse('refs');


% UIWAIT makes QuickCLEM wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = QuickCLEM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function uiFileOpenBtn_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiFileOpenBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, path] = uigetfile('*.HIS','Select the Hamamatsu stream file');

if path == 0
    return
else
    handles.filename = file;
    handles.path = path;
    set(handles.textboxFN, 'String', 'Opening file... this might take a while');
    drawnow;
    handles.data = bfopen(strcat(handles.path, handles.filename));
    maxVal = size(handles.data, 1);
    stepVal = 1 / (maxVal - 1);
    set(handles.sliderFrame,'Min', 1, 'Max', maxVal, 'Sliderstep', [stepVal , stepVal], 'Value', 1);
    imshow(handles.data{1,1}{1,1}, 'Parent', handles.axesFrame);
    guidata(hObject, handles);
end


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% We use the setpos library to position controls nicely within the fig
setpos(handles.textboxFN, '0.05nz 0.9nz 0.9nz 0.1nz');
setpos(handles.axesFrame, '0.1nz 0.2nz 0.8nz 0.8nz');
setpos(handles.sliderFrame, '0.05nz 0.05nz 0.9nz 0.1nz');
setpos(handles.btnExport, '0.05nz 0.01nz 0.9nz 0.1nz');


% --- Executes on slider movement.
function sliderFrame_Callback(hObject, eventdata, handles)
% hObject    handle to sliderFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Get the slider value and round it to the closest int
value = round(get(hObject,'Value'));

% Show the slider value to the user
set (handles.textboxFN, 'String', value);

% Select the proper image to show.
imshow(imadjust(handles.data{value,1}{1,1}), 'Parent', handles.axesFrame);


% --- Executes during object creation, after setting all properties.
function sliderFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btnExport.
function btnExport_Callback(hObject, eventdata, handles)
% hObject    handle to btnExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentFrame = round(get(handles.sliderFrame, 'Value'));

% Pass image to imadjust to improve contrast.
adjustedFrame = imadjust(handles.data{currentFrame,1}{1,1});

% Call a file dialog and process it
[file, path] = uiputfile('*.png', 'Save As');

if path == 0 
    % User canceled, do nothing.
    return; 
else
    % Save the file.
    path = fullfile(path,file);
    imwrite(adjustedFrame, path, 'png');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
