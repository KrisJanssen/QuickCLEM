function onRegister( source , callbackdata )
%ONREGISTER Summary of this function goes here
%   Detailed explanation goes here

[ ~, handles ] = getmainwindowhandles();

% For debug only: Plug in some coordinates of the events here...
%handles.XYEvents = [ 414 53; 23 220 ];
%handles.XYEvents = handles.XYSEM;

[ transformedpoints, transform ] = clemcorrelation( ...
    handles.XYSEM, ...
    handles.XYCL, ...
    handles.XYEvents )

performoverlay( transformedpoints, handles.imageSEM, handles.infoSEM, 1, 500e-009)

setmainwindowhandles(handles);

end

