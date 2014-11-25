function onSEMOpen( hObject, eventdata, handles )
%ONSEMOPEN Summary of this function goes here
%   Detailed explanation goes here

[ hfig, handles ] = getmainwindowhandles();

[file, path] = uigetfile({'*.tif'}, ...
    'Select the SEM image');

if path == 0
    return
else
    
    handles.filenameSEM = file;
    handles.pathSEM = path;
    
    handles.imageSEM = imread(strcat(path,file));
    handles.infoSEM = imfinfo(strcat(path,file));
    
    setmainwindowhandles( handles );
    
    updateGUI()
    
end

