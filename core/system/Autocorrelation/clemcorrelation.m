function [ transformedpoints, transform ] = clemcorrelation( FixedPoints, LocalizedCLPoints, LocalizedEventPoints )
%CLEMCORRELATION Summary of this function goes here
%   Detailed explanation goes here
%
% FixedPoints is a 2 column matrix holding X (1st column) and Y (2nd
% column) coordinates of alignment CL spots in the SEM coordinate system
%
% LocalizedCLPoints is a 3 column matrix holding frame numbers (1st
% column), X coordinates (2nd column) and Y coordinates (3rd column) for
% the CL spots localized in the WF images.
%
% LocalizedEventPoints is a 2 column matrix holding X and Y coordinates for
% whatever events, localized in the WF images, we might want to correlate.

% Get handles to shared data.
[ ~, handles ] = getmainwindowhandles();

% Localizer will store the frames numbers for CL spots that were actually
% localized in the first column of LocalizedCLPoints. We therefore only
% retain those indexes in FixedPoints.
FixedPointsScreened = FixedPoints(LocalizedCLPoints(:,1),:);

% We retrieve the transformation matrix between both sets of coordinates.
% I.e. the CL spot coordinates in the SEM coordinate system versus the same
% in the WF coordinate system.
[transform, ~, ~] = estimateGeometricTransform( ...
    LocalizedCLPoints(:,[2 3]), FixedPointsScreened, 'projective');

if handles.imagemode
    % We need to apply the transformation matrix to the image. The imref2d
    % output as the last argument ensures that the output image is nicely
    % referenced to the confines of the original image.
    handles.imt = imwarp(...
        handles.im, transform, ...
        'OutputView',...
        imref2d(size(handles.im)));
    
    transformedpoints = 0;
else
    % We correct the LocalizedEventPoints array according to the 
    % transformation matrix.
    transformedpoints = tformfwd( ...
        maketform('projective', transform.T), LocalizedEventPoints);
end

setmainwindowhandles(handles);
    
updateGUI();

end

