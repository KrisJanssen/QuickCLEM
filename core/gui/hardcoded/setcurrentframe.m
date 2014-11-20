function setcurrentframe( value )
%SETCURRENTFRAME Summary of this function goes here
%   Detailed explanation goes here

[ ~, handles ] = getmainwindowhandles();

handles.currentframe = value;

setmainwindowhandles( handles );

updateGUI()

end

