%==========================================================================
%                               LOAD PAIR
% 
%   This script is reponsible for load both images of the stereo pair.
%==========================================================================

function [lImage, rImage] = loadPair(dbName, dbType, imgName)

%   Loads the images.
lImage = imread(strcat('../dataset/', dbName, '/', imgName, '/im0.', dbType));
rImage = imread(strcat('../dataset/', dbName, '/', imgName, '/im1.', dbType));

%   Ends the script.
end