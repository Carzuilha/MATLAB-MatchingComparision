%==========================================================================
%                            SINGLE MATCHING
% 
%   This script is reponsible for the default matching process between 
% corners. The obtained results are stored in .csv files.
%==========================================================================

function singleMatching(DB_NAME, DB_TYPE)

% ====================== CREATING THE FILES ===============================

% Create CSV files for the corners, the matches and the rates -------------

cornCsv = fopen(strcat('outputs/', DB_NAME, '_SingleCrn.csv'), 'w');
matcCsv = fopen(strcat('outputs/', DB_NAME, '_SingleMtc.csv'), 'w');
rateCsv = fopen(strcat('outputs/', DB_NAME, '_SingleRts.csv'), 'w');

% Prepares the files to receive the data ----------------------------------

fprintf(cornCsv, 'IMAGE NAME,');
fprintf(cornCsv, 'BRISK (Left), BRISK (Right),');
fprintf(cornCsv, 'FAST (Left), FAST (Right),');
fprintf(cornCsv, 'HARRIS (Left), HARRIS (Right),');
fprintf(cornCsv, 'MIN8VAL (Left), MIN8VAL (Right),');
fprintf(cornCsv, 'MSER (Left), MSER (Right),');
fprintf(cornCsv, 'SURF (Left), SURF (Right)');
fprintf(cornCsv, '\n');

fprintf(matcCsv, 'IMAGE NAME,');
fprintf(matcCsv, 'BRISK,FAST,HARRIS,MIN8VAL,MSER,SURF\n');

fprintf(rateCsv, 'IMAGE NAME,');
fprintf(rateCsv, 'BRISK (%%),FAST (%%),HARRIS (%%),');
fprintf(rateCsv, 'MIN8VAL (%%), MSER (%%) ,SURF (%%)\n');

% ================= CALCULATING THE CORNERS AND MATCHES ===================

% First, loads the image list...
imgList = dir(strcat('dataset/', DB_NAME));

imgList = imgList(3:end,:);
numImgs = size(imgList);

% ...and loads the values for the statistic evaluation.
lCorners = zeros(numImgs(1), 6);
rCorners = zeros(numImgs(1), 6);
allMtchs = zeros(numImgs(1), 6);
allRates = zeros(numImgs(1), 6);

