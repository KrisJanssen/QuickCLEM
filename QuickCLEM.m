function varargout = QuickCLEM(varargin)
% QUICKCLEM MATLAB code for QuickCLEM.fig
%      QUICKCLEM, by itself, creates a new QUICKCLEM or raises the existing
%      singleton*.
%
%      H = QUICKCLEM returns the handle to a new QUICKCLEM or the handle to
%      the existing singleton*.
%
%      QUICKCLEM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUICKCLEM.M with the given input arguments.
%
%      QUICKCLEM('Property','Value',...) creates a new QUICKCLEM or raises the
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

% Last Modified by GUIDE v2.5 15-Nov-2014 20:24:48

%% Path init.
% Set the path to the QuickCLEM workdir if it is stored from a previous 
% session
workdir = getappdata(0,'workdirQuickCLEM');
if ~isempty(workdir)
    try cd(workdir), end
end

% Add the subfolders of the program to the MATLAB search path
% First, the current directory (installation directory)
addpath(pwd) 

% Next, the 'core' and 'refs' subdirectory and its subfolders
addpath(genpath(fullfile(pwd,'core')))
addpath(genpath(fullfile(pwd,'refs'))) 

%% Splash screen.
% Display splash screen if 
% 1) running MATLAB version 2010a or above 
% 2) it is not a deployed GUI version 
% 3) splash has not been loaded already
%
% Splash screen code was originally written by Søren Preus, developer of
% DecayFit software (www.fluortools.com). Some of the UI initialization
% concepts were also derived from DecayFit.


try
    % Open splash screen
    MATLABversion = version('-release');
    s = getappdata(0,'QuickCLEMSplashHandle');
    
    if (str2double(MATLABversion(1:4))>=2010) && isempty(s)
        s = SplashScreen('QuickCLEM', getasset( 'splash.PNG' ), ...
            'ProgressBar', 'on', ...
            'ProgressPosition', 5, ...
            'ProgressRatio', 0.0 );
        s.addText( 300, 375, 'Loading...', 'FontSize', 18, 'Color', 'white' )
        
        setappdata(0,'QuickCLEMSplashHandle',s) % Point to splashScreen handle in order to delete it when GUI opens
    end
    
    % Set progressbar of splash screen
    progTot = 1; % Total number of times the main function is being called upon startup. Application dependent.
    
    % Running parameter counting how many times the main function has been called
    prog = getappdata(0,'QuickCLEMSplashCounter');
    if isempty(prog)
        prog = 1;
    else
        prog = prog+1;
    end
    
    % Ratio used for progressbar of splashScreen
    if prog/progTot>1
        progbar = 0;
        prog = 0;
    else
        progbar = prog/progTot;
    end
    
    % Update progress bar and counter.
    set(s,'ProgressRatio', progbar)
    setappdata(0,'QuickCLEMSplashCounter',prog)
end

%% GUIDE code
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

% Store a global reference to the main app window.
setappdata(0, 'mainWindow', hObject);

% Choose default command line output for QuickCLEM
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes QuickCLEM wait for user response (see UIRESUME)
% uiwait(handles.mainFig);

% Software specifications
handles.workdir = getcurrentdir; % Root directory
handles.name = 'QuickCLEM'; % Short name
handles.website = 'http://www.github.com/KrisJanssen/QuickCLEM'; % Homepage
handles.version = '0.1'; % This version. Must be string.
handles.splashScreenHandle = getappdata(0,'QuickCLEMSplashHandle'); % Handle to the splash screen running on startup

% Update above settings
%updatemainhandles(handles)
setappdata(0, 'workdirQuickCLEM',handles.workdir) % It is necessary also to send workdir to appdata
guidata(hObject, handles);

% Version
MATLABversion = version('-release'); % This will be used below

% Create required folders on system path
ok = createFolders(handles);
if ~ok
    deleteSplashScreen(handles.splashScreenHandle) % Delete the splash screen
    try delete(hObject), end % Delete window object
    return
end

addmainmenu()
addmaincontrols();

%handles = guidata(hObject);

% Set position, title and logo. Turn off visibility.
initGUI(handles.mainFig, ...
    'QuickCLEM - A tool for image registration in CLEM', ...
    'center');

% Delete splash screen

setappdata(0, 'mainWindow', hObject)

deleteSplashScreen(handles.splashScreenHandle)


% --- Outputs from this function are returned to the command line.
function varargout = QuickCLEM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close mainFig.
function mainFig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to mainFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
try delete(hObject), end

% Remove search paths:
workdir = getappdata(0,'workdirQuickCLEM');
if ~isempty(workdir)
    try rmpath(genpath(fullfile(workdir,'refs'))), end
    try rmpath(genpath(fullfile(workdir,'library'))), end
    try rmpath(workdir), end
end

% Remove appdata stored by program
try rmappdata(0,'QuickCLEMSplashHandle'), end
try rmappdata(0,'QuickCLEMSplashCounter'), end
try rmappdata(0,'varname'), end
try rmappdata(0,'defaults'), end
try rmappdata(0,'model'), end
try rmappdata(0,'fits'), end
try rmappdata(0,'workdirQuickCLEM'), end

%% Callbacks
