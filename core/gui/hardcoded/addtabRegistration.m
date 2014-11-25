function handles = addtabRegistrationcontrols( parent, handles )
%ADDTABREGISTRATIONCONTROLS Summary of this function goes here
%   Detailed explanation goes here

hBox = uix.HBox('Parent', parent, ...
    'Padding', 5, ...
    'Spacing', 5);

uicontrol('Parent', hBox, ...
    'Style', 'pushbutton', ...
    'String', 'Do Registration!', ...
    'Callback', @onRegister);

% Set widths of the main GUI columns
%set(hBox, 'Widths', [ -1 -1 ]);

end

