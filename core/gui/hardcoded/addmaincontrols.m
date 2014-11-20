function addmaincontrols()
%ADDCONTROLS Summary of this function goes here
%   Detailed explanation goes here

% Get the main window and its handles structure (holding references to all
% controls on it.

[ hfig, handles ] = getmainwindowhandles();

tabPanel = uix.TabPanel('Parent', hfig, ...
    'Padding', 5);

% Add principal layout boxes
hBoxCL = uix.HBox('Parent', tabPanel, 'BackgroundColor', 'b');
hBoxSEM = uix.HBox('Parent', tabPanel, 'BackgroundColor', 'b');
hBoxResult = uix.HBox('Parent', tabPanel, 'BackgroundColor', 'b');

tabPanel.TabTitles = {'CL', 'SEM', 'Result'};
tabPanel.Selection = 1;

handles = addtabCLcontrols(hBoxCL, handles);



%% Finally

% Set handles
setmainwindowhandles(handles);

end

