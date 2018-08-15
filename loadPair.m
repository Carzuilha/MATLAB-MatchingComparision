%==========================================================================
%                            SINGLE MATCHING
% 
%   This script is reponsible for load both images of the stereo pair.
%==========================================================================

function [lImg, rImg] = loadPair(dbName, dbType, imgName)

lImg = imread(strcat('dataset/', dbName, '/', imgName, '/im0.', dbType));
rImg = imread(strcat('dataset/', dbName, '/', imgName, '/im1.', dbType));

% ================== GENERATING CORNERS AND MATCHES =======================

end