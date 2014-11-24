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
hBoxComp = uix.HBox('Parent', tabPanel);
hBoxSEM = uix.HBox('Parent', tabPanel);
hBoxResult = uix.HBox('Parent', tabPanel, 'BackgroundColor', 'b');

tabPanel.TabTitles = {'CL', 'Compare', 'SEM', 'Result'};
tabPanel.Selection = 1;

handles = addtabCLcontrols(hBoxCL, handles);
handles = addtabComparecontrols(hBoxComp, handles);
handles = addtabSEMcontrols(hBoxSEM, handles);



%% Finally

% Set handles
setmainwindowhandles(handles);

end

