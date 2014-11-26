function onSEMOOpen( hObject, eventdata, handles )
%ONSEMOPEN Summary of this function goes here
%   Detailed explanation goes here

[ hfig, handles ] = getmainwindowhandles();

[file, path] = uigetfile({'*.tif'}, ...
    'Select the SEM image');

if path == 0
    return
else
    
    handles.filenameSEMO = file;
    handles.pathSEMO = path;
    
    handles.imageSEMO = imread(strcat(path,file));
    handles.infoSEMO = imfinfo(strcat(path,file));
    
    setmainwindowhandles( handles );
    
    updateGUI()
    
end

