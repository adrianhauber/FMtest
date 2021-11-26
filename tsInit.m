ts_path = fileparts(which('tsInit.m'));

addpath([ts_path filesep 'GeneralOperations'])
addpath([ts_path filesep 'Hilbert'])
addpath([ts_path filesep 'Spectrum'])

fprintf('Added tsFramework subfolders to path.\n')