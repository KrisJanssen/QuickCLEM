function addmaincontrols()
%ADDCONTROLS Summary of this function goes here
%   Detailed explanation goes here

% Get the main window and its handles structure (holding references to all
% controls on it.

[ hfig, handles ] = getmainwindowhandles();

tabPanel = uix.TabPanel('Parent', hfig, ...
    'Padding', 5);

% Add principal layout boxes
hBoxCL = uix.HBox('Parent', tabPanel);
hBoxCompare = uix.HBox('Parent', tabPanel);
hBoxEvents = uix.HBox('Parent', tabPanel);
hBoxImage = uix.HBox('Parent', tabPanel);
hBoxSEM = uix.HBox('Parent', tabPanel);
hBoxRegistration = uix.HBox('Parent', tabPanel, 'BackgroundColor', 'b');

tabPanel.TabTitles = {'CL', 'Compare', 'Events', 'Image' 'SEM', 'Registration'};
tabPanel.Selection = 1;

handles = addtabCL(hBoxCL, handles);
handles = addtabCompare(hBoxCompare, handles);
handles = addtabEvents(hBoxEvents, handles);
handles = addtabImage(hBoxImage, handles);
handles = addtabSEM(hBoxSEM, handles);
handles = addtabRegistration(hBoxRegistration, handles);



%% Finally

% Set handles
setmainwindowhandles(handles);

end

