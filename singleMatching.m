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
timeCsv = fopen(strcat('outputs/', DB_NAME, '_SingleTim.csv'), 'w');
crpsCsv = fopen(strcat('outputs/', DB_NAME, '_SingleCPS.csv'), 'w');

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
fprintf(rateCsv, 'MIN8VAL (%%), MSER (%%),SURF (%%)\n');

fprintf(timeCsv, 'IMAGE NAME,');
fprintf(timeCsv, 'BRISK (s),FAST (s),HARRIS (s),');
fprintf(timeCsv, 'MIN8VAL (s), MSER (s),SURF (s)\n');

fprintf(crpsCsv, 'IMAGE NAME,');
fprintf(crpsCsv, 'BRISK (matches/s),FAST (matches/s),HARRIS (matches/s),');
fprintf(crpsCsv, 'MIN8VAL (matches/s),MSER (matches/s),SURF (matches/s)\n');

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
allTimes = zeros(numImgs(1), 6);
allCrPrS = zeros(numImgs(1), 6);

for i = 1:numImgs
       
    % Then, loads the stereo pair...
    [lImg, rImg] = loadPair(DB_NAME, DB_TYPE, imgList(i).name);
    
    % ...writes the name of stereo pair on each CSV...
    fprintf(cornCsv, '%12s,' , imgList(i).name);
    fprintf(matcCsv, '%12s,' , imgList(i).name);
    fprintf(rateCsv, '%12s,' , imgList(i).name);
    fprintf(timeCsv, '%12s,' , imgList(i).name);
    fprintf(crpsCsv, '%12s,' , imgList(i).name);
    
    % ...converts the stereo pair to a grayscale if needed...
    if size(lImg, 3) == 3 
        lImg = rgb2gray(lImg);
        rImg = rgb2gray(rImg);
    end
    
    % ...detects features using all the choosen corner detectors...
    [lBrisk, rBrisk, tBrisk]     = getFeatures(lImg, rImg, 'BRISK'  );
    [lFast, rFast, tFast]        = getFeatures(lImg, rImg, 'FAST'   );
    [lHarris, rHarris, tHarris]  = getFeatures(lImg, rImg, 'Harris' );
    [lMinVal, rMinVal, tMinVal]  = getFeatures(lImg, rImg, 'Min8Val');
    [lMser, rMser, tMser]        = getFeatures(lImg, rImg, 'MSER'   );
    [lSurf, rSurf, tSurf]        = getFeatures(lImg, rImg, 'SURF'   );
           
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
    mMinVal = matchNumber(lImg, rImg, lMinVal, rMinVal);
    mMser   = matchNumber(lImg, rImg, lMser  , rMser  );
    mSurf   = matchNumber(lImg, rImg, lSurf  , rSurf  );
        
    % ...and writes the obtained values in the second CSV file.
    fprintf(matcCsv, '%d,', length(mBrisk) );
    fprintf(matcCsv, '%d,', length(mFast)  );
    fprintf(matcCsv, '%d,', length(mHarris));
    fprintf(matcCsv, '%d,', length(mMinVal));
    fprintf(matcCsv, '%d,', length(mMser)  );
    fprintf(matcCsv, '%d' , length(mSurf)   );
    
    % Then, calculate the match rate (%%) for each image...    
    mrBrisk  = matchRate(mBrisk , lBrisk , rBrisk );
    mrFast   = matchRate(mFast  , lFast  , rFast  );
    mrHarris = matchRate(mHarris, lHarris, rHarris);
    mrMinVal = matchRate(mMinVal, lMinVal, rMinVal);
    mrMser   = matchRate(mMser  , lMser  , rMser  );
    mrSurf   = matchRate(mSurf  , lSurf  , rSurf  );
        
    % ...and writes the obtained rates in the third CSV file.    
    fprintf(rateCsv, '%.2f,', mrBrisk );
    fprintf(rateCsv, '%.2f,', mrFast  );
    fprintf(rateCsv, '%.2f,', mrHarris);
    fprintf(rateCsv, '%.2f,', mrMinVal);
    fprintf(rateCsv, '%.2f,', mrMser  );
    fprintf(rateCsv, '%.2f' , mrSurf  );
    
    % So, we write the time spent finding corners in the forth file...
    fprintf(timeCsv, '%d,', tBrisk );
    fprintf(timeCsv, '%d,', tFast  );
    fprintf(timeCsv, '%d,', tHarris);
    fprintf(timeCsv, '%d,', tMinVal);
    fprintf(timeCsv, '%d,', tMser  );
    fprintf(timeCsv, '%d' , tSurf  );
    
    % ...and the corners per second ratio in the last file.
    fprintf(crpsCsv, '%d,', ...
           round((length(lBrisk) + length(rBrisk))   / tBrisk ));
    fprintf(crpsCsv, '%d,', ...
           round((length(lFast) + length(rFast))     / tFast  ));
    fprintf(crpsCsv, '%d,', ...
           round((length(lHarris) + length(rHarris)) / tHarris));
    fprintf(crpsCsv, '%d,', ...
           round((length(lMinVal) + length(rMinVal)) / tMinVal));
    fprintf(crpsCsv, '%d,', ...
           round((length(lMser) + length(rMser))     / tMser  ));
    fprintf(crpsCsv, '%d' , ...
           round((length(lSurf) + length(rSurf))     / tSurf  ));
       
    % Finally, finishes the file edit.
    fprintf(cornCsv, '\n');
    fprintf(matcCsv, '\n');
    fprintf(rateCsv, '\n');
    fprintf(timeCsv, '\n');
    fprintf(crpsCsv, '\n');
    
    % ...and update the needed values for post-calculation, if needs.
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
    
    allMtchs(i, 1) = length(mBrisk );
    allMtchs(i, 2) = length(mFast  );
    allMtchs(i, 3) = length(mHarris);
    allMtchs(i, 4) = length(mMinVal);
    allMtchs(i, 5) = length(mMser  );
    allMtchs(i, 6) = length(mSurf  );
    
    allRates(i, 1) = mrBrisk ;
    allRates(i, 2) = mrFast  ;
    allRates(i, 3) = mrHarris;
    allRates(i, 4) = mrMinVal;
    allRates(i, 5) = mrMser  ;
    allRates(i, 6) = mrSurf  ;
    
    allTimes(i, 1) = tBrisk ;
    allTimes(i, 2) = tFast  ;
    allTimes(i, 3) = tHarris;
    allTimes(i, 4) = tMinVal;
    allTimes(i, 5) = tMser  ;
    allTimes(i, 6) = tSurf  ;
    
    allCrPrS(i, 1) = (lCorners(i, 1) + lCorners(i, 1)) / allTimes(i, 1);
    allCrPrS(i, 2) = (lCorners(i, 2) + lCorners(i, 2)) / allTimes(i, 2);
    allCrPrS(i, 3) = (lCorners(i, 3) + lCorners(i, 3)) / allTimes(i, 3);
    allCrPrS(i, 4) = (lCorners(i, 4) + lCorners(i, 4)) / allTimes(i, 4);
    allCrPrS(i, 5) = (lCorners(i, 5) + lCorners(i, 5)) / allTimes(i, 5);
    allCrPrS(i, 6) = (lCorners(i, 6) + lCorners(i, 6)) / allTimes(i, 6);
    
