mike_tools is a MATLAB package containing quality-of-life scripts to make it easier
to read and do things with the output from the MIKE by DHI software in MATLAB.
Many of the tools will only work if you have (a) The MIKE software; and (b) the DHI 
MATLAB toolkit installed (and, in the latter case, in your MATLAB path)

This was written for the 2012 edition of MIKE. It has not been tested with subsequent versions,
although most of it is likely to keep on working unless the format of the dfs* files changes.

Author: Simon Waldman, Heriot-Watt University, 2015-17.
Contact: smw13@hw.ac.uk

If you use this package in work that leads to publication, an acknowledgement
would be appreciated. The latest version may be found at https://github.com/TeraWatt-EcoWatt2050/MIKE_tools

NB: These tools are in ongoing development as and when I have a need for them,
    and in the interests of tidying them up I am likely to rename them and/or 
    break backwards compatibility in the future.


How to install
---

To use a package of this type: Copy the whole folder `+mike_tools` - *not* just
    the contents of the folder - into your MATLAB path. *Do not rename it*.
    Call functions from the package by prepending `mike_tools.` to their names.

Example: If you keep your MATLAB scripts in `D:\matlab-scripts\`, then this could be
    in `D:\matlab-scripts\+mike_tools`. `D:\matlab-scripts` would need to be on the path
    (or be the current directory) but `D:\matlab-scripts\+mike_tools` would not need to be.


Descritions of functions
---

See file headers for fuller details.

**fnReadDFSUMetadata.m**: opens a .dfsu file, returning both a .NET object 
    representing the file and a MATLAB struct with metadata for it in usable
    forms. This function calls many of the other tools here, giving the results
    in the metadata struct.

**fnFindDFSUItems.m**: Reads the item names and numbers from a .dfsu file, returning them
    as a MATLAB containers.Map object. You can then see a list of items with 
    `keys(mapname)` or get a specific item's number with (for example)
    `mapname('U Velocity')`.

**FindMIKEElementNo.m**: Finds the element number(s) in a MIKE flexible mesh that correspond
    to one or more sets of xy coordinates.

**calc_dfsu3_element_centres.m**: Calculates coordinates of element centres from a .dfsu file.

**read_dfsu_timesteps.m**: Reads the time information from a dfsu object and returns
    a vector of all the timesteps in MATLAB serial date format.

**fnMIKEgetcoastlines.m**: Extracts the coastlines (non-open boundaries) from a MIKE mesh file and 
    returns two matrices such that `line(XCoast, YCoast);` will draw them.
