% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
% $Id: finishsav.m 885 2014-05-07 17:30:56Z d.mercier $
%% Script to open an exit dialog box and to save all data as a .mat file before to close all figures
pushbutton = questdlg('Ready to quit?', ...
    'Exit Dialog','Yes','No','No');

switch pushbutton
    case 'Yes',
        disp('Exiting MATLAB');
        %Save variables to test.mat
        save
        close(gcf)
        clear all
        cab();
    case 'No',
        quit cancel;
end

