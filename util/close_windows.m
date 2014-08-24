% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
% $Id: close_windows.m 1142 2014-07-09 17:06:07Z d.mercier $
function close_windows(window_name, varargin)
%% Function used to close Matlab windows
% window_name : Name or handle of the window

if nargin == 0
    delete(findall(0,'Type','figure'));
    com.mathworks.mlservices.MatlabDesktopServices.getDesktop.closeGroup('Web Browser')
else
    close(window_name);
end