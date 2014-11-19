function onLocalize( source , callbackdata )
%ONLOCALIZE Summary of this function goes here
%   Detailed explanation goes here

href = getappdata(0,'mainWindow');
handles = guidata( href );

filePath = strcat(handles.path, handles.filename);

psfWidth = 3; %in pixels
pfa = 50;

localizedPositions = LocalizerMatlab('localize', psfWidth, 'glrt', pfa, '2DGauss', filePath)

end

