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
    
    % Get rid of the modal
    showbusy(h);
catch error
    showbusy(h);
    
    rethrow(error);
end

end

