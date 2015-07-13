function performimageoverlay( imageSEMO, infoSEMO, imageSEMZ, infoSEMZ, ShiftX, ShiftY )
%PERFORMOVERLAY Creates an events on SEM overlay image.
%   Parameters:
%   
%   imageSEMO:          The SEM overview image
%   infoSEMO:           Info on the SEM overview image
%   imageSEMZ:          The SEM zoom image
%   infoSEMO:           Into on the SEM zoom image
%   ShiftX:             A corrective shift for the overlay in X (in nm)
%   ShiftY              A corrective shift for the overlay in Y (in nm)

[ ~, handles ] = getmainwindowhandles();

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

% Create the detail image.
heatmap = subplot(1,2,2);

% Show the zoomed inEM image here as well.
imshow( imadjust( imageSEMZCropped ) );

hold all

% The SEM generated tif files are 512 * 768 aspect ratio where each raster 
% point is oversampled. We thus need to convert our 2D image to be the
% same size.
upscaledHeatmap = imresize(...
    handles.imt, ...
    [SEMImageHeightCropped, SEMImageWidth], ...
    'nearest');

% Show the overlayed figure.
c = overlayImg(imageSEMOCropped, upscaledHeatmap); 

% We want the regions with no events to be 100% transparent in the overlay.
c.setTranspRange([0 1])

hold off 

end

