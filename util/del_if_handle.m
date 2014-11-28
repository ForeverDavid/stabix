% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function err = del_if_handle(h)
%% Function to evaluate handle
% h: string of the handle variable name

try
    if eval('ishandle(h)')
        eval('delete(h)');
    end
catch err
    warning_commwin(err.message);
end