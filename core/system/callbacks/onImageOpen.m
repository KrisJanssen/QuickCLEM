function onImageOpen( hObject, eventdata, handles )
%ONIMAGEOPEN Summary of this function goes here
%   Detailed explanation goes here

[ ~, handles ] = getmainwindowhandles();

[file, path] = uigetfile({'*.tif'}, ...
    'Select the image');

if path == 0
    return
else
    
    handles.pathImage = path;
    handles.fileImage = file;
    
    handles.im = imread(strcat(path, file));

end

handles.imagemode = 1;

% Save handles
setmainwindowhandles(handles);

updateGUI();

end

