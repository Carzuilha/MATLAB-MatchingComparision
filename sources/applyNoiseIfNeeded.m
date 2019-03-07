%==========================================================================
%                         APPLY NOISE (IF NEEDED)
% 
%   This script is reponsible for applies noise to both images of the 
% stereo pair, if it's necessary.
%==========================================================================

function [lImg, rImg] = applyNoiseIfNeeded(lImg, rImg, noiseType)

%   Applies the corresponding noise (if added).
switch noiseType
    case 'Gaussian'
        lImg = imnoise(lImg, 'gaussian');
        rImg = imnoise(rImg, 'gaussian');
    otherwise
        return;
end

%   Ends the script.
end