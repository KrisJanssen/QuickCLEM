function onCorrectDrift( source , callbackdata )
%ONLOCALIZEEVENTS Summary of this function goes here
%   Detailed explanation goes here

% Get shared data
[ ~, handles ] = getmainwindowhandles();

if isfield(handles,'XYEvents')
    
    %msgbox('Select the area where there are NO markers.');
    
    % We will draw a ROI to define where our fiducial markers are. In order
    % to do so, we first need to get the image displayed in the axes.
    I = getimage(handles.axesEvents);
    
    [~, ~, ~, xpoly, ypoly] = roipoly(I);

    % Do a hit-test on all localizations and check if they are inside or
    % outside our ROI. If we draw an A=ROI around the area of interest, we
    % can assume that any fiducial markers will be outside of it. We retain
    % those for drift correction.
    in = inpolygon(handles.XYEvents(:,2),handles.XYEvents(:,3),xpoly,ypoly);
    
    % We can now filter the fiducial markers from the localization set.
    XYFiducials = handles.XYEvents(in,:);
    
    % We now try to compose tracks from the localized points. These are
    % returned in following format:
    %
    % X coordinate - Y coordinate - frame - assigned track
    tracks = Autotrack4(XYFiducials, 2, 0);
    
    % After track composition we can try and fit average drift over the
    % frame.
    
    % Provide progress updates.
    h=waitbar(0, 'Constructing tracks...');
    
    dxx=[];dyy=[];
    
    % We are onlu interested in onger tracks.
    tracklength = 10;
    
    % We need to run through all tracks so we check how many there are in
    % the list of tracks. Track no.'s are in the fourth column.
    for i=1:max(tracks(:,4)) %- tracklength
        
        % All element of the current track.
        currentIdx = find(tracks(:,4) == i);
        
        % Only work on tacks of sufficient length.
        if size(currentIdx, 1) >= tracklength
            
            % Make a working copy of the current track.
            cod = tracks(currentIdx, :);
            
            % Work out the frame-to-frame shifts for each individual marker
            % and store them together with the corresponding frame no.
            dxx = cat(1, dxx, [diff(cod(:,1)) cod(2:end, 3)]);
            dyy = cat(1, dyy, [diff(cod(:,2)) cod(2:end, 3)]);
            
        end
        
        % Progress update.
        waitbar(i/max(tracks(:,4)), h);
        
    end
    
    delete(h);
    
    % In the array holding the marker shifts, the same frame number will
    % occur multiple times since in each frame there are likely multiple
    % markers that shift position. Morover, these frame numbers will not
    % necessarily be in order.
    %
    % We therefore create an ordered sequential index array by finding the
    % minimum and maximum frame number.
    fr = min(dxx(:,2)) : max(dxx(:,2));
    
    % We use the ordered indexes to run through the shifts, averaging all
    % shifts within each individual frame.
    xx_tmp = arrayfun(@(x) mean(dxx(dxx(:,2) == x, 1)), fr);
    yy_tmp = arrayfun(@(x) mean(dyy(dyy(:,2) == x, 1)), fr);
    
    % If the microscope mechanics are not stable, focus might drift
    % significantly. In this case, some frames might not feature visible or
    % localizable markers. xx_tmp might thus contain NaN for the values of
    % mean. These need to be set to 0 (assume no drift here as a crude fix).
    xx_tmp(isnan(xx_tmp)) = 0;
    yy_tmp(isnan(yy_tmp)) = 0;
    
    % We calculate the cumulative displacement of the sample from the fram
    % to frame displacements.
    xx_ave = cumsum(xx_tmp);
    yy_ave = cumsum(yy_tmp);
    
    % Now that we have the averaged shifts per frame in X and Y we can fit
    % the shifts with a smoothing spline. The localization accuracy is
    % higher than the individual shifts might be. Therefore we can smooth
    % out things somewhat.
    fxx = fit([2:max(dxx(:,2))]', xx_ave', 'smoothingspline', 'SmoothingParam', 1E-6);
    fyy = fit([2:max(dyy(:,2))]', yy_ave', 'smoothingspline', 'SmoothingParam', 1E-6);
    
    % Plot the average drift data together with the spline fit.
    figure, plot(xx_ave, '.k'); title('Drift in x-direction'); hold on; plot(fxx); hold off
    figure, plot(yy_ave, '.k'); title('Drift in y-direction'); hold on; plot(fyy); hold off
    clr = jet(size(xx_ave,2));
    figure, scatter(xx_ave, yy_ave, [], clr, 'filled'); title('Drift in xy');
    
    % Finally, correct all positions.
    handles.XYEvents(:,2) = handles.XYEvents(:,2) - fxx(handles.XYEvents(:,1));
    handles.XYEvents(:,3) = handles.XYEvents(:,3) - fxx(handles.XYEvents(:,1));

else
    msgbox('You need to localize something first!!');

end

% Update the shared data. Matlab passes by value, not by reference.
setmainwindowhandles( handles );

updateGUI()

end
