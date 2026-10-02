function init_toolbox()
%INIT_TOOLBOX Initialize the Input Redundancy Toolbox paths.
%
%   Syntax:
%       init_toolbox()
%
%   Description:
%       init_toolbox() adds the 'src' directory (and all its subfolders, 
%       including packages like '+geometric') as well as the 'examples' 
%       directory to the MATLAB search path.
%
%   Author: JK

    % Get the absolute directory where this initialization script is located
    root_dir = fileparts(mfilename('fullpath'));

    % Define paths to add
    src_dir = fullfile(root_dir, 'src');
    examples_dir = fullfile(root_dir, 'examples');

    % Check if directories exist before adding them
    if ~isfolder(src_dir)
        error('init_toolbox:MissingSrcDir', 'The "src" directory could not be found.');
    end

    % Add src and all its subfolders (subdirectories and packages like +geometric)
    addpath(genpath(src_dir));

    % Add examples folder if it exists
    if isfolder(examples_dir)
        addpath(examples_dir);
        disp('--> Added "examples" directory to path.');
    end
    savepath;

    disp('--------------------------------------------------');
    disp(' Input Redundancy Toolbox initialized successfully.');
    disp(' You can now use "ir", "ir_decomp", and geometric tools.');
    disp('--------------------------------------------------');

end