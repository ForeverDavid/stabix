% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
% $Id: planenormals2trace.m 1198 2014-08-05 09:13:00Z d.mercier $
function v = planenormals2trace(n1, n2, varargin)
%% Function to calculate the trace vector
% n1 = normal vector of the slip
% n2 = normal vector of the surface
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin == 0
    n1 = [1;0;0];
    n2 = [0;0;1];
end

tol = 1e-10;

n1U = n1/norm(n1);
n2U = n2/norm(n2);

if norm(cross(n1U,n2U)) < tol % planes parallel
    fprintf('Planes parallel:\n')
    display(n1U);
    display(n2U);
    v = NaN;
    return
else % planes not parallel
    v = cross(n1U,n2U);
    v = v/norm(v);
end

end