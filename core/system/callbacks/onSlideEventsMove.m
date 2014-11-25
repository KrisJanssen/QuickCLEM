function onSlideEventsMove( source , callbackdata )
%ONSLIDEEVENTSMOVE Summary of this function goes here
%   Detailed explanation goes here

value = round(get( source, 'Value' ));

% We use a convenience method so we do not need hard-coded references to
% handles
setcurrentframeEvents( value );

end

