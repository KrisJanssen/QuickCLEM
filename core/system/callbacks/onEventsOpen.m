function onEventsOpen( hObject, eventdata, handles )
%ONEVENTSOPEN Summary of this function goes here
%   Detailed explanation goes here

% Get main window and corresponding handles.
mainWindow = getappdata(0, 'mainWindow');

handles = guidata( mainWindow );

[file, path] = uigetfile({'*.txt'}, ...
    'Select the XY coordinate file');

if path == 0
    return
else
    
    try
        
        handles.eventsXY = csvread( strcat(path, file) );
        
    catch
        
    end

% Save handles
guidata( hObject, handles);

end

