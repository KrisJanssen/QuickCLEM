function onLocalizeEvents( source , callbackdata )
%ONLOCALIZEEVENTS Summary of this function goes here
%   Detailed explanation goes here

% Get shared data
[ ~, handles ] = getmainwindowhandles();

if ~strcmp(handles.fileEvents, '')
    
    filePath = strcat(handles.pathEvents, handles.fileEvents);
    
    Psfwidth = str2double(getuicontrolstring(handles.localizerEvents, 'Psfwidth'));
    Pfa = str2double(getuicontrolstring(handles.localizerEvents, 'Pfa'));
    
    localizedPositions = LocalizerMatlab('localize', Psfwidth, 'glrt', Pfa, '2DGauss', filePath);
    
    %Select the needed data
    cols = [ 1 4 5 ];
    temp = localizedPositions(:,cols);
    
    %Compensate for 0 indexing in localizer.
    handles.XYEvents = arrayfun(@(x) (x + 1), temp);
    
end

% Update the shared data. Matlab passes by value, not by reference.
setmainwindowhandles( handles );

updateGUI()

end

