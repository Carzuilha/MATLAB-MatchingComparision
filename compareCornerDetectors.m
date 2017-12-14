%==========================================================================
%                             MAIN SCRIPT
% 
%   This is the mains script of the project. It is necessary a webcam pair 
% or a stereo image pair previously captured to make this script works.
%==========================================================================

function compareCornerDetectors

imgList = dir('middlebury');

for i = 3:size(imgList)
    
    imgName = imgList(i).name;
    
    disp(imgName);
    
end

end