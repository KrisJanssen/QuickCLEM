function [ output_args ] = onSEMOpen( input_args )
%ONSEMOPEN Summary of this function goes here
%   Detailed explanation goes here

[file, path] = uigetfile({'*.tif'}, ...
    'Select the SEM image');

end

