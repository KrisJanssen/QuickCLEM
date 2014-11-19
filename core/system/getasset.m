function [ assetpath ] = getasset( assetname )
%GETASSET Summary of this function goes here
%   Detailed explanation goes here

assetpath = fullfile(getappdata(0,'workdirDecayFit'), 'assets', assetname);

end

