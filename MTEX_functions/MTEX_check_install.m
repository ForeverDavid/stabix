% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function installation_mtex = MTEX_check_install
%% Check if MTEX is installed
% See in http://mtex-toolbox.github.io/
% author: d.mercier@mpie.de

try
    check_mtex;
    installation_mtex = 1;
catch
    %warndlg('MTEX not installed or check_mtex not found/failing!');
    warning('MTEX not installed or check_mtex not found/failing!');
    disp('Proceeding without MTEX functionalities...');
    disp('Download MTEX here: http://mtex-toolbox.github.io/');
    installation_mtex = 0;
end

end