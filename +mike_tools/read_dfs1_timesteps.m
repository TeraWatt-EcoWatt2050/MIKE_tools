function [ sdStepTimes ] = read_dfs1_timesteps( dfs1 )
%READ_DFS1_TIMESTEPS Reads timestep info from a MIKE dfs1 file
%   Input is the dfs1 .net object. Output is a vector of the MATLAB serial
%   dates of the time steps. This function is mostly necessary to convert
%   from .NET time formats to MATLAB ones.

% This function will only work on a PC with MIKE installed. Tested with the 2012 edition of MIKE and the
% associated version of the toolbox.

% Copyright Simon Waldman 2014-2017, except that which is taken from
% Stackexchange (which is licensed under Creative Commons - see the
% original for details)
% The latest version of this function can be found at https://github.com/TeraWatt-EcoWatt2050/MIKE_tools

if (nargin < 1)
    error('Missing arguments');
end
if ~isa(dfs1, 'DHI.Generic.MikeZero.DFS.dfs123.Dfs1File')
    error('Input variable does not appear to be a MIKE dfs1.');
end

% Reading the start time is nasty, because it comes in a .NET object, which
% stores time in a totally different way to MATLAB.
% This method comes from http://stackoverflow.com/a/7127073/1045427
sdStartTime = double(dfs1.FileInfo.TimeAxis.StartDateTime.Ticks) * 1e-7/86400 + 367; %correcting the start of the epoch, and seconds -> days.
NumSteps = double(dfs1.FileInfo.TimeAxis.NumberOfTimeSteps);
sdStepLength = double(dfs1.FileInfo.TimeAxis.TimeStep) / (3600*24); %step length in days

% Create a vector of the serial dates of the timesteps
sdStepTimes = sdStartTime + sdStepLength * (0:NumSteps - 1);

end

