function [ XCoast, YCoast ] = fnMIKEgetcoastlines( meshFile )
%FNMIKEGETCOASTLINES Extract the coastlines from a MIKE mesh file.
%   Inputs:     meshFile: Filename of a MIKE .mesh file
%   Outputs:    XCoast, YCoast: 2xn matrices of pairs of X and Y coords to
%               draw lines between to make up the coast.
%
%       Example of use of output:
%           line(XCoast, YCoast, 'colour', 'black');

% Simon Waldman / Heriot-Watt University, April 2017

[et, nodes] = mzReadMesh(meshFile);  %et = element table; nodes = nodes.

CoastNodeIndices = find( nodes(:,4) == 1 ); % code 1 is normally a land boundary

%now we know which nodes are on land boundaries, but not which ones we
%should draw lines between.

trMesh = triangulation(et, nodes(:,1), nodes(:,2));

Edges = freeBoundary(trMesh); %this gives a list of pairs of node numbers that are edges of the mesh - but some of these will be open boundaries, which we don't want.

coastrows = all(ismember(Edges, CoastNodeIndices), 2);
Coast = Edges(coastrows, :);

XCoast = [ nodes(Coast(:,1), 1) nodes(Coast(:,2), 1) ]';
YCoast = [ nodes(Coast(:,1), 2) nodes(Coast(:,2), 2) ]';

end
