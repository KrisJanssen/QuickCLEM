function addmainmenu()
%ADDMENU Summary of this function goes here
%   Detailed explanation goes here

% Get the main app window and the handles
[ hfig, handles ] = getmainwindowhandles();

% Make sure the menus are not already there...
existingmenus = findall( hfig, 'Type', 'uimenu' );

arrayfun(@(x) delete(x), existingmenus);

FileMenu = uimenu( hfig, 'Label', 'File' );
uimenu( FileMenu, 'Label', 'Open CL', 'Callback', @onCLOpen );
uimenu( FileMenu, 'Label', 'Open SEM', 'Callback', @onSEMOpen );
uimenu( FileMenu, 'Label', 'Open Events', 'Callback', @onEventsOpen );
uimenu( FileMenu, 'Label', 'Exit', 'Callback', @onExit );

% Store the handles to the new menu
handles.filemenu = FileMenu;
guidata(hfig, handles);

end