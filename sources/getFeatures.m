%==========================================================================
%                             GET FEATURES
% 
%   This script is reponsible for the generation of the features (corners)
% inside both images of the stereo pair.
%==========================================================================

function [lFeats, rFeats, estTime] = getFeatures(lImage, rImage, algorithm)

%   Detects features based on the chosen algorithm.
switch algorithm
    case 'BRISK'
        tic;
        lFeats = detectBRISKFeatures(lImage);
        rFeats = detectBRISKFeatures(rImage);
        estTime = round(toc, 3);
    case 'FAST'
        tic;
        lFeats = detectFASTFeatures(lImage);
        rFeats = detectFASTFeatures(rImage);
        estTime = round(toc, 3);
    case 'Harris'
        tic;
        lFeats = detectHarrisFeatures(lImage);
        rFeats = detectHarrisFeatures(rImage);
        estTime = round(toc, 3);
    case 'Min8Val'
        tic;
        lFeats = detectMinEigenFeatures(lImage);
        rFeats = detectMinEigenFeatures(rImage);
        estTime = round(toc, 3);
    case 'MSER'
        tic;
        lFeats = detectMSERFeatures(lImage);
        rFeats = detectMSERFeatures(rImage);
        estTime = round(toc, 3);
    case 'SURF'
        tic;
        lFeats = detectSURFFeatures(lImage);
        rFeats = detectSURFFeatures(rImage);
        estTime = round(toc, 3);
end

%   Ends the script.
end