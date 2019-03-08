%==========================================================================
%                             MATCH NUMBER
% 
%   This script is responsible for obtain the number of matches between 
% corners of a stereo pair.
%==========================================================================

function vldMtchs = matchNumber(lImage, rImage, lFeats, rFeats)

%   Calculates the number of unique matches between the corners of the 
% images.
[lFeat, vldPts] = extractFeatures(lImage, lFeats);
[rFeat, ~     ] = extractFeatures(rImage, rFeats);
allMtchs = matchFeatures(lFeat, rFeat, 'Unique', true);
vldMtchs = vldPts(allMtchs(:,1),:);

%   Ends the script.
end