for i = 1:numImgs
       
    % Then, loads the stereo pair...
    [lImg, rImg] = loadPair(DB_NAME, DB_TYPE, imgList(i).name);
    
    % ...writes the name of stereo pair on each CSV...
    fprintf(cornCsv, '%12s,' , imgList(i).name);
    fprintf(matcCsv, '%12s,' , imgList(i).name);
    fprintf(rateCsv, '%12s,' , imgList(i).name);
    
    % ...converts the stereo pair to a grayscale if needed...
    if size(lImg, 3) == 3 
        lImg = rgb2gray(lImg);
        rImg = rgb2gray(rImg);
    end
    
    % ...detects features using all the choosen corner detectors...
    [lBrisk, rBrisk]    = getFeatures(lImg, rImg, 'BRISK'  );
    [lFast, rFast]      = getFeatures(lImg, rImg, 'FAST'   );
    [lHarris, rHarris]  = getFeatures(lImg, rImg, 'Harris' );
    [lMinVal, rMinVal]  = getFeatures(lImg, rImg, 'Min8Val');
    [lMser, rMser]      = getFeatures(lImg, rImg, 'MSER'   );
    [lSurf, rSurf]      = getFeatures(lImg, rImg, 'SURF'   );
           
    % ...and writes the obtained values in the first CSV file.
    fprintf(cornCsv, '%d,%d,', length(lBrisk)   , length(rBrisk) );
    fprintf(cornCsv, '%d,%d,', length(lFast)    , length(rFast)  );
    fprintf(cornCsv, '%d,%d,', length(lHarris)  , length(rHarris));
    fprintf(cornCsv, '%d,%d,', length(lMinVal)  , length(rMinVal));
    fprintf(cornCsv, '%d,%d,', length(lMser)    , length(rMser)  );
    fprintf(cornCsv, '%d,%d,', length(lSurf)    , length(rSurf)  );
    
    %   Then, calculate the number of unique matches for each image...
    mBrisk  = matchNumber(lImg, rImg, lBrisk , rBrisk );
    mFast   = matchNumber(lImg, rImg, lFast  , rFast  );
    mHarris = matchNumber(lImg, rImg, lHarris, rHarris);
    mMinval = matchNumber(lImg, rImg, lMinVal, rMinVal);
    mMser   = matchNumber(lImg, rImg, lMser  , rMser  );
    mSurf   = matchNumber(lImg, rImg, lSurf  , rSurf  );
        
    % ...and writes the obtained values in the second CSV file.
    fprintf(matcCsv, '%d,', length(mBrisk) );
    fprintf(matcCsv, '%d,', length(mFast)  );
    fprintf(matcCsv, '%d,', length(mHarris));
    fprintf(matcCsv, '%d,', length(mMinval));
    fprintf(matcCsv, '%d,', length(mMser)  );
    fprintf(matcCsv, '%d' , length(mSurf)   );
    
    % Finally, calculate the match rate (%%) for each image...    
    tBrisk  = matchRate(mBrisk , lBrisk , rBrisk );
    tFast   = matchRate(mFast  , lFast  , rFast  );
    tHarris = matchRate(mHarris, lHarris, rHarris);
    tMinVal = matchRate(mMinval, lMinVal, rMinVal);
    tMser   = matchRate(mMser  , lMser  , rMser  );
    tSurf   = matchRate(mSurf  , lSurf  , rSurf  );
        
    % ...and writes the obtained rates in the third CSV file.    
    fprintf(rateCsv, '%.2f,', tBrisk );
    fprintf(rateCsv, '%.2f,', tFast  );
    fprintf(rateCsv, '%.2f,', tHarris);
    fprintf(rateCsv, '%.2f,', tMinVal);
    fprintf(rateCsv, '%.2f,', tMser  );
    fprintf(rateCsv, '%.2f' , tSurf  );
    
    fprintf(cornCsv, '\n');
    fprintf(matcCsv, '\n');
    fprintf(rateCsv, '\n');
    
    % Finally, update the sum and uses it on average calculation, if needs.
    lCorners(i, 1) = length(lBrisk );
    lCorners(i, 2) = length(lFast  );
    lCorners(i, 3) = length(lHarris);
    lCorners(i, 4) = length(lMinVal);
    lCorners(i, 5) = length(lMser  );
    lCorners(i, 6) = length(lSurf  );
    
    rCorners(i, 1) = length(rBrisk );
    rCorners(i, 2) = length(rFast  );
    rCorners(i, 3) = length(rHarris);
    rCorners(i, 4) = length(rMinVal);
    rCorners(i, 5) = length(rMser  );
    rCorners(i, 6) = length(rSurf  );
    
end

% ================ CALCULATING METRICS AND MEAN VALUES ====================

% Writes the average of each set of values...

fprintf(cornCsv, '\n');
fprintf(matcCsv, '\n');
fprintf(rateCsv, '\n');

fprintf(cornCsv, '%12s,' , "AVRG");
fprintf(matcCsv, '%12s,' , "AVRG");
fprintf(rateCsv, '%12s,' , "AVRG");

for i = 1:6
    fprintf(cornCsv, '%.2f,%.2f,', mean(lCorners(:,i)), mean(rCorners(:,i)));
    fprintf(matcCsv, '%.2f,', mean(allMtchs(:,i)));
    fprintf(rateCsv, '%.2f,', mean(allRates(:,i)));
end

% ... and the standart deviation.

fprintf(cornCsv, '\n');
fprintf(matcCsv, '\n');
fprintf(rateCsv, '\n');

fprintf(cornCsv, '%12s,' , "STD_DER");
fprintf(matcCsv, '%12s,' , "STD_DER");
fprintf(rateCsv, '%12s,' , "STD_DER");

for i = 1:6
    fprintf(cornCsv, '%.2f,%.2f,', std(lCorners(:,i)), std(rCorners(:,i)));
    fprintf(matcCsv, '%.2f,', std(allMtchs(:,i)));
    fprintf(rateCsv, '%.2f,', std(allRates(:,i)));
end

% Closes all the CSV files ------------------------------------------------
fclose(cornCsv);
fclose(matcCsv);
fclose(rateCsv);

% End of the script.
end