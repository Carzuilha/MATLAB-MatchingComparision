%==========================================================================
%                             MATCH NUMBER
% 
%   This script is responsible for obtain the number of matches between 
% corners of a stereo pair.
%==========================================================================

function vldMtchs = matchNumber(lImg, rImg, lFtrs, rFtrs)

% Calculates the number of unique matches between the corners of the images.
[lFeat, vldPts] = extractFeatures(lImg, lFtrs);
[rFeat, ~     ] = extractFeatures(rImg, rFtrs);        
allMtchs = matchFeatures(lFeat, rFeat, 'Unique', true);
vldMtchs = vldPts(allMtchs(:,1),:);

% End of the script.
end