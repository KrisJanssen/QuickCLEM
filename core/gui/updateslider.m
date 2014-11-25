function updateslider( slider, maxVal )
%UPDATESLIDER Sets the correct range on the requested slider.

% We need to check that the value is not already set. It would be pointless
% to set it again.
if get(slider, 'Max') < maxVal    
    
    stepVal = 1 / (maxVal - 1);
    
    set( slider, ...
        'Min', 1, ...
        'Max', maxVal, ...
        'Sliderstep', [stepVal , stepVal], ...
        'Value', 1);
    
end

end

