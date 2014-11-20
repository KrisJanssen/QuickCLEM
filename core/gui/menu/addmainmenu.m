function addmainmenu( hfig )
%ADDMENU Summary of this function goes here
%   Detailed explanation goes here

% Get the main app window and the handles
%hfig = getappdata(0, 'mainWindow');
handles = guidata(hfig);
% 
% if exist('handles.filemenu','var') %if it's there, delete it.
%     delete(mh);
% end

% Build the menu

% Make sure the menus are not already there...
existingmenus = findall( hfig, 'Type', 'uimenu' );

arrayfun(@(x) delete(x), existingmenus);

FileMenu = uimenu( hfig, 'Label', 'File' );
uimenu( FileMenu, 'Label', 'Open CL', 'Callback', @onFileOpen );
uimenu( FileMenu, 'Label', 'Open SEM', 'Callback', @onSEMOpen );
uimenu( FileMenu, 'Label', 'Exit', 'Callback', @onExit );

% Store the handles to the new menu
handles.filemenu = FileMenu;
guidata(hfig, handles);

end