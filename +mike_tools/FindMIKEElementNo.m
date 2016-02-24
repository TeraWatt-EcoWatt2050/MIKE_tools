function [ output ] = FindMIKEElementNo( MeshFilename, X, Y )
%FINDMIKEELEMENTNO Finds the element number(s) in a MIKE flexible mesh
% corresponding to one or more X/Y coordinate pairs

% Inputs:   MeshFilename: Path and filename of the MIKE .mesh file
%           X & Y: Vectors with coordinates of one or more points, in the
%                   same coordinate system that the model uses (tested with
%                   UTM). Must be the same length as each other

% Copyright Simon Waldman / Heriot-Watt University 2016
% The latest version of this function can be found at https://github.com/TeraWatt-EcoWatt2050/MIKE_tools

%% Check inputs
assert( exist(MeshFilename)==2, 'MeshFilename not found'); 
assert( exist('X') && exist('Y') && size(X, 1) == 1 && all( size(X) == size(Y) ), 'X and Y must be row vectors of equal size.');

%% Read mesh file
[et, nodes] = mzReadMesh(MeshFilename);  %et = element table; nodes = nodes.
trMesh2D = triangulation(et(:,1:3), nodes(:,1:2)); % 2D version that doesn't have elevation info. Makes some stuff easier.
clear et nodes;

%% Find the element numbers
ElNo = pointLocation(trMesh2D, X', Y');
output = ElNo';

end

