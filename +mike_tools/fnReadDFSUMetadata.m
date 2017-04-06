function [ dfsu, InfoStruct ] = fnReadDFSUMetadata( dfsu_name, ItemNames )
%fnReadDFSUMetadata Reads various metadata from a MIKE DFSU
%   Takes the filename of a MIKE dfsu file, and a cell array of desired
%   data "items" for which item numbers are wanted. The latter can be omitted to return all item numbers instead (recommended).
%   Returns a .net dfsu object and various bits of info about it in a
%   structure.

% This function will only work on a PC with MIKE installed. The DHI toolbox for MATLAB must also
% be in MATLAB's search path. Tested with the 2012 edition of MIKE and the
% associated version of the toolbox.

% Copyright Simon Waldman / Heriot-Watt University 2014-2015
% The latest version of this function can be found at https://github.com/TeraWatt-EcoWatt2050/MIKE_tools

if (nargin < 1)
    error('Not enough arguments.');
end
if (nargin > 2)
    error('Too many arguments.');
end
if ~isa(dfsu_name, 'char')
    error('First argument should be a char with a filename');
end
if ~exist(dfsu_name,'file')
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
dfsu = DfsFileFactory.DfsuFileOpen(dfsu_name);
if ~isa(dfsu, 'DHI.Generic.MikeZero.DFS.dfsu.DfsuFile')
    error('Failed to open dfsu file');
end

%timestep info
InfoStruct.sdStepTimes = mike_tools.read_dfsu_timesteps(dfsu);
InfoStruct.NumSteps = length(InfoStruct.sdStepTimes);

%spatial metadata
InfoStruct.NumPoints = double(dfsu.NumberOfElements);
InfoStruct.NumLayers = double(dfsu.NumberOfLayers);
[xe, ye, ze] = mike_tools.calc_dfsu3_element_centres(dfsu);
InfoStruct.xe = xe';    %don't even ask about the transposition. It seems to make other stuff easier.
InfoStruct.ye = ye';
InfoStruct.ze = ze';
clear ('xe', 'ye', 'ze');
%NB If this is a 2D dfsu, then I'm not totally sure what the ze values
%represent - think they're simply the depth of the cell, rather than a
%vertical position.

%find the element numbers that correspond to layer 1, ie closest to the
%seabed
InfoStruct.BottomElementNos = 1:InfoStruct.NumLayers:InfoStruct.NumPoints;
InfoStruct.NumHorizontalPoints = length(InfoStruct.BottomElementNos);

%Magic number for missing values
InfoStruct.NAValue = double(dfsu.DeleteValueFloat);

%Find item numbers
if nargin == 2
    InfoStruct.ItemNumbers = mike_tools.fnFindDFSUItems(dfsu,ItemNames);
else
    InfoStruct.ItemNumbers = mike_tools.fnFindDFSUItems(dfsu);
end

end

