function [data, voxSize, omeMeta]=cziPrep(fileIn)
%% to do
% update to take n-channeled images
% e.g.   [data, voxSize, omeMeta]=cziPrep('C:\Users\Adam Tyson\Desktop\striatum.czi')
% or     [data, voxSize, omeMeta]=cziPrep
% takes a czi file, and returns the array, and voxel dimensions which can be fed into other
% functions (such as segmentation)
% if it's a single channel image, it returns one 3D array
% if it's dual channel, it assumes interleaved
% (channel1/channel2/channel1/channel2 etc), separates them and returns 2
% 3D arrays
% if not passed a file, it will just ask for one
%% only accepts one and two channel images - could be changed to accept 3 etc
%% Adam Tyson 11/11/2016 -- adamltyson@gmail.com

%%
if nargin==1 % if a file is supplied, then load it
 datacell=bfopen(fileIn); % load  data
else % otherwise, ask for it
    datacell=bfopen; % load data with a dialogue box
end
%% Grab metadata - all from https://www.openmicroscopy.org/site/support/bio-formats5.1/developers/matlab-dev.html#ome-metadata
omeMeta = datacell{1, 4};
voxelSizeX = omeMeta.getPixelsPhysicalSizeX(0).value(ome.units.UNITS.MICROM); % in µm
voxelSizeXdouble = voxelSizeX.doubleValue();                                  % The numeric value represented by this object after conversion to type double
voxelSizeY = omeMeta.getPixelsPhysicalSizeY(0).value(ome.units.UNITS.MICROM); % in µm
voxelSizeYdouble = voxelSizeY.doubleValue();                                  % The numeric value represented by this object after conversion to type double
voxelSizeZ = omeMeta.getPixelsPhysicalSizeZ(0).value(ome.units.UNITS.MICROM); % in µm
voxelSizeZdouble = voxelSizeZ.doubleValue(); 

voxSize=[voxelSizeXdouble voxelSizeYdouble voxelSizeZdouble]; % combine together ti pass one array out of function
%% work out whether single or dual channel
zeissMeta=datacell{1, 2}; % get the general metadata from the microscope (not the OME formatted metadata)
channel2name=zeissMeta.get('Global Information|Image|Channel|Name #2'); % gets the name for the second channel (if it exists)
if isa(channel2name, 'char') % if channel2name is of class char (basically does it exist, should return 1 for a 2 channel image, and 0 for a single channeled image)  
%% separate channels (if dual channel image)
for z=1:length(datacell{1,1})/2 % for the number of z images
data.channel1(:,:,z)=double(datacell{1,1}{2*z-1,1}); % get channel 1 (prob green)
data.channel2(:,:,z)=double(datacell{1,1}{2*z,1}); % get channel 2 (prob red)
end
else
 %% grab non separate channels (if single channel image)
 for z=1:length(datacell{1,1}) % for the number of z images
data.channel1(:,:,z)=double(datacell{1,1}{z,1}); % get the single channel
end
end
end