function handles = addtabImage( parent, handles )
%ADDTABSEMCONTROLS Summary of this function goes here
%   Detailed explanation goes here

vBoxLeft = uix.VBox('Parent', parent, ...
    'Padding', 5, ...
    'Spacing', 5);
vBoxRight = uix.VBox('Parent', parent, ...
    'Padding', 5, ...
    'Spacing', 5);

handles.axesImage = axes('Parent', vBoxLeft);

% Set widths of the main GUI columns
set(parent, 'Widths', [ -1 -1 ]);

handles.im = [ 0 0; 0 0 ];
handles.imt = [ 0 0; 0 0 ];
handles.imagemode = 0;

end