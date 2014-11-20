function strval = getuicontrolstring( parent, tag )
%GETUICONTROLSTRING Summary of this function goes here
%   Detailed explanation goes here

strval = get( findall ( findall( parent, 'Type', 'uicontrol' ), 'Tag', tag ), 'String' );

end

