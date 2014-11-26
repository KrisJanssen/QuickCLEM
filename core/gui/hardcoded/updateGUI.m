function updateGUI()
%UPDATEGUI takes care of updating the UI based on available data.
%   The important UI members are:
%

[ ~, handles ] = getmainwindowhandles();

%% CL related controls

% Clear the CL sport display
cla(handles.axesCL)

% Get correct axes and turn hold on, draw a frame + localized spots.
axes(handles.axesCL)

% We are going to add additional stuff, so enable hold.
hold on

% Show the image.
if handles.currentframeCL > 0
    imshow( imadjust( handles.streamCL{handles.currentframeCL,1} ) );
end

axis(handles.axesCL, 'square', [0 512 0 512]);

% Get the amount of frames.
framecountCL = size(handles.streamCL, 1);

% If necessary, set the range on the slider for moving through the stack.
updateslider(handles.sliderCL, framecountCL);

% Update some values on the UI.
setuicontrolstring(handles.localizerCL, 'Nofframes', framecountCL)
setuicontrolstring(handles.localizerCL, 'Currframe', handles.currentframeCL)

% Try to paint the localized spot. We use the try because the data for
% localization is not necessarily available. This is probably not the best
% way to do but it works for now...
try
    
    spotcount = size(handles.XYCL,1);
    
    setuicontrolstring(handles.localizerCL, 'Noflocalizations', spotcount)
    
    localizedframe = find(handles.XYCL(:,1) == handles.currentframeCL);
    
    if localizedframe
        
        X = handles.XYCL(localizedframe, 2);
        Y = handles.XYCL(localizedframe, 3);
        
        plot(X, Y, '.r');
        
    end
    
catch
    % Do nothing.
end

% Done, hold off.
hold off

% Enable relevant controls
if handles.currentframeCL > 0
    enablechildcontrols(handles.localizerCL)
end

%% Compare related controls

% axesCompareSEM
try
    
    cla(handles.axesCompare);
    
    axes(handles.axesCompare);
    
    % Where the CL spots should be.
    plot(handles.axesCompare, ...
        handles.XYSEM(:, 1), ...
        handles.XYSEM(:, 2), 'xb');
    
    hold on
    
    % Where they actually are.
    plot(handles.axesCompare, ...
        handles.XYCL(:, 2), ...
        handles.XYCL(:, 3), '.r');
    
    hold off
    
    axis(handles.axesCompare, 'square', [0 512 0 512]);
    title(handles.axesCompare, 'SEM vs. localized coordinates')
    
catch
    % Do nothing
end

%% Events related controls

% Clear the CL sport display
cla(handles.axesEvents)

% Get correct axes and turn hold on, draw a frame + localized spots.
axes(handles.axesEvents)

% We are going to add additional stuff, so enable hold.
hold on

% Show the image.
if handles.currentframeEvents > 0
    imshow( imadjust( handles.streamEvents{handles.currentframeEvents,1} ) );
end

axis(handles.axesEvents, 'square', [0 512 0 512]);

% Get the amount of frames.
framecountEvents = size(handles.streamEvents, 1);

% If necessary, set the range on the slider for moving through the stack.
updateslider(handles.sliderEvents, framecountEvents);

% Update some values on the UI.
setuicontrolstring(handles.localizerEvents, 'Nofframes', framecountEvents)
setuicontrolstring(handles.localizerEvents, 'Currframe', handles.currentframeEvents)

% Try to paint the localized spot. We use the try because the data for
% localization is not necessarily available. This is probably not the best
% way to do but it works for now...
try
    
    spotcount = size(handles.XYEvents,1);
    
    setuicontrolstring(handles.localizerEvents, 'Noflocalizations', spotcount)
    
    localizedframe = find(handles.XYEvents(:,1) == handles.currentframeEvents);
    
    if localizedframe
        
        X = handles.XYEvents(localizedframe, 2);
        Y = handles.XYEvents(localizedframe, 3);
        
        plot(X, Y, '.r');
        
    end
    
catch
    % Do nothing.
end

% Done, hold off.
hold off

% Enable relevant controls
if handles.currentframeEvents > 0
    enablechildcontrols(handles.localizerEvents)
end

%% SEM related controls

try
    imshow(imadjust(handles.imageSEM), 'Parent', handles.axesSEM);
catch
    % Do nothing
end

%% Registration related controls

setmainwindowhandles( handles );

end

