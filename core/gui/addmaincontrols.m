function addmaincontrols( hfig )
%ADDCONTROLS Summary of this function goes here
%   Detailed explanation goes here

% Get the main window and its handles structure (holding references to all
% controls on it.

handles = guidata(hfig);

% Add principal layout boxes
hBox = uix.HBox('Parent', hfig, 'BackgroundColor', 'b');
vBoxLeft = uix.VBox('Parent', hBox, ...
    'BackgroundColor', 'g');
vBoxRight = uix.VBox('Parent', hBox, ...
    'BackgroundColor', 'y', ...
    'Padding', 5);

% Set widths of the main GUI columns
set(hBox, 'Widths', [ -2 -1 ]);

% Add localizer image display and slider control.
handles.axesFrame = axes('Parent', vBoxLeft);
axis square

frameControlVBox = uix.VBox( 'Parent', vBoxLeft, 'Padding', 10, 'Spacing', 5 );
handles.axesSlider = uicontrol('Parent', frameControlVBox, ...
    'BackgroundColor', [.9 .9 .9], ...
    'Style', 'Slider', ...
    'Callback', @onSlideMove);

set(vBoxLeft, 'Heights', [ -2 -0.2 ]);

% Add additional panels inside right part of GUI.
localizerPanel = uix.Panel('Parent', vBoxRight, ...
    'Padding', 5);
localizerGrid = uix.Grid('Parent', localizerPanel, ...
    'Spacing', 5);

uicontrol('Parent', localizerGrid, ...
    'Style', 'text', ...
    'String', 'Psf width');

uicontrol('Parent', localizerGrid, ...
    'Style', 'text', ...
    'String', 'Pfa');

uicontrol('Parent', localizerGrid, ...
    'Style', 'pushbutton', ...
    'String', 'Localize!', ...
    'Callback', @onLocalize);

uicontrol('Parent', localizerGrid, ...
    'Style', 'edit', ...
    'String', '3', ...
    'Tag', 'Psfwidth');

uicontrol('Parent', localizerGrid, ...
    'Style', 'edit', ...
    'String', '25', ...
    'Tag', 'Pfa');

uix.Empty( 'Parent', localizerGrid )

set(localizerGrid, 'Widths', [ -1 -0.5 ], 'Heights', [ 25 25 25 ]);

disablechildcontrols(localizerPanel);

handles.localizerCtrls = localizerPanel;

guidata(hfig, handles);

end

