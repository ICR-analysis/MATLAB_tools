function [data, voxSize]=cziPrepCux(fileIn)
% When exporting stitched images from zen, the voxel size is stripped, so
% this is a version of cziPrep that doesnt look for metadata
% specifically for the large, stiched cux1 images. 

%% need to export image window in zen (which exports all 3 channels), then cut down the 27 images to 9 (just keep red channe;)
%% to do
% e.g.   [data, voxSize]=cziPrep('C:\Users\Adam Tyson\Desktop\striatum.czi')
% or     [data, voxSize]=cziPrep
% takes a czi file, and returns the array, and voxel dimensions which can be fed into other
% functions (such as segmentation)
% if not passed a file, it will just ask for one
%% only accepts one and two channel images - could be changed to accept 3 etc
%% Adam Tyson 09/03/2017 -- adamltyson@gmail.com
%% keep up to data if acqusition changes
%voxSize=[1.8450 1.8450 50]; % this is true if the image hasnt been scaled to 519x519
voxSize=[4.7778 4.7778 50]; % if the image is scaled to 519 x 519
%%
if nargin==1 % if a file is supplied, then load it
 datacell=bfopen(fileIn); % load  data
else % otherwise, ask for it
    datacell=bfopen; % load data with a dialogue box
end
%% get the single channel from the 3 channel image (the other two channels are blank)
for z=1:length(datacell{1,1})/3 % for the number of z images
data.channel1(:,:,z)=double(datacell{1,1}{3*z-2,1}); % get channel 1 (prob green)
end

end

% end