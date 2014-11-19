function initGUI(hfig, name, pos)
% First function to run in GUI opening functions. Runs some initial
% configurations to GUI windows.
%
%    Input:
%     hfig   - figure handle
%     name   - window title
%     pos    - 'center', 'west', ...
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

if nargin<3
    pos = 'center';
end

% Don't show GUI yet - it'll look weird as it flops around on the screen
set(hfig,'Visible','off') % Is turned on by OutputFcn

% Rename window
set(hfig, 'name',name, 'numbertitle','off')

% Move gui
movegui(hfig, pos)

% Set the figure icon
updatelogo(hfig)

% Don't allow docking
set(hfig, 'DockControls','off')