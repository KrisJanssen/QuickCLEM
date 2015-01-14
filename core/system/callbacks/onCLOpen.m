function onCLOpen( hObject, eventdata, handles )
%ONFILEOPEN Summary of this function goes here
%   Detailed explanation goes here

% Get handles to shared data.
[ ~, handles ] = getmainwindowhandles();

% File open UI.
[file, path] = uigetfile({'*.tif';'*.HIS'}, ...
    'Select the CCD stream file');

% We will attempt to auto-load the CL spot coordinate file (.txt). For that
% purpose, we need to replace the extension of the CL movie file (assuming 
% both files have the same name otherwise).
[~,filename,~] = fileparts( strcat(path, file) );

if path == 0
    return
else
    handles.pathCL = path;
    handles.fileCL = file;
    
    % Set the shared data.
    handles.streamCL = loadstream( strcat(path, file) );
    handles.currentframeCL = 1;
    
    % Try to get the coordinate .txt file.
    try
        handles.XYSEM = csvread( strcat(path, filename, '.txt') );
    end
    
end

% Update handles to shared data
setmainwindowhandles(handles);

% Update GUI. This needs to happen after handles are set.
updateGUI()
end

