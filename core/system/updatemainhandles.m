function updatemainhandles(mainhandles)
% Updates handles structure of the main GUI window and sends it to appdata.
%
%    Input:
%     mainhandles   - handles structure of the main figure window
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

% Update handles structure
guidata(mainhandles.mainFig,mainhandles)

% Set handles structure in appdata
setappdata(0,'mainhandles',mainhandles)

% Set handle to main figure window in appdata
setappdata(0,'mainhandle',mainhandles.mainFig)
