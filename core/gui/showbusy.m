function [ modalout ] = showbusy( modalin )
%SHOWBUSY Summary of this function goes here
%   Detailed explanation goes here

narginchk(0,1);

if nargin == 0

    % Make it modal
    modalout = figure('WindowStyle', 'modal');
    
    % Hide the figure temporarily
    set(modalout,'Visible','off')
    
    % Rename window
    set(modalout, ...
        'name', 'Working ...', ...
        'numbertitle','off', ...
        'Position', [ 0 0 100 100 ], ...
        'CloseRequestFcn', @noclose)
    
    % Move gui
    movegui(modalout, 'center')
    
    % Set the figure icon
    updatelogo(modalout)
    
    vButtonBox = uix.VButtonBox('Parent', gcf);
    
    try
        % R2010a and newer
        iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
        iconsSizeEnums = javaMethod('values',iconsClassName);
        SIZE_32x32 = iconsSizeEnums(2);  % (1) = 16x16,  (2) = 32x32
        jObj = com.mathworks.widgets.BusyAffordance(SIZE_32x32, 'Working ...');  % icon, label
    catch
        % R2009b and earlier
        redColor   = java.awt.Color(1,0,0);
        blackColor = java.awt.Color(0,0,0);
        jObj = com.mathworks.widgets.BusyAffordance(redColor, blackColor);
    end
    jObj.setPaintsWhenStopped(true);  % default = false
    jObj.useWhiteDots(false);         % default = false (true is good for dark backgrounds)
    javacomponent(jObj.getComponent, [0,0,80,80], vButtonBox);
    jObj.start;
    
    set( vButtonBox, 'ButtonSize', [80 80], 'Spacing', 5 );
    
    % Show it!
    set(modalout,'Visible','on')
    
else
    
    delete(modalin)
    
end

end

function noclose( hObject, eventdata, handles )

% I'm lazy so I won't be doing anything... HAH! :-p

end

