%==========================================================================
%                             MAIN SCRIPT
% 
%   This is the mains script of the project. It is necessary a webcam pair 
% or a stereo image pair previously captured to make this script works.
%==========================================================================

function compareCornerDetectors

imgList = dir('middlebury');
outputF = fopen('Middlebury.csv', 'w');

fprintf(outputF, 'IMAGE NAME,');
fprintf(outputF, 'BRISK (Left), BRISK (Right),');
fprintf(outputF, 'FAST (Left), FAST (Right),');
fprintf(outputF, 'HARRIS (Left), HARRIS (Right),');
fprintf(outputF, 'MIN8VAL (Left), MIN8VAL (Right),');
fprintf(outputF, 'SURF (Left), SURF (Right),');
fprintf(outputF, 'MSER (Left), MSER (Right)');
fprintf(outputF, '\n');

for i = 3:size(imgList)
        
    imgName = imgList(i).name;
    
    lImg = imread(strcat('middlebury', '/', imgName, '/im0.png'));
    rImg = imread(strcat('middlebury', '/', imgName, '/im1.png'));
    
    lImg = rgb2gray(lImg);
    rImg = rgb2gray(rImg);
    
    briskL = detectBRISKFeatures(lImg);
    briskR = detectBRISKFeatures(rImg);
    
    fastL = detectFASTFeatures(lImg);
    fastR = detectFASTFeatures(rImg);
    
    harrisL = detectBRISKFeatures(lImg);
    harrisR = detectBRISKFeatures(rImg);
    
    minvalL = detectBRISKFeatures(lImg);
    minvalR = detectBRISKFeatures(rImg);
    
    surfL = detectBRISKFeatures(lImg);
    surfR = detectBRISKFeatures(rImg);
    
    mserL = detectMSERFeatures(lImg);
    mserR = detectMSERFeatures(rImg);
       
    fprintf(outputF, '%12s,' , imgName);
    fprintf(outputF, '%d,%d,', length(briskL) , length(briskR) );
    fprintf(outputF, '%d,%d,', length(fastL)  , length(fastR)  );
    fprintf(outputF, '%d,%d,', length(harrisL), length(harrisR));
    fprintf(outputF, '%d,%d,', length(minvalL), length(minvalR));
    fprintf(outputF, '%d,%d,', length(surfL)  , length(surfR)  );
    fprintf(outputF, '%d,%d' , length(mserL)  , length(mserR)  );
    fprintf(outputF, '\n');
       
end

fclose(outputF);

end