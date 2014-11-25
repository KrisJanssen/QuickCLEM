function setcurrentframeCL( value )
%SETCURRENTFRAME Summary of this function goes here
%   Detailed explanation goes here

[ ~, handles ] = getmainwindowhandles();

handles.currentframeCL = value;

setmainwindowhandles( handles );

updateGUI()

end

