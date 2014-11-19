function updateGUI( hObject )
%UPDATEGUI Summary of this function goes here
%   Detailed explanation goes here

handles = guidata(hObject);

if handles.uibusy
   
    
    
    InterfaceObj=findobj(hObject,'Enable','on');
    set(InterfaceObj,'Enable','off');
    
else
    
    InterfaceObj=findobj(hObject,'Enable','off');
    set(InterfaceObj,'Enable','on');
    
end

guidata( hObject, handles);


end

