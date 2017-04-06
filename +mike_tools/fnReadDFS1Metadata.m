function [ dfs1, InfoStruct ] = fnReadDFS1Metadata( dfs1_name, ItemNames )
%fnReadDFS1Metadata Reads various metadata from a MIKE DFS1 file.
%   Takes the filename of a MIKE dfs1 file, and a cell array of desired
%   data "items" for which item numbers are wanted. The latter can be omitted to return all item numbers instead (recommended).
%   Returns a .net dfs1 object and various bits of info about it in a
%   structure.

% This function will only work on a PC with MIKE installed. The DHI toolbox for MATLAB must also
% be in MATLAB's search path. Tested with the 2012 edition of MIKE and the
% associated version of the toolbox.

% Copyright Simon Waldman 2014-2017
% The latest version of this function can be found at https://github.com/TeraWatt-EcoWatt2050/MIKE_tools

if (nargin < 1)
    error('Not enough arguments.');
end
if (nargin > 2)
    error('Too many arguments.');
end
if ~isa(dfs1_name, 'char')
    error('First argument should be a char with a filename');
end
if ~exist(dfs1_name,'file')
    error('dfsu file not found');
end
if (nargin == 2 && ~isa(ItemNames, 'cell'))
    error('Second argument does not appear to be a cell array.');
end %FIXME allow a char if there's only one item name - if I ever update fnFindDFSUItems.m to support this.


% Set things up for reading dfs files. This requires MIKE Zero to be
% installed.
NET.addAssembly('DHI.Generic.MikeZero.DFS');
import DHI.Generic.MikeZero.DFS.*;

% open the file
dfs1 = DfsFileFactory.Dfs1FileOpen(dfs1_name);
if ~isa(dfs1, 'DHI.Generic.MikeZero.DFS.dfs123.Dfs1File')
    error('Failed to open dfs1 file, or it isn''t a dfs1 file.');
end

%timestep info
InfoStruct.sdStepTimes = mike_tools.read_dfs1_timesteps(dfs1);
InfoStruct.NumSteps = length(InfoStruct.sdStepTimes);

%spatial metadata
InfoStruct.X0 = double(dfs1.SpatialAxis.X0);
InfoStruct.NumPoints = double(dfs1.SpatialAxis.XCount);
InfoStruct.dx = double(dfs1.SpatialAxis.Dx);

%Magic number for missing values
InfoStruct.NAValue = double(dfs1.FileInfo.DeleteValueFloat);

%Find item numbers
if nargin == 2
    InfoStruct.ItemNumbers = mike_tools.fnFindDFSUItems(dfs1,ItemNames);
else
    InfoStruct.ItemNumbers = mike_tools.fnFindDFSUItems(dfs1);
end

end

