function thisroot = bspri_loadRoot

% ispc: TRUE if it's the windows version of MATLAB, FALSE otherwise
if ~ispc 
    thishome = getenv('HOME');
    thisroot = sprintf('%s/MATLAB-Drive/PSY197ABC/CD_attempt',thishome);
else
    thisroot = 'Z:/projects/bspri/';
end

return
