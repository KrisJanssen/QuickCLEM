function onRegister( source , callbackdata )
%ONREGISTER Summary of this function goes here
%   Detailed explanation goes here

[ ~, handles ] = getmainwindowhandles();

% Plug in the coordinates of the events here...
LocalizedEventPoints = [ 414 53; 1 2; 23 564 ];

[ transformedpoints, transform ] = clemcorrelation( handles.SEMXY, handles.localizedXY, LocalizedEventPoints )

performoverlay( LocalizedEventPoints, handles.imageSEM, handles.infoSEM, 1, 1)

setmainwindowhandles(handles);

end

