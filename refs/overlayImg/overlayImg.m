classdef overlayImg < handle
    % overlays two datasets and displays them as overlayed images
    % call examples: 
    % c = overlayImg(backimg,overimg)
    % c = overlayImg(backimg,overimg,[fromRange toRange],...
    %                        [fromTransparent toTransparent])
    %
    % after the class is constructed you can edit the properties either
    % directly and call update() manually or you can use the setPROPERTY
    % functions and the figure will update automatically. 
    %
    % It is possible to set the value ranges, the color maps, a
    % transparency range and the alpha value.
    %
    % Where backimg is the image in the back, overimg the image overlay.
    % If the third parameter is given the values of overimg are limited to
    % the range given. If the fourth parameter is given the values in the
    % given range are transparent (for example for just showing negative and
    % positive values, but not around zero).
    %
    % If you want to display indexed images set the corresponding range 
    % (backRange or overRange) to [ 1 length(cmap) ], cmap being the
    % colormap for the image.
    % 
    % The datatip will show coordinates, the value of the background and
    % overlay image.
    % 
    % Images of different resolutions are also supported. If you're interested 
    % in that try to get you started: 
    %   help overlayImg.setAxes    
    %
    % General usage example:
    %   rgb = imread('ngc6543a.jpg');  % reading an image
    %   grayimg = mean(double(rgb),3); % make a grayscale image
    %   s = size(grayimg);
    %   [x,y]=meshgrid(1:s(2),1:s(1));  % make grid    
    %   oimg = sin(y/100).^2+cos(x/250).^2;   % some meaningless overlay
    %   c = overlayImg(grayimg,oimg);  % overlay images
    %
    %   % from now on we can interact with the object
    %   % let's check the values in the background and overlay image
    %   c.showColorBars()
    %   % now setting up a transparent range
    %   c.setTranspRange([0 0.5])
    %   % reduce range in background image
    %   c.setBackRange([0 150])
    %   % adjust alpha value
    %   c.setAlpha(0.5)
    %   % don't show overlay values above 1.5
    %   c.setOverRange([0 1.5])
    
    % Jochen Deibele 2009, 2010
    
    properties
        mFigHdl = [];           % figure handle
        mAxHdl = [];            % axis handle
        mCbHdlb = [];           % background colorbar handle
        mCbHdlo = [];           % overlay colorbar handle
        mDcm_obj = [];          % datacursor object
        
        % background image
        backImg = [];           % background image
        backMap = gray(256);    % color map background image
        backRange = [];         % background image range = min:max
        backXax = [];           % X axis of the image
        backYax = [];           % Y axis of the image
        
        % overlay
        overImg = [];           % overlay image
        overMap = jet(256);     % Color map overlay
        overRange = [];         % imaging range empty = min:max
        overRangeSym = false;   % should the automatic range be symmetric around 0?
        overXax = [];           % X axis of the image
        overYax = [];           % Y axis of the image
        % transparancy 
        transpRange = [];       % [from to] from < overImg < to will not be shown
        alpha = 0.7;            % alpha value
        
        resetAxisDims = false;  % should the axis be zoomed out if repainted?
    end
    methods (Static)
        function rRange = detRange(aIm, aRange, aSym)
            % aRange = detRange(aIm, aRange)
            % convenience function to determine value range. If aRange is
            % empty the range will be taken from min(aIm(:)) and
            % max(aIm(:)) ignoring values equal to +-Inf.
            % the range will be symmetric if the corresponding parameter is
            % set.
            if isempty(aRange)
                aIm_mod = aIm;
                aIm_mod(isinf(aIm)) = [];
                rRange = [min(aIm_mod(:)) max(aIm_mod(:))];
                if aSym
                    rRange = [-1 1]*max(abs(rRange));
                end;
            else
                rRange = aRange;
            end;
        end;
        
        function si = idxImg(aIm, aRange, aMap, aSym)
            % si = idxImg(aIm, aRange, aMap)
            % converts a (not indexed) image to an indexed image in the
            % given colormap, saturating if values exceed aRange
            aIm = double(aIm);
            aRange = overlayImg.detRange(aIm, aRange, aSym);  % determine range
            si = (aIm - aRange(1)) / (aRange(2) - aRange(1)) * (size(aMap,1)-1)+1;
            si = floor(si);
            si(aIm < aRange(1)) = 1;
            si(aIm > aRange(2)) = size(aMap,1);
        end;
        
        function [aAx, dx] = checkAxis(aImg, aDim, aAx)
            if isempty(aAx) || size(aImg,aDim) ~= numel(aAx)
                aAx = 1:size(aImg,aDim);                
            end;
            dx = diff(aAx([1,2]));
        end
        
        function [idx] = giveDataTipPos(aAx, aPos)
            dx = diff(aAx([2,1]));
            aPos = aPos + 0.5*dx;
            idx = find(aAx >= aPos,1,'first');
            if isempty(idx) && aPos < aAx(1) && aPos > aAx(1)-0.5*dx
                idx = 1;
            elseif isempty(idx) && aPos > aAx(end) && aPos < aAx(end)+0.5*dx
                idx = numel(aAx);
            end;
        end
    end;
    methods
        function obj = overlayImg(aBackImg, aOverImg, aOverRange, aTranspRange) 
            % overlayImg(aBackImg, aOverImg, aOverRange, aTranspRange) 
            % constructor
            % aBackImg : background image
            % aOverImg : overlay image
            % aOverRange (optional): Limit the range of the overlay image
            % aTranspRange: Range of values for the overlay image which is
            %               not shown
            
            % initialize values 
            obj.backImg = aBackImg;
            obj.overImg = aOverImg;

            if nargin > 2
                obj.overRange = aOverRange;
            end;
            if nargin > 3
                obj.transpRange = aTranspRange;
            end;
            obj.mFigHdl = figure();
            obj.mAxHdl = axes();
            obj.resetAxisDims = true;
            
            % change data tip callback to own function
            obj.mDcm_obj = datacursormode(obj.mFigHdl);
            set(obj.mDcm_obj,'UpdateFcn',@obj.datatipCB);
            
            obj.update();
        end
        function [overVal, backVal] = giveValues(obj,position)
            [backXax,dbx] = obj.checkAxis(obj.backImg, 2, obj.backXax);
            [backYax,dby] = obj.checkAxis(obj.backImg, 1, obj.backYax);
            [overXax,dox] = obj.checkAxis(obj.overImg, 2, obj.overXax);
            [overYax,doy] = obj.checkAxis(obj.overImg, 1, obj.overYax);
            bIdxX = obj.giveDataTipPos(backXax, position(1));
            oIdxX = obj.giveDataTipPos(overXax, position(1));
            bIdxY = obj.giveDataTipPos(backYax, position(2));
            oIdxY = obj.giveDataTipPos(overYax, position(2));
            if ~isempty(bIdxX) && ~isempty(bIdxY)
                backVal = obj.backImg(bIdxY,bIdxX);
            else
                backVal = [];
            end;
            if ~isempty(oIdxX) && ~isempty(oIdxY)
                overVal = obj.overImg(oIdxY,oIdxX);
            else
                overVal = [];
            end;
        end
        function tiptext = datatipCB(obj, cbobj, event_obj)
            % datatip callback function
            % the datatip shows coordinates and the value of the background
            % as well as of the overlay image
            % check axis for images 
            [backXax,dbx] = obj.checkAxis(obj.backImg, 2, obj.backXax);
            [backYax,dby] = obj.checkAxis(obj.backImg, 1, obj.backYax);
            [overXax,dox] = obj.checkAxis(obj.overImg, 2, obj.overXax);
            [overYax,doy] = obj.checkAxis(obj.overImg, 1, obj.overYax);
            
            dxmin = min(dbx,dox);
            bIdxX = obj.giveDataTipPos(backXax, event_obj.Position(1));
            oIdxX = obj.giveDataTipPos(overXax, event_obj.Position(1));
            if dbx < dox && ~isempty(bIdxX)
                posx = backXax(bIdxX);
            elseif dbx >= dox && ~isempty(oIdxX)
                posx = overXax(oIdxX);
            elseif ~isempty(bIdxX)
                posx = backXax(bIdxX);
            elseif ~isempty(oIdxX)
                posx = overXax(oIdxX);
            end;
            
            dymin = min(dby,doy);
            bIdxY = obj.giveDataTipPos(backYax, event_obj.Position(2));
            oIdxY = obj.giveDataTipPos(overYax, event_obj.Position(2));
            if dby < doy && ~isempty(bIdxY)
                posy = backYax(bIdxY);
            elseif dby >= doy && ~isempty(oIdxY)
                posy = overYax(oIdxY);
            elseif ~isempty(bIdxY)
                posy = backYax(bIdxY);
            elseif ~isempty(oIdxY)
                posy = overYax(oIdxY);
            end;
            
            if ~isempty(bIdxX) && ~isempty(bIdxY)
                bVal = sprintf('%2.2f',obj.backImg(bIdxY,bIdxX));
            else
                bVal = '-';
            end;
            if ~isempty(oIdxX) && ~isempty(oIdxY)
                oVal = sprintf('%2.2f',obj.overImg(oIdxY,oIdxX));
            else
                oVal = '-';
            end;
            tiptext = sprintf('x: %i y: %i\nback: %s\nover: %s',posx,posy,bVal,oVal);
        end;
        
        function update(obj)
            % renders the image
            
            % create common colormap
            map = [obj.backMap;obj.overMap];
            
            % convert to indexed image
            gi = obj.idxImg(obj.backImg, obj.backRange, obj.backMap, false);
            oi = obj.idxImg(obj.overImg, obj.overRange, obj.overMap, obj.overRangeSym);
            
            % check axis for images 
            [backXax,dbx] = obj.checkAxis(gi, 2, obj.backXax);
            [backYax,dby] = obj.checkAxis(gi, 1, obj.backYax);
            [overXax,dox] = obj.checkAxis(oi, 2, obj.overXax);
            [overYax,doy] = obj.checkAxis(oi, 1, obj.overYax);
            
            axDims = [min(backXax(1)-dbx/2,overXax(1)-dox/2), max(backXax(end)+dbx/2, overXax(end)+dox/2),...
                     min(backYax(1)-dby/2,overYax(1)-doy/2), max(backYax(end)+dby/2, overYax(end)+doy/2)];
            
            if isempty(obj.mAxHdl) || ~ishandle(obj.mAxHdl)
                obj.mAxHdl = axes('Parent',obj.mFigHdl);                
                axis(axDims);
            end; 
            ax = obj.mAxHdl;
            if ~obj.resetAxisDims
                axDims = [get(ax,'XLim') get(ax,'YLim')];
            else
                obj.resetAxisDims = false;
            end;
            % make datatip work even if the datasets have different sizes orresolutions            
            if dbx < dox || dby < doy
                overHitTest = 'off';
                backHitTest = 'on';
            else
                overHitTest = 'on';
                backHitTest = 'off';
            end;

            if backXax(end)>overXax(end) || backYax(end) > overYax(end)
                overHitTest = 'off';
                backHitTest = 'on';
            else
                overHitTest = 'on';
                backHitTest = 'off';
            end;
                        
			% plot images
            image(backXax, backYax, gi,'Parent',ax,'HitTest',backHitTest)
            hold(ax,'all');            
            h = image(overXax, overYax, oi + size(obj.backMap,1),'Parent',ax,'HitTest',overHitTest);
            hold(ax,'off');
            axis(ax,axDims);
            colormap(ax,map);
            
            % is a transparent range given?
            if isempty(obj.transpRange)
                % no, we use the same alpha value for all of the overlay
                % image
                set(h,'AlphaData',obj.alpha);
            else
                % yes, we have to make the range transparent
                alMask = zeros(size(obj.overImg));
                alMask(obj.overImg<double(obj.transpRange(1))) = 1;
                alMask(obj.overImg>double(obj.transpRange(2))) = 1;
                set(h,'AlphaData',alMask*obj.alpha);
            end;
            
            % if colorbars are shown update them
            if ~isempty(obj.mCbHdlb)
                obj.showColorBars();
            end;
        end
       
        function showColorBars(obj)
            % background colorbar
            aHdl = obj.mCbHdlb;
            % check if colorbar is already on screen, if not create new
            if isempty(aHdl) || ~ishandle(aHdl)
                aHdl = figure;
                pos = get(aHdl,'Position');
                set(aHdl,'Position',[pos(1)-pos(3)*2/5-15 pos(2) pos(3)/5 pos(4)]);
            else
                figure(aHdl);
            end;
            obj.mCbHdlb = aHdl;
            % determine value range 
            aRange = overlayImg.detRange(obj.backImg, obj.backRange,false);
            aMap = obj.backMap;
            aRangeVec = (aRange(2)-aRange(1))/(size(aMap,1)-1)*(0:(size(aMap,1)-1))+aRange(1);
            imagesc(1,aRangeVec,aRangeVec.');
            set(gca,'YDir','normal');
            colormap(aMap);
            title('legend back');
            
            % overlay colorbar 
            aHdl = obj.mCbHdlo;
            % check if colorbar is already on screen, if not create new
            if isempty(aHdl) || ~ishandle(aHdl)
                aHdl = figure;
                pos = get(aHdl,'Position');
                set(aHdl,'Position',[pos(1)-pos(3)/5-7 pos(2) pos(3)/5 pos(4)]);
            else
                figure(aHdl);
            end;
            obj.mCbHdlo = aHdl;
            
            % determine value range 
            aRange = overlayImg.detRange(obj.overImg, obj.overRange, obj.overRangeSym);            
            aMap = obj.overMap;
            aRangeVec = (aRange(2)-aRange(1))/(size(aMap,1)-1)*(0:(size(aMap,1)-1))+aRange(1);
            imagesc(1,aRangeVec,aRangeVec.');
            set(gca,'YDir','normal');
            colormap(aMap);
            title('legend over');
            % focus back to figure
            figure(obj.mFigHdl);
        end;
        function setAxes(obj,backXax, backYax, overXax, overYax)
            % setAxes(obj,backXax, backYax, overXax, overYax)
            % sets an axis for the images. Can be used if the images are
            % sampled differently:
            %   back = rand(20,20);   % some background image
            %   over = rand(10,10);   % some overlay, sampled differently
            %   io = overlayImg(back,over); % create overlay
            %   aAx = 1:20;           % axis for the background image
            %   pause(1);             % wait a second that one can see the
            %                         % difference
            %   aSampledAx = aAx(1:2:end)+0.5*(aAx(2)-aAx(1)); 
            %                         % NB Matlab plots images that the
            %                         % center of the first pixel is on 1,
            %                         % the second on 2 and so on. Thus if
            %                         % you want to use differently sampled
            %                         % images you have to compensate for
            %                         % that => +0.5*dx
            %   io.setAxes(aAx,aAx,aSampledAx,aSampledAx); % sets the axes            
            
            obj.backXax = backXax;
            obj.backYax = backYax;
            obj.overXax = overXax;
            obj.overYax = overYax;
            obj.resetAxisDims = true;
            obj.update();
        end;
        function setBackImg(obj, aValue)
            if ~isequal(size(aValue), size(obj.backImg))
                obj.resetAxisDims = true;
            end;
            obj.backImg = aValue;
            obj.update();
        end
        function setOverImg(obj, aValue)
            if ~isequal(size(aValue), size(obj.overImg))
                obj.resetAxisDims = true;
            end;
            obj.overImg = aValue;
            obj.update();
        end
        function setAlpha(obj, aValue)
            obj.alpha = aValue;
            obj.update();
        end;
        function setOverRange(obj, aValue)
            obj.overRange = aValue;
            obj.update();
        end;
        function setBackRange(obj, aValue)
            obj.backRange = aValue;
            obj.update();
        end;
        function setOverMap(obj, aValue)
            obj.overMap = aValue;
            obj.update();
        end;
        function setBackMap(obj, aValue)
            obj.backMap = aValue;
            obj.update();
        end;
        function setTranspRange(obj, aValue)
            obj.transpRange = aValue;
            obj.update();
        end;
        function setFigName(obj, aName)
            set(obj.mFigHdl,'Name',aName);
        end;
        function setOverRangeSymmetric(obj, enable)
            % sets the range of values to be symmetric
            obj.overRangeSym = enable;
            obj.update();
        end;
        function col = giveOverlayColor(obj,posIdx)
            % convert to indexed image
            gi = obj.idxImg(obj.backImg, obj.backRange, obj.backMap, false);
            oi = obj.idxImg(obj.overImg, obj.overRange, obj.overMap, obj.overRangeSym);
            col = obj.overMap(oi(posIdx(2),posIdx(1)));
        end;
    end
end