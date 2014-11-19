function onSlideMove( source , callbackdata )
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Get the slider value and round it to the closest int
% value = round(get(hObject,'Value'));
% 
% % Show the slider value to the user
% set (handles.textboxFN, 'String', value);
% 
% % Select the proper image to show.
% imshow(imadjust(handles.data{value,1}{1,1}), 'Parent', handles.axesFrame);

value = round(get( source, 'Value' ));

href = getappdata(0,'mainWindow');
handles = guidata( href );

imshow(imadjust(handles.streamdata{value,1}), 'Parent', handles.axesFrame);

end



