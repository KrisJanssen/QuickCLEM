function [ dataset ] = loadstream( fullpath )
%LOADSTREAM Summary of this function goes here
%   Detailed explanation goes here

    dataset = bfopen( fullpath );
    %maxVal = size(handles.data, 1);
    %stepVal = 1 / (maxVal - 1);
    %set(handles.sliderFrame,'Min', 1, 'Max', maxVal, 'Sliderstep', [stepVal , stepVal], 'Value', 1);
    %imshow(handles.data{1,1}{1,1}, 'Parent', handles.axesFrame);

end

