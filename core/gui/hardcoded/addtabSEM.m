function handles = addtabSEMcontrols( parent, handles )
%ADDTABSEMCONTROLS Summary of this function goes here
%   Detailed explanation goes here

vBoxLeft = uix.VBox('Parent', parent, ...
    'Padding', 5, ...
    'Spacing', 5);
vBoxRight = uix.VBox('Parent', parent, ...
    'Padding', 5, ...
    'Spacing', 5);

handles.axesSEMO = axes('Parent', vBoxLeft);
handles.axesSEMZ = axes('Parent', vBoxRight);

% Set widths of the main GUI columns
set(parent, 'Widths', [ -1 -1 ]);

handles.filenameSEMO = '';
handles.pathSEMO = '';

handles.filenameSEMZ = '';
handles.pathSEMZ = '';

handles.imageSEMO = [ 0 0; 0 0 ];
handles.infoSEMO = '';

handles.imageSEMZ = [ 0 0; 0 0 ];
handles.infoSEMZ = '';

end

