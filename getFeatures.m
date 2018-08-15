%==========================================================================
%                           GET IMAGE FEATURES
% 
%   This script is reponsible for the generation of the features (corners)
% inside both images of the stereo pair.
%==========================================================================

function [lFtrs, rFtrs] = getFeatures(lImg, rImg, algorithm)

switch algorithm
    case 'BRISK'
        lFtrs = detectBRISKFeatures(lImg);
        rFtrs = detectBRISKFeatures(rImg);
    case 'FAST'
        lFtrs = detectFASTFeatures(lImg);
        rFtrs = detectFASTFeatures(rImg);
    case 'Harris'
        lFtrs = detectHarrisFeatures(lImg);
        rFtrs = detectHarrisFeatures(rImg);
    case 'Min8Val'
        lFtrs = detectMinEigenFeatures(lImg);
        rFtrs = detectMinEigenFeatures(rImg);
    case 'MSER'
        lFtrs = detectMSERFeatures(lImg);
        rFtrs = detectMSERFeatures(rImg);
    case 'SURF'
        lFtrs = detectSURFFeatures(lImg);
        rFtrs = detectSURFFeatures(rImg);
end

% ================== GENERATING CORNERS AND MATCHES =======================

end