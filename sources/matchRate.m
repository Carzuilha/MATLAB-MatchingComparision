%==========================================================================
%                              MATCH RATE
% 
%   This script is responsible for obtain the rate (%) of matches between 
% corners of a stereo pair.
%==========================================================================

function mRate = matchRate(matchM, matchL, matchR)

%   Calculates the rate (%) of matching corners.
mRate = (length(matchM) / ((length(matchL) + length(matchR)) / 2)) * 100;

%   Ends the script.
end