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
% 2) if its not a deployed GUI version, and 
% 3) splash hasn't been loaded already

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
    progTot = 3; % Total number of times the main function is being called upon startup. Application dependent.
    
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

% 
% % Settings
% settings = internalSettingsStructure(); % Initialize settings structure with internal values
% handles.settings = loadDefaultSettings(handles, settings); % Load default settings from file
% 
% % Settings that should not be changed
% 
% % Initialize data structure
% decays = storeData([]);
% decays(1) = []; % Make 1x0 struct array
% 
% % Same for IRF
% IRFs = decays;
% 
% % Update structures in userdata
% updateData(handles,decays,IRFs)
% 
% % Initialize fits structure
% models = cellstr(get(handles.FitModelsListbox,'String')); % Start choice
% nomodels = size(models,1); % Number of models
% maxdecays = handles.settings.startup.maxdecays; % Maximum no. of decays in loaded into program
% maxIRFs = handles.settings.startup.maxdecays; % Maximum no. of IRFs loaded into program
% fits(maxdecays,maxIRFs,nomodels).decay = []; % Fits has 3D indexing: (m,n,p) = (decay,IRF,decaymodel)
% fits(maxdecays,maxIRFs,nomodels).res = []; % Residual
% fits(maxdecays,maxIRFs,nomodels).ChiSq = []; % Chi-square value
% fits(maxdecays,maxIRFs,nomodels).pars = []; % Optimized parameter values
% fits(maxdecays,maxIRFs,nomodels).tail = []; % Tail fit start point
% fits(maxdecays,maxIRFs,nomodels).scatter = []; % Scatter value
% [fits.scatter] = deal(0); % Set all scatter values to 0
% 
% % Default parameters values
% defaultglobalparselect = cell(1);
% for i = 1:nomodels
%     name = models(i); % Name of model
%     fun = str2func(name{:}); % Model function
%     fun(0); % Run function in order to return default values
%     defaults = getappdata(0,'defaults'); % Get default values returned by the function
%     [fits(:,:,i).pars] = deal(defaults); % All initial parameters values
%     
%     defaultglobalparselect{i,1} = 1:size(defaults,1); % Insert default parameter values
% end
% set(handles.fits,'UserData',fits); % Update
% 
% % Set shifts
% set(handles.ShiftTable,'UserData',repmat({[0 10]},maxdecays,maxIRFs)) % Initialize for 20 decays and IRFs. If more is added, they will be added later
% update_channelshift(handles) % Update shift textbox
% 
% % Set global structure
% Global.names = [];
% Global.pars = [];
% Global.index = [];
% Global.shifts = [];
% Global.fits = [];
% Global.res = [];
% Global.decays = [];
% Global.IRFs = [];
% Global.t = [];
% Global.weights = [];
% Global.ChiSq = [];
% Global.scatter = [];
% Global(1) = [];
% set(handles.GlobalList,'UserData',Global); % Update structure
% set(handles.GlobalParListbox,'UserData',defaultglobalparselect) % Update default global parameter selection
% 
% % Set distributions
% dists = cell(1); % Distributions
% dists(1) = [];
% set(handles.DistTextbox,'UserData',dists) % Update distributions
% 
% handles.filename = ''; % Session filename
% 
% % Default chi-square surface parameters
% threshold = 1.1;
% stepsize = 0.01;
% minsteps = 10;
% set(handles.Tools_ChiSqSurf,'UserData',[threshold; stepsize; minsteps])
% 
% % Default parameter plot window settings:
% set(handles.Edit_ParPlotSettings,'UserData','aw') % Amplitude-weighted
% 
% % Window handles
% 
% % GUI object handles
% handles.recentsessionsMenu = []; % Handle to the recent session files menu in the file menu of the main window
% handles.recentmoviesMenu = []; % Handle to the recent movie files menu in the file menu of the main window
% 
% % Update recent files menus. Must be positioned after the recent
% updateRecentFilesMenu(handles)
% 
% % Choose default command line output
% handles.output = hObject;
% 
% % Update handles structure
% updatemainhandles(handles)
% 
% % Set some GUI settings
% setGUIappearance(handles.mainFig)
% 
% % Check the MATLAB version. Must be positioned after settings
% [handles, choseReturn] = checkforMATLAB(handles,'25-Jan-2010','2010a');
% if choseReturn % If user does not whish to continue without proper version
%     deleteSplashScreen(handles.splashScreenHandle) % Delete the splash screen
%     try delete(hObject), end % Delete window object
%     return
% end
% 
% % Check toolboxes
% handles = checkforToolboxes(handles,'curve_fitting_toolbox','optimization_toolbox','signal_toolbox','statistics_toolbox');
% 
% % Check allocated Java heap space
% handles = checkJava(handles,250);
% 
% % Check screen resolution. Must be positioned after handles.output.
% handles = checkScreenResolution(handles);
% 
% % Check for updates. Position this as the final before deleting splash
% handles = checkforUpdates(handles, 'https://dl.dropboxusercontent.com/u/11755763/latest%20version%20of%20decayfit.html');
% 
% % Set some GUI properties
% updateGUImenus(handles) % Updates menu checkmarks etc. Must be put after checkforUpdates.
% updateToolbar(handles) % Updates the toolbar toggle states
% 
% % Turn off some things if its deployed
% turnoffDeployed(handles);
% 
% % Initialize usage stats
% handles.use = initStats();
% 
% % Initialize axes
% linkaxes([handles.DecayWindow handles.ResWindow],'x')
% xlabel(handles.DecayWindow,'Time /ns','FontUnits','normalized')
% ylabel(handles.DecayWindow,'I(t)','FontUnits','normalized')
% xlabel(handles.ResWindow,'','FontUnits','normalized')
% ylabel(handles.ResWindow,'Res.','FontUnits','normalized')
% xlabel(handles.DistWindow,'tau /ns','FontUnits','normalized')
% ylabel(handles.DistWindow,'Fraction','FontUnits','normalized')
% 
% % Update plot
% updateplot(handles)
% plotlifetimes(handles)
% 
% % Choose default command line output for ae
% handles.output = hObject;
% 
% % Figure handles
% handles.figures = cell(1);
% handles.figures(1) = [];
% 
% % Update handles structure
% % [state,handles] = savestate(handles); % Save current GUI state
% % handles.state1 = state; % GUI state 1
% % handles.state2 = state; % GUI state 2
% updatemainhandles(handles)
% 
% % Set color of GUI objects so that they match background
% backgrColor = get(handles.mainFig,'Color'); % Get the GUI background color
% set(findobj(handles.mainFig, '-property', 'BackgroundColor','-not','BackgroundColor','white','-not','-property','data'),...
%     'BackgroundColor',backgrColor) % Set the background color to the same as the figure background color
% set(handles.RunStatus,'BackgroundColor','blue') % Set the color of the status bar back to blue

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
