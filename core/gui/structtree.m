function handle = structtree( parent )
%STRUCTTREE Summary of this function goes here
%   Detailed explanation goes here

[mtree, container] = uitree('v0', 'Root','C:\', 'Parent',parent); % Parent is ignored
set(container, 'Parent', parent);  % fix the uitree Parent

end

