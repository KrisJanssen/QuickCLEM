function onSEMZOpen( hObject, eventdata, handles )
%ONSEMOPEN Summary of this function goes here
%   Detailed explanation goes here

[ hfig, handles ] = getmainwindowhandles();

[file, path] = uigetfile({'*.tif'}, ...
    'Select the SEM image');

if path == 0
    return
else
    
    handles.filenameSEMZ = file;
    handles.pathSEMZ = path;
    
    handles.imageSEMZ = imread(strcat(path,file));
    handles.infoSEMZ = imfinfo(strcat(path,file));
    
    setmainwindowhandles( handles );
    
    updateGUI()
    
end