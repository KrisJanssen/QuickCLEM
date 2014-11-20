function setmainwindowhandles( handles )
%SETMAINWINDOWHANDLES Summary of this function goes here
%   Detailed explanation goes here

href = getappdata( 0,'mainWindow' );
guidata( href, handles );

end