end

% =================== AVERAGE, MEAN, TIME AND CPS =========================

% Writes the average of each set of values...

fprintf(cornCsv, '\n');
fprintf(matcCsv, '\n');
fprintf(rateCsv, '\n');
fprintf(timeCsv, '\n');
fprintf(crpsCsv, '\n');

fprintf(cornCsv, '%12s,' , "AVRG");
fprintf(matcCsv, '%12s,' , "AVRG");
fprintf(rateCsv, '%12s,' , "AVRG");
fprintf(timeCsv, '%12s,' , "AVRG");
fprintf(crpsCsv, '%12s,' , "AVRG");

for i = 1:6
    fprintf(cornCsv, '%.2f,%.2f,', mean(lCorners(:,i)), mean(rCorners(:,i)));
    fprintf(matcCsv, '%.2f,', mean(allMtchs(:,i)));
    fprintf(rateCsv, '%.2f,', mean(allRates(:,i)));
    fprintf(timeCsv, '%.2f,', mean(allTimes(:,i)));
    fprintf(crpsCsv, '%.2f,', mean(allCrPrS(:,i)));
end

% ... and the standart deviation.

fprintf(cornCsv, '\n');
fprintf(matcCsv, '\n');
fprintf(rateCsv, '\n');
fprintf(timeCsv, '\n');
fprintf(crpsCsv, '\n');

fprintf(cornCsv, '%12s,' , "STD_DER");
fprintf(matcCsv, '%12s,' , "STD_DER");
fprintf(rateCsv, '%12s,' , "STD_DER");
fprintf(timeCsv, '%12s,' , "STD_DER");
fprintf(crpsCsv, '%12s,' , "STD_DER");

for i = 1:6
    fprintf(cornCsv, '%.2f,%.2f,', std(lCorners(:,i)), std(rCorners(:,i)));
    fprintf(matcCsv, '%.2f,', std(allMtchs(:,i)));
    fprintf(rateCsv, '%.2f,', std(allRates(:,i)));
    fprintf(timeCsv, '%.2f,', std(allTimes(:,i)));
    fprintf(crpsCsv, '%.2f,', std(allCrPrS(:,i)));
end

% Closes all the CSV files ------------------------------------------------
fclose(cornCsv);
fclose(matcCsv);
fclose(rateCsv);
fclose(timeCsv);
fclose(crpsCsv);

% End of the script.
end