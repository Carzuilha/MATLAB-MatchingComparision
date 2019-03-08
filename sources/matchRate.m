%==========================================================================
%                              MATCH RATE
% 
%   This script is responsible for obtain the rate (%) of matches between 
% corners of a stereo pair.
%==========================================================================

function matchRate = matchRate(matMatch, lMatch, rMatch)

%   Calculates the rate (%) of matching corners.
matchRate = (length(matMatch) / ((length(lMatch) + length(rMatch)) / 2)) * 100;

%   Ends the script.
end