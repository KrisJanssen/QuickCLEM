function handles = addtabSEMcontrols( parent, handles )
%ADDTABSEMCONTROLS Summary of this function goes here
%   Detailed explanation goes here

vBoxLeft = uix.VBox('Parent', parent);
vBoxRight = uix.VBox('Parent', parent, ...
    'Padding', 5, ...
    'Spacing', 5);

handles.axesSEM = axes('Parent', vBoxLeft);

% Set widths of the main GUI columns
set(parent, 'Widths', [ -2 -1 ]);

handles.imageSEM = [ 0 0; 0 0 ];
handles.infoSEM = '';

end

