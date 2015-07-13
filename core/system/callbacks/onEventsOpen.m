function onEventsOpen( hObject, eventdata, handles )
%ONEVENTSOPEN Summary of this function goes here
%   Detailed explanation goes here

[ ~, handles ] = getmainwindowhandles();

prompt = 'Is the event data stored in multiple movies? If so, how many? ';
numfiles = inputdlg(prompt);

[file, path] = uigetfile({'*.tif';'*.his';'*.txt'}, ...
    'Select the XY coordinate file or movie');

if path == 0
    return
else
    
    [ ~, filename, ext ] = fileparts(file);
    
    handles.pathEvents = path;
    handles.fileEvents = file;
    
    % User could supply pre localized data in 3 column format:
    % 1) Frame number
    % 2) X
    % 3) Y
    if strcmp(ext, '.txt')
        
        try
            
            raw = csvread( strcat(path, file) );
            cols = [ 1 4 5 ];
            handles.XYEvents = raw(:,cols);
            
        catch
            
        end
        
    else
        
        handles.streamEvents = loadstream(strcat(path, file));
        
        % Load any additional parts of the data set we might have.
        if numfiles > 1
            for k = 2:numfiles
                currentfile = strcat(path,filename(1:end-1),num2str(k),ext);
                handles.streamEvents = [ handles.streamEvents; loadstream(currentfile) ];
            end
        end
        
        handles.currentframeEvents = 1;
        enablechildcontrols(handles.localizerEvents)
        
    end

end

% Save handles
setmainwindowhandles(handles);

updateGUI();

end

