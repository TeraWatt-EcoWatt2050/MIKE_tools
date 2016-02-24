function [ xe, ye, ze ] = calc_dfsu3_element_centres( dfsu3 )
%CALC_DFSU3_ELEMENT_CENTRES Calculates element centre coordinates for a 3D
%MIKE FM dfsu file. Actually should work for a 2D one as well, but ze gives
%   cell depths rather than points in water column.
%   Input: a .NET object for a dfsu3.
%   Outputs: Three vectors with x,y and z coordinates for mesh element
%   centres.
%   Much of the code here is taken from DHI example scripts. To work, this
%   function will require MIKE Zero to be installed on the PC, and the DHI
%   toolbox to be in Matlab's search path. Tested with the 2012 edition of
%   MIKE.

% Copyright Simon Waldman / Heriot-Watt University 2015
% The latest version of this function can be found at https://github.com/TeraWatt-EcoWatt2050/MIKE_tools

if (nargin < 1)
    error('Missing arguments');
end
if ~isa(dfsu3, 'DHI.Generic.MikeZero.DFS.dfsu.DfsuFile')
    error('First input variable does not appear to be a MIKE dfsu.');
end
%FIXME should also check that it's a 3D dfsu.

% Get node coordinates
xn = double(dfsu3.X);
yn = double(dfsu3.Y);
zn = double(dfsu3.Z);

% Extract the "element table" from the dfsu, which specifies which nodes
% relate to which mesh elements, and convert it to a format that's useful
% for matlab. This is arcane for 3D, so this is copied straight from DHI
% example.

% Convert System.Int32[][] into a cell array of int32
tn3Dc = cell(dfsu3.ElementTable);
% Create element matrix from cell array
tn3D = zeros(numel(tn3Dc),6,'int32');
for i = 1:numel(tn3Dc),
    elmts = tn3Dc{i};
    tn3D(i,1:numel(elmts)) = elmts; 
end

% Use this table to calculate element centre coordinates
[xe,ye,ze] = mzCalcElmtCenterCoords(tn3D,xn,yn,zn);

end

