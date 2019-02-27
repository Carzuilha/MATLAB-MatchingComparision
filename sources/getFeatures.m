%==========================================================================
%                           GET IMAGE FEATURES
% 
%   This script is reponsible for the generation of the features (corners)
% inside both images of the stereo pair.
%==========================================================================

function [lFtrs, rFtrs, eTime] = getFeatures(lImg, rImg, algorithm)

%   Detects features based on the chosen algorithm.
switch algorithm
    case 'BRISK'
        tic;
        lFtrs = detectBRISKFeatures(lImg);
        rFtrs = detectBRISKFeatures(rImg);
        eTime = round(toc, 3);
    case 'FAST'
        tic;
        lFtrs = detectFASTFeatures(lImg);
        rFtrs = detectFASTFeatures(rImg);
        eTime = round(toc, 3);
    case 'Harris'
        tic;
        lFtrs = detectHarrisFeatures(lImg);
        rFtrs = detectHarrisFeatures(rImg);
        eTime = round(toc, 3);
    case 'Min8Val'
        tic;
        lFtrs = detectMinEigenFeatures(lImg);
        rFtrs = detectMinEigenFeatures(rImg);
        eTime = round(toc, 3);
    case 'MSER'
        tic;
        lFtrs = detectMSERFeatures(lImg);
        rFtrs = detectMSERFeatures(rImg);
        eTime = round(toc, 3);
    case 'SURF'
        tic;
        lFtrs = detectSURFFeatures(lImg);
        rFtrs = detectSURFFeatures(rImg);
        eTime = round(toc, 3);
end

%   Ends the script.
end