function onFileOpen( hObject, eventdata, handles )
%ONFILEOPEN Summary of this function goes here
%   Detailed explanation goes here

mainWindow = getappdata(0, 'mainWindow');

handles = guidata( mainWindow );

[file, path] = uigetfile({'*.HIS';'*.tif'}, ...
    'Select the Hamamatsu stream file');

if path == 0
    return
else
    
    try
        % Store the path and file info. This callback should not have any other
        % functionality/responsability.
        handles.filename = file;
        handles.path = path;
        
        % Show a modal while we are busy
        h = showbusy;
        pause(0.1);
        
        data = loadstream( strcat(path, file) );
        handles.streamdata = data{1, 1};
        
        slider = handles.axesSlider;
        
        maxVal = size(handles.streamdata, 1);
        stepVal = 1 / (maxVal - 1);
        set(slider,'Min', 1, 'Max', maxVal, 'Sliderstep', [stepVal , stepVal], 'Value', 1);
        
        
        
        enablechildcontrols(handles.localizerCtrls);
        
        imshow(imadjust(handles.streamdata{1,1}), 'Parent', handles.axesFrame);
        
        guidata( hObject, handles);
        
        % Get rid of the modal
        showbusy(h);
    catch error
        showbusy(h);
        
        rethrow(error);
    end
    
end

