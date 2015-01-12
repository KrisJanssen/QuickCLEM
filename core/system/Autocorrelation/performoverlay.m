function performoverlay( transformedPoints, imageSEMO, infoSEMO, imageSEMZ, infoSEMZ, ShiftX, ShiftY, BinWidth)
%PERFORMOVERLAY Creates an events on SEM overlay image.
%   Parameters:
%   
%   transformedPoints:  The XY coordinates of events to overlay
%   imageSEM:           The SEM image
%   infoSEM:            Into on the SEM image
%   OFWHM:              ?
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
XWidth = infoSEMO.Width;
YWidth = infoSEMO.Height;

% The image tif contains metadata that is non-standard. From it, we get the
% width of a pixel in meters. We start looking for it at the 'PixelWidth='
% tag and we use a regex to get the number.
%
% Optionally a - or a +: (\-|\+)?
% Any number of digits, a dot and again any number of digits: \d+\.\d+
% e
% Optionally a - or a +: (\-|\+)?
% Any number of digits: \d+
regex = 'PixelWidth\=(\-|\+)?\d+\.\d+e(\-|\+)?\d+';

rawPixelWidtO = infoSEMO.UnknownTags.Value;
rawPixelWidtZ = infoSEMZ.UnknownTags.Value;

pixelWidthO = strrep( ...
    regexp(rawPixelWidtO,regex,'match'), ...
    'PixelWidth=', ...
    '');

pixelWidthZ = strrep( ...
    regexp(rawPixelWidtZ,regex,'match'), ...
    'PixelWidth=', ...
    '');

% Convert to a numeric value.
PixelResolutionO = str2double(pixelWidthO(1));
PixelResolutionZ = str2double(pixelWidthZ(1));

% SEM scans images as 768 * 512 raster. The tiff is thus oversampled.
OverSample = XWidth / 768;

% Physical width of the image in m.
HFWO = XWidth * PixelResolutionO;
HFWZ = XWidth * PixelResolutionZ;

% The CL spots are layed out around the ROI so we have an overview image 
% and the actual detail image. We need the scale factor between both
% images.
ZoomFactor = HFWO / HFWZ;

% Since the SEM scans a 768 * 512 raster and we know the oversampling
% factor from the X dimension, we can work out the width of the annotation
% band on the SEM output and get rid of it.
YWidthReal = OverSample * 512;

% Crop only the actual image.
imageSEMOCropped = imageSEMO( ...
    1:YWidthReal , ...
    1:XWidth );

imageSEMZCropped = imageSEMZ( ...
    1:YWidthReal , ...
    1:XWidth );

% Paint this image.
imshow( imadjust( imageSEMOCropped ) );

axis image;

% Transform raster (768 * 512) coordinates to image pixel coordinates.
% We also need to shift by 128 in X since the EM-CCD is 512 * 512 so there
% wille be 128 borders on each side.
% Of course, we also correct for the oversampling of the actual TIFF.
pointsScaled(:,1) = ((transformedPoints(:,1) + 128) * OverSample);
pointsScaled(:,2) = ((transformedPoints(:,2)) * OverSample);

% Initialize a matrix holding the event points in 'zoomed in' coordinates.
pointsScaledZoom = pointsScaled;

% The actual zoom calculation on event points. 
% We assume the overview and detail image are perfectly 
% centered.
% To zoom in, we translate the coordinates such that the origin is in the
% center of the frame. Then we only need to multiply by the ZoomFactor and
% translate back.
pointsScaledZoom(:,1) = ( ( pointsScaled(:,1) - ( XWidth / 2 ) ) * ZoomFactor ) + ( XWidth / 2 );
pointsScaledZoom(:,2) = ( ( pointsScaled(:,2) - ( YWidthReal / 2 ) ) * ZoomFactor ) + ( YWidthReal / 2 );

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
% image. We do this in the Y direction. The X direction is actually the
% same.
nbins = round( PixelResolutionZ * YWidthReal / BinWidth );

% Based on the size of a bin, we calculate the location of bin edges.
edges = linspace(1, nbins, nbins) * (BinWidth / PixelResolutionZ);

% Store these edges in a format hist3 likes.
edgesxy = cell(1,2);
edgesxy{1} = edges;
edgesxy{2} = edges;

% Generate the actual 2D histogram. N is the 'bitmap' holding the counts
% for each bin. We will take this bitmap and blow it up to be the same size
% (in px) as the SEM image so that we can overlay easily.
[ N, C ] = hist3(pointsScaledZoom, 'Edges', edgesxy);

% It is easiest to blow up the low res histogram, which is basically a 
% bitmap to be the same size as the EM image.
blowupfactor = YWidthReal / size(N, 1);

% The actual blowing up.
squareHeatmap = imresize(transpose(N),blowupfactor,'nearest');

% We now create an array the size of the EM image.
fullHeatmap = zeros(YWidthReal, XWidth);

% We place the blown up histogram in the middle of this map.
fullHeatmap(:,( 128 * OverSample ) + 1:( 128 * OverSample ) + YWidthReal) = squareHeatmap;

% Show the overlayed figure.
c = overlayImg(imageSEMZCropped, fullHeatmap); 

% We want the regions with no events to be 100% transparent in the overlay.
c.setTranspRange([0 0])

hold off 

end

