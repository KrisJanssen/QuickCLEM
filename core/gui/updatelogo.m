function updatelogo(h)
% Updates the window logo of figure handle h. The logo image is located at
% calls/misc/logo.png
%

% --- Copyrights (C) ---
%
% Copyright (C)  Søren Preus, Ph.D.
% http://www.fluortools.com
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     The GNU General Public License is found at
%     <http://www.gnu.org/licenses/gpl.html>.

try
    if nargin<1 || ~ishandle(h)
        h = gcf; % Default is current figure
    end
    
    % Directory of image
    %imagepath = fullfile(getappdata(0,'workdirDecayFit'), 'assets', 'logo.PNG');
    imagepath = getasset( 'logo.PNG' );
    
    % Set logo
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe = get(h,'javaframe');
    jIcon = javax.swing.ImageIcon(imagepath);
    jframe.setFigureIcon(jIcon);
end
