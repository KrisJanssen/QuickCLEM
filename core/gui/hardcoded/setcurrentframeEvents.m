function setcurrentframeEvents( value )
%SETCURRENTFRAMEEVENTS Summary of this function goes here
%   Detailed explanation goes here

[ ~, handles ] = getmainwindowhandles();

handles.currentframeEvents = value;

setmainwindowhandles( handles );

updateGUI()

end

