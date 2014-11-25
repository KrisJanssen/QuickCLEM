function dataset = loadstream( fullpath )
%LOADSTREAM Summary of this function goes here
%   Detailed explanation goes here

try
    % Store the path and file info. This callback should not have any other
    % functionality/responsability.
    %handles.filename = file;
    %handles.path = path;
    
    
    % Show a modal while we are busy
    h = showbusy;
    pause(0.1);
    
    rawdata = bfopen( fullpath );
    dataset = rawdata{1, 1};
    
    %slider = handles.axesSlider;
    
%     maxVal = size(dataset, 1);
%     stepVal = 1 / (maxVal - 1);
%     set(slider,'Min', 1, 'Max', maxVal, 'Sliderstep', [stepVal , stepVal], 'Value', 1);
    
%     handles.currentframe = 1;
%     
%     [~,name,~] = fileparts(file);
%     
%     filenametxt = strcat(name, '.txt');
%     
%     handles.SEMXY = csvread( strcat(path, filenametxt) );
    
    %guidata( hObject, handles);
    
    % Get rid of the modal
    showbusy(h);
catch error
    showbusy(h);
    
    rethrow(error);
end

end

