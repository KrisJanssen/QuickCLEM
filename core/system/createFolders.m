function ok = createFolders(handles)
% Creates required folders on first startup of deployed application
%
%   Input
%    handles   - handles structure of the main window
%
%   Output:
%    ok        - folders created 0/1
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

% Initialize
ok = 1;

% Only if deployed
if ~isdeployed
    return
end

% Required folders on path
f = {fullfile(handles.workdir,'calls','stateSettings'),...
    fullfile(handles.workdir,'calls','lastUsedDir'),...
    fullfile(handles.workdir,'calls','misc')};

% Create the folder if it doesn't exist already.
for i = 1:length(f)
    d = f{i};
    if ~exist(d, 'dir')
        try
            % Create directory
            mkdir(d);
            
            % Move some installation files
            if i==1
                try movefile(fullfile(handles.workdir,'data.template'), d,'f')
                end
                
            elseif i==3
                try movefile(fullfile(handles.workdir,'logo.png'), d,'f')
                end
            end
            
        catch err
            
            % Access denied error
            if strcmpi(err.identifier,'MATLAB:MKDIR:OSError') ...
                    && (isempty(getappdata(0,'administratorMsgbox')) || ~ishandle(getappdata(0,'administratorMsgbox')))
                
                try winopen(handles.workdir); end
                
                % Message box
                message = sprintf(['Unable to create necessary system folders at:\n  %s\n\n'...
                    'You must have administrator rights at the directory of installation.\n\n'...
                    'All you need to do is to copy the installation folder to a location with administrator rights, or login as administrator.\n\n'...
                    'Remember to update your program shortcuts accordingly.\n'],handles.workdir);
                h = mymsgbox(message,'Permission denied');
                
                % Only show box once
                setappdata(0,'administratorMsgbox', h)
                
            end
            ok = 0;
            
            % Turn attention back to figure
            figure(handles.figure1)
        end
    end
end
