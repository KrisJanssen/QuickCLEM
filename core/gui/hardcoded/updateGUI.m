function updateGUI( hObject )
%UPDATEGUI Summary of this function goes here
%   Detailed explanation goes here

[ ~, handles ] = getmainwindowhandles();

% Clear the CL sport display
cla(handles.axesFrame)

% Hold on, we are going to draw a frame + localized spots.
hold on
imshow( imadjust( handles.streamdata{handles.currentframe,1} ), 'Parent', handles.axesFrame );

% Get current frame.
framecount = size(handles.streamdata, 1);

setuicontrolstring(handles.localizerCtrls, 'Nofframes', framecount)
setuicontrolstring(handles.localizerCtrls, 'Currframe', handles.currentframe)

% Try to paint the localized spot. We use the try because the data for
% localization is not necessarily available. This is probably not the best
% way to do but it works for now...
try
    spotcount = size(handles.localizedXY,1);
    
    setuicontrolstring(handles.localizerCtrls, 'Noflocalizations', spotcount)
    
    localizedframe = find(handles.localizedXY(:,1) == handles.currentframe);
    
    if localizedframe
        
        X = handles.localizedXY(localizedframe, 2);
        Y = handles.localizedXY(localizedframe, 3);
        
        plot(handles.axesFrame, X, Y, '.r');
        
    end
    
catch
    % Do nothing. 
end

% Done, hold off.
hold off

try
    
    %axes(handles.axesCLGrid);
    cla(handles.axesCLGrid);
    
    plot(handles.axesCLGrid, ...
        handles.localizedXY(:, 2), ...
        handles.localizedXY(:, 3), '.r');
    
catch
    % Do nothing
end

try
    
    %axes(handles.axesCLGrid);
    cla(handles.axesSEMGrid);
    
    plot(handles.axesSEMGrid, ...
        handles.SEMXY(:, 1), ...
        handles.SEMXY(:, 2), '.r');
    
catch
    % Do nothing
end

try
    imshow( imadjust( handles.imageSEM ), 'Parent', handles.axesSEM );
catch
    % Do nothing
end

setmainwindowhandles( handles );

end

