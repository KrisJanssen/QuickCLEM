function handles = addtabComparecontrols( parent, handles )
%ADDTABCOMPARECONTROLS Summary of this function goes here
%   Detailed explanation goes here

hBox = uix.HBox('Parent', parent, ...
    'Padding', 5, ...
    'Spacing', 5);

handles.axesCLGrid = axes('Parent', hBox);
axis square
handles.axesSEMGrid = axes('Parent', hBox);
axis square

% Set widths of the main GUI columns
set(hBox, 'Widths', [ -1 -1 ]);


end

