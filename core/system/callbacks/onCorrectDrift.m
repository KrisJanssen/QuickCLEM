function onCorrectDrift( source , callbackdata )
%ONLOCALIZEEVENTS Summary of this function goes here
%   Detailed explanation goes here

% Get shared data
[ ~, handles ] = getmainwindowhandles();

if isfield(handles,'XYEvents')
    
    msgbox('Select the area where there are NO markers.');
    
    %Compensate for 0 indexing in localizer.
    handles.XYEvents = arrayfun(@(x) (x + 1), temp);
    
else
    msgbox('You need to localize something first!!');

end

% Update the shared data. Matlab passes by value, not by reference.
setmainwindowhandles( handles );

updateGUI()

end
