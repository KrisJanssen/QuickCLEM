function performoverlay( points, imageSEM, infoSEM, OFWHM, BinWidth)
%PERFORMOVERLAY Summary of this function goes here
%   Detailed explanation goes here

% Generate a figure.
% Get the client screen size
scrsz = get(groot,'ScreenSize');

% Create a figure that is fully maximized
figure('Position',[1 1 scrsz(3) scrsz(4)])

% Within this figure, generate the first of two plots.
h1=subplot(1,2,1);

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
expression = 'PixelWidth\=(\-|\+)?\d+\.\d+e(\-|\+)?\d+';
matchStr = strrep( ...
    regexp(infoSEM.UnknownTags.Value,expression,'match'), ...
    'PixelWidth=', ...
    '');

% Convert to a numeric value.
PixelResolution = str2double(matchStr(1));

% SEM scans images as 768 virtual pixels?
SEMOverSample = XWidth / 768;


FWHM = XWidth * PixelResolution;

MagScale =  1;%(OFWHM)/FWHM;

Yshift = YWidth-SEMOverSample*512;
subimage([(XWidth-(XWidth/MagScale))/2 ((XWidth/MagScale)+XWidth)/2],[((YWidth-(YWidth/MagScale))/2)-Yshift (((YWidth/MagScale)+YWidth)/2)-Yshift] ,imageSEM);
axis image;

pointsScaled(:,1) = ((points(:,1)+128)*SEMOverSample);
pointsScaled(:,2) = ((points(:,2))*SEMOverSample);

% Add the localized events.
hold all
c = linspace(0,1,length(pointsScaled(:,1)));
scatter(pointsScaled(:,1),pointsScaled(:,2), [ ], 'r');

hold off

% h2=subplot(1,2,2);
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
% linkaxes([h1,h2],'xy');
% axis image;
% vertical_cursors

end

