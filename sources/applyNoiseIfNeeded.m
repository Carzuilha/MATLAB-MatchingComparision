%==========================================================================
%                         APPLY NOISE (IF NEEDED)
% 
%   This script is reponsible for applies noise to both images of the 
% stereo pair, if it's necessary.
%==========================================================================

function [lImage, rImage] = applyNoiseIfNeeded(lImage, rImage, noiseType)

%   Applies the corresponding noise (if added).
switch noiseType
    case 'Gaussian'
        lImage = imnoise(lImage, 'gaussian');
        rImage = imnoise(rImage, 'gaussian');
    otherwise
        return;
end

%   Ends the script.
end