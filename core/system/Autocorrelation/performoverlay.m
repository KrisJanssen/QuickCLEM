function performoverlay( transformedPoints, imageSEMO, infoSEMO, imageSEMZ, infoSEMZ, ShiftX, ShiftY, BinWidth)
%PERFORMOVERLAY Creates an events on SEM overlay image.
%   Parameters:
%   
%   transformedPoints:  The XY coordinates of events to overlay expressed
%                       as pixel coordinates in the 512 * 512 raster that 
%                       constitutes the central part of the SEM image as 
%                       scanned.
%   imageSEMO:          The SEM overview image
%   infoSEMO:           Info on the SEM overview image
%   imageSEMZ:          The SEM zoom image
%   infoSEMO:           Into on the SEM zoom image
%   ShiftX:             A corrective shift for the overlay in X (in nm)
%   ShiftY              A corrective shift for the overlay in Y (in nm)
%   BinWidth:           Preferred width of overlay binning in nm

% Generate a figure.
% Get the client screen size
scrsz = get(groot,'ScreenSize');

% Create a figure that is fully maximized
figure('Position',[1 1 scrsz(3) scrsz(4)])

% Within this figure, generate the first of two plots.
overlayedSEM = subplot(1,2,1);

% Get the dimensions of the SEM image in pixels, here, the annotation bar
% is included!
SEMImageWidth = infoSEMO.Width;
SEMImageHeight = infoSEMO.Height;

% The image tif contains metadata that is non-standard. From it, we get the
% width of a pixel in meters. We start looking for it at the 'PixelWidth='
% tag and we use a regex to get the number.
%
% Note that, because of the way the SEM records images, pixel width = pixel
% height.
%
% Optionally a - or a +: (\-|\+)?
% Any number of digits, a dot and again any number of digits: \d+\.\d+
% e
% Optionally a - or a +: (\-|\+)?
% Any number of digits: \d+
regex = 'PixelWidth\=(\-|\+)?\d+\.\d+e(\-|\+)?\d+';

rawPixelWidthO = infoSEMO.UnknownTags.Value;
rawPixelWidthZ = infoSEMZ.UnknownTags.Value;

pixelWidthO = strrep( ...
    regexp(rawPixelWidthO,regex,'match'), ...
    'PixelWidth=', ...
    '');

pixelWidthZ = strrep( ...
    regexp(rawPixelWidthZ,regex,'match'), ...
    'PixelWidth=', ...
    '');

% Convert to a numeric value. Again this value is identical for X and Y.
PixelResolutionO = str2double(pixelWidthO(1));
PixelResolutionZ = str2double(pixelWidthZ(1));

% SEM scans images as 768 * 512 raster. The tiff is thus oversampled.
OverSample = SEMImageWidth / 768;

% Physical width of the image in m. Because the pixel size is the same in X
% and Y and because no. of pixels in X is higher than in Y (rectangluar
% images instead of square) the field of view in X and Y is of course
% different in size.
HFWO = SEMImageWidth * PixelResolutionO;
HFWZ = SEMImageWidth * PixelResolutionZ;

% The CL spots are layed out around the ROI so we have an overview image 
% and the actual detail image. We need the scale factor between both
% images.
ZoomFactor = HFWO / HFWZ;

% Since the SEM scans a 768 * 512 raster and we know the oversampling
% factor from the X dimension, we can work out the width of the annotation
% band on the SEM output and get rid of it.
SEMImageHeightCropped = OverSample * 512;

% Crop only the actual image.
imageSEMOCropped = imageSEMO( ...
    1:SEMImageHeightCropped , ...
    1:SEMImageWidth );

imageSEMZCropped = imageSEMZ( ...
    1:SEMImageHeightCropped , ...
    1:SEMImageWidth );

% Paint this image.
imshow( imadjust( imageSEMOCropped ) );

axis image;

% Transform raster 512 * 512 (row * col) coordinates to SEM image pixel 
% coordinates.
% We also need to shift by 128 in X since the EM-CCD is 512 * 512 so there
% will be 128 borders on each side because the SEM actually records on a
% 768 * 512 grid.
% Of course, we also correct for the oversampling of the actual TIFF.
pointsScaled(:,1) = ((transformedPoints(:,1) + 128) * OverSample);
pointsScaled(:,2) = ((transformedPoints(:,2)) * OverSample);

% Initialize a matrix holding the event points in 'zoomed in' coordinates.
pointsScaledZoom = pointsScaled;

% The actual zoom calculation on event points. 
% We assume the overview and detail image are perfectly 
% centered (which is likely not entirely true).
% To zoom in, we translate the coordinates such that the origin is in the
% center of the frame. Then we only need to multiply by the ZoomFactor and
% translate back.
% We also apply the X and Y shift here.
pointsScaledZoom(:,1) = ...
    ( ShiftX / PixelResolutionZ ) + ...
    ( ( pointsScaled(:,1) - ( SEMImageWidth / 2 ) ) * ZoomFactor ) + ( SEMImageWidth / 2 );
pointsScaledZoom(:,2) = ...
    ( ShiftY / PixelResolutionZ ) + ...
    ( ( pointsScaled(:,2) - ( SEMImageHeightCropped / 2 ) ) * ZoomFactor ) + ( SEMImageHeightCropped / 2 );

% Add the localized events on top of the image.
hold all

% Plot the events on the overview image.
scatter(pointsScaled(:,1),pointsScaled(:,2), [ ], 'r');

hold off

% Create the detail image.
heatmap = subplot(1,2,2);

% Show the zoomed inEM image here as well.
imshow( imadjust( imageSEMZCropped ) );

% Add the localized events on top of the image.
hold all

% Plot the event points on the zoomed in EM image.
scatter(pointsScaledZoom(:,1),pointsScaledZoom(:,2), [ ], 'g');

hold off

hold all

% For binning, we can use hist3
% First, convert binsize to a discrete number of bins. We do so by checking
% how many times the desired bin width fits into the physical size of the
% image. We do this in the X direction.
nbinsX = round( PixelResolutionZ * SEMImageWidth / BinWidth );
nbinsY = round( PixelResolutionZ * SEMImageHeightCropped / BinWidth );

% Based on the size of a bin, we calculate the location of bin edges.
edgesX = linspace(1, nbinsX, nbinsX) * (BinWidth / PixelResolutionZ);
edgesY = linspace(1, nbinsY, nbinsY) * (BinWidth / PixelResolutionZ);

% Store these edges in a format hist3 likes.
edgesxy = cell(1,2);
edgesxy{1} = edgesX;
edgesxy{2} = edgesY;

% Generate the actual 2D histogram. N is the 'bitmap' holding the counts
% for each bin. We will take this bitmap and blow it up to be the same size
% (in px) as the SEM image so that we can overlay easily.
[ N, C ] = hist3(pointsScaledZoom, 'Edges', edgesxy);

% The SEM generated tif files are 512 * 768 aspect ratio where each raster 
% point is oversampled. We thus need to convert our 2D histogram to be the
% same size.
% Additionally, hist3 somehow generates transposed output, we need to
% compensate for that.
upscaledHeatmap = imresize(...
    transpose(N), ...
    [SEMImageHeightCropped, SEMImageWidth], ...
    'box');

% Show the overlayed figure.
c = overlayImg(imageSEMZCropped, upscaledHeatmap); 

% We want the regions with no events to be 100% transparent in the overlay.
c.setTranspRange([0 0])

%Jordi
%Make it possible to obtain the coordinates of a certain point before and 
%after drift by clicking with the mouse on the image
[coordx,coordy] = ginput(2);
coordxdelta = coordx(2)-coordx(1);
coordydelta = coordy(2)-coordy(1);
disp(coordxdelta);
disp(coordydelta);

hold off 

end

