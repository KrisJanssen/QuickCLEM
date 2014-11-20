function onLocalize( source , callbackdata )
%ONLOCALIZE Summary of this function goes here
%   Detailed explanation goes here

% Get shared data
handles = getmainwindowhandles();

filePath = strcat(handles.path, handles.filename);

% psfWidth = 3; %in pixels
% pfa = 50;

Psfwidth = str2double(getuicontrolstring(handles.localizerCtrls, 'Psfwidth'));
Pfa = str2double(getuicontrolstring(handles.localizerCtrls, 'Pfa'));

localizedPositions = LocalizerMatlab('localize', Psfwidth, 'glrt', Pfa, '2DGauss', filePath);

%Select the needed data
cols = [ 1 4 5 ];
temp = localizedPositions(:,cols)

%Compensate for 0 indexing in localizer.
handles.localizedXY = arrayfun(@(x) (x + 1), temp);

% Update the shared data. Matlab passes by value, not by reference.
setmainwindowhandles( handles );

updateGUI()

end

