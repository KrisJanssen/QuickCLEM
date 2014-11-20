function updateGUI( hObject )
%UPDATEGUI Summary of this function goes here
%   Detailed explanation goes here

handles = getmainwindowhandles();

imshow( imadjust( handles.streamdata{handles.currentframe,1} ), 'Parent', handles.axesFrame );

framecount = size(handles.streamdata, 1);

setuicontrolstring(handles.localizerCtrls, 'Nofframes', framecount)
setuicontrolstring(handles.localizerCtrls, 'Currframe', handles.currentframe)


try
    spotcount = size(handles.localizedXY,1);
    
    setuicontrolstring(handles.localizerCtrls, 'Noflocalizations', spotcount)
    
    if framecount ~= size(handles.localizedXY,1)
        
    end
    
    hold on
    
    X = handles.localizedXY(handles.currentframe, 1);
    Y = handles.localizedXY(handles.currentframe, 2);
    
    plot(X, Y, '.r');
    
    hold off
end

setmainwindowhandles( handles );

end

