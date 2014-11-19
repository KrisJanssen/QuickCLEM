function addmainmenu( hfig )
%ADDMENU Summary of this function goes here
%   Detailed explanation goes here

    % Get the main app window and the handles
    %hfig = getappdata(0, 'mainWindow');
    handles = guidata(hfig);
    
    % Build the menu
    FileMenu = uimenu( hfig, 'Label', 'File' );
    uimenu( FileMenu, 'Label', 'Open', 'Callback', @onFileOpen );
    uimenu( FileMenu, 'Label', 'Exit', 'Callback', @onExit );
    
    % Store the handles to the new menu
    handles.filemenu = FileMenu;
    guidata(hfig, handles);

end