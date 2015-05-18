function onLocalizeEvents( source , callbackdata )
%ONLOCALIZEEVENTS Summary of this function goes here
%   Detailed explanation goes here

% Get shared data
[ ~, handles ] = getmainwindowhandles();

if ~strcmp(handles.fileEvents, '')
    
    filePath = strcat(handles.pathEvents, handles.fileEvents);
    
    [ ~, filename, ext ] = fileparts(handles.fileEvents);
    
    Psfwidth = str2double(getuicontrolstring(handles.localizerEvents, 'Psfwidth'));
    Pfa = str2double(getuicontrolstring(handles.localizerEvents, 'Pfa'));
    
    localizedPositions = LocalizerMatlab('localize', Psfwidth, 'glrt', Pfa, '2DGauss', filePath);
    localizedPositions(:, 1) = localizedPositions(:, 1) + 1;
    
    numfiles = 5;

    for k = 2:numfiles
         currentfile = strcat(handles.pathEvents,filename(1:end-1),num2str(k),ext);
         localizedPositionsTemp = LocalizerMatlab('localize', Psfwidth, 'glrt', Pfa, '2DGauss', currentfile);
         
%          if k == 2
%              localizedPositionsTemp = localizedPositionsTemp(localizedPositionsTemp(:,1) > 15,:);
%              localizedPositionsTemp(:,1) = localizedPositionsTemp(:,1) - 15;
%          end
         noFrames = max(localizedPositionsTemp(:,1)) + 1;
         localizedPositionsTemp(:,1) = localizedPositionsTemp(:,1) + (k - 1) * noFrames + 1;
         localizedPositions = [ localizedPositions; localizedPositionsTemp ];
    end
    
    %Select the needed data
    cols = [ 1 4 5 ];
    temp = localizedPositions(:,cols);
    
    %Compensate for 0 indexing in localizer.
    %handles.XYEvents = arrayfun(@(x) (x + 1), temp);
    handles.XYEvents = temp;
    
end

% Update the shared data. Matlab passes by value, not by reference.
setmainwindowhandles( handles );

updateGUI()

end

