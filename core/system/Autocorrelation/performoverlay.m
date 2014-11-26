function performoverlay( transformedPoints, imageSEM, infoSEM, OHFW, BinWidth)
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
XWidth = infoSEM.Width;
YWidth = infoSEM.Height;

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

pixelWidth = strrep( ...
    regexp(infoSEM.UnknownTags.Value,regex,'match'), ...
    'PixelWidth=', ...
    '');

% Convert to a numeric value.
PixelResolution = str2double(pixelWidth(1));

% SEM scans images as 768 * 512 raster. The tiff is thus oversampled.
OverSample = XWidth / 768;

% Physical width of the image in m.
HFW = XWidth * PixelResolution;

MagScale =  1;%(OHFW)/HFW;

% Since the SEM scans a 768 * 512 raster and we know the oversampling
% factor from the X dimension, we can work out the width of the annotation
% band on the SEM output and get rid of it.
YWidthReal = OverSample * 512;

% imageSEMCropped = subimage( ...
%     [(XWidth-(XWidth/MagScale))/2 ((XWidth/MagScale)+XWidth)/2], ...
%     [((YWidth-(YWidth/MagScale))/2) - AnnotationHeight (((YWidth/MagScale)+YWidth)/2)-AnnotationHeight] , ...
%     imageSEM);

% imageSEMCropped = subimage( ...
%     [ 0 XWidth ], ...
%     [ 0 YWidthReal ] , ...
%     imageSEM);

% Crop only the actual image.
imageSEMCropped = imageSEM( ...
    1:YWidthReal , ...
    1:XWidth );

% Paint this image.
imshow( imadjust( imageSEMCropped ) );

axis image;

% Transform raster (768 * 512) coordinates to image pixel coordinates.
pointsScaled(:,1) = ((transformedPoints(:,1) + 128) * OverSample);
pointsScaled(:,2) = ((transformedPoints(:,2)) * OverSample);

% Add the localized events on top of the image.
hold all

scatter(pointsScaled(:,1),pointsScaled(:,2), [ ], 'r');

hold off

heatmap = subplot(1,2,2);

% For binning, we can use hist3
% First, convert binsize to a discrete number of bins.
nbinsX = round( PixelResolution * XWidth / BinWidth );
nbinsY = round( PixelResolution * YWidthReal / BinWidth );

binnedpointsScaled = hist3(pointsScaled, [ nbinsX nbinsY ]);

inter = imresize(binnedpointsScaled, [YWidthReal XWidth], 'bilinear');

c = overlayImg(imageSEMCropped, inter); 

%imagesc(binnedpointsScaled);

pause(1);
% nbins(1) = round((PixelResolution*XWidth*(512/768))/(BinWidth));
% nbins(2) = nbins(1);
% [N,C] = hist3(points, 'Nbins',nbins);
% imagesc([((C{1}(1))+128)*SEMOverSample (C{1}(nbins(1))+128)*SEMOverSample],[C{2}(nbins(2))*SEMOverSample C{2}(1)*SEMOverSample],imrotate(log10(N),90));
% colormap(h2,hot);
% colorbar;
% pos2 = get(h2,'Position');
% pos1 = get(h1,'Position');
% pos1(3) = pos2(3);
% set(h1,'Position',pos1);
% linkaxes([ overlayedSEM, heatmap ],'xy');
% axis image;
% vertical_cursors

end

