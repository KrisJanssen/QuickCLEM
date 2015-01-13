function onCLOpen( hObject, eventdata, handles )
%ONFILEOPEN Summary of this function goes here
%   Detailed explanation goes here

% Get handles to shared data.
[ ~, handles ] = getmainwindowhandles();

% File open UI.
[file, path] = uigetfile({'*.tif';'*.HIS'}, ...
    'Select the CCD stream file');

if path == 0
    return
else
    handles.pathCL = path;
    handles.fileCL = file;
    
    % Set the shared data.
    handles.streamCL = loadstream(strcat(path, file));
    handles.currentframeCL = 1;
    
end

% Update handles to shared data
setmainwindowhandles(handles);

% Update GUI. This needs to happen after handles are set.
updateGUI()
end

