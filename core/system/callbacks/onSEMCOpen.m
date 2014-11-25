function onSEMCOpen( hObject, eventdata, handles )
%ONSEMCOPEN Summary of this function goes here
%   Detailed explanation goes here

% Get handles to shared data.
[ ~, handles ] = getmainwindowhandles();

% File open UI.
[file, path] = uigetfile({'*.txt'}, ...
    'Select the SEM coordinates');

if path == 0
    return
else
    
    handles.XYSEM = csvread( strcat(path, file) );
    
end

setmainwindowhandles(handles);
    
updateGUI();

end

