function onEventsOpen( hObject, eventdata, handles )
%ONEVENTSOPEN Summary of this function goes here
%   Detailed explanation goes here

[ ~, handles ] = getmainwindowhandles();

[file, path] = uigetfile({'*.txt';'*.tif';'*.his'}, ...
    'Select the XY coordinate file or movie');

[ ~, filename, ext ] = fileparts(file);

if path == 0
    return
else
    
    % User could supply pre localized data in 3 column format:
    % 1) Frame number
    % 2) X
    % 3) Y
    if ext == '.txt'
        
        try
            
            handles.XYEvents = csvread( strcat(path, file) );
            
        catch
            
        end
        
    else
        
        % Set the shared data.
        handles.streamEvents = loadstream(strcat(path, file));
        handles.currentframeEvents = 1;
        enablechildcontrols(handles.localizerEvents)
        
    end

end


% Save handles
setmainwindowhandles(handles);

updateGUI();

end

