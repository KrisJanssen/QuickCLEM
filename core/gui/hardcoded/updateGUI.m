function updateGUI( hObject )
%UPDATEGUI Summary of this function goes here
%   Detailed explanation goes here

[ ~, handles ] = getmainwindowhandles();

imshow( imadjust( handles.streamdata{handles.currentframe,1} ), 'Parent', handles.axesFrame );

framecount = size(handles.streamdata, 1);

setuicontrolstring(handles.localizerCtrls, 'Nofframes', framecount)
setuicontrolstring(handles.localizerCtrls, 'Currframe', handles.currentframe)


try
    spotcount = size(handles.localizedXY,1);
    
    setuicontrolstring(handles.localizerCtrls, 'Noflocalizations', spotcount)
    
    localizedframe = find(handles.localizedXY(:,1) == handles.currentframe);
    
    if localizedframe

        hold on
        
        X = handles.localizedXY(localizedframe, 2);
        Y = handles.localizedXY(localizedframe, 3);
        
        plot(X, Y, '.r');
        
        hold off
    end
end

setmainwindowhandles( handles );

end

