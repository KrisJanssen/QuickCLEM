function setuicontrolstring( parent, tag, strval )
%SETUICONTROLSTRING Summary of this function goes here
%   Detailed explanation goes here

set( findall ( findall( parent, 'Type', 'uicontrol' ), 'Tag', tag ), 'String', strval )

end

