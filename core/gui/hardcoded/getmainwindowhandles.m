function [ hfig, handles ] = getmainwindowhandles( )
%GETMAINWINDOWHANDLES Summary of this function goes here
%   Detailed explanation goes here

hfig = getappdata( 0,'mainWindow' );
handles = guidata( hfig );

end

