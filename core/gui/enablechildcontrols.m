function enablechildcontrols( parent )
%DISABLECHILDCONTROLS Summary of this function goes here
%   Detailed explanation goes here

set( findall( parent, 'Type', 'uicontrol' ), 'Enable', 'on' )

end