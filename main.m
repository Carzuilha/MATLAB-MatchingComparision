%==========================================================================
%                             MAIN SCRIPT
% 
%   This is the main script of the project. It is necessary a pair of stereo 
% images to make this script works.
%==========================================================================

function main

% ========================= CHOOSING DATABASE =============================

DATABASE_NAME = 'Middlebury';
%DATABASE_NAME = 'Minoru3D';

DATABASE_TYPE = 'png';
%DATABASE_TYPE = 'jpg';

% ========================= MATCHING CORNERS ==============================

% Do a single matching comparision.
singleMatching(DATABASE_NAME, DATABASE_TYPE);

% Do a matching comparision with gaussian noise.
%gaussianMatching(DATABASE_NAME, DATABASE_TYPE);

% End of the script.
end