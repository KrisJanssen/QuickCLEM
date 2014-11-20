function handles = getmainwindowhandles( )
%GETMAINWINDOWHANDLES Summary of this function goes here
%   Detailed explanation goes here

href = getappdata( 0,'mainWindow' );
handles = guidata( href );

end

