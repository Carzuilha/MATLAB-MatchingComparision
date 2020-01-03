%==========================================================================
%                              MAIN SCRIPT
% 
%   This is the main script of the project. It is necessary a dataset of 
% stereo images to make it works.
%==========================================================================

function main

% =========================== PARAMETERS ==================================

DATA_SOURCE = 'Middlebury';
%DATA_SOURCE = 'Minoru3D';

FILE_FORMAT = 'png';
%FILE_FORMAT = 'jpg';

NOISE_TYPE = 'Single';
%NOISE_TYPE = 'Gaussian';

%CSV_SEPARATOR = ',';
CSV_SEPARATOR = ';';

% ====================== CREATING THE FILES ===============================

%   Creates CSV files for the corners, the matches the rates, the time spent on matches, 
% and the corners-per-second correlation.
cornCsv = fopen(strcat('../outputs/', DATA_SOURCE, '_', NOISE_TYPE, 'Crn.csv'), 'w');
matcCsv = fopen(strcat('../outputs/', DATA_SOURCE, '_', NOISE_TYPE, 'Mtc.csv'), 'w');
rateCsv = fopen(strcat('../outputs/', DATA_SOURCE, '_', NOISE_TYPE, 'Rts.csv'), 'w');
timeCsv = fopen(strcat('../outputs/', DATA_SOURCE, '_', NOISE_TYPE, 'Tim.csv'), 'w');
crpsCsv = fopen(strcat('../outputs/', DATA_SOURCE, '_', NOISE_TYPE, 'CpS.csv'), 'w');

%   Prepares the files to receive the data.
fileStream = strcat( ...
    'IMAGE NAME', CSV_SEPARATOR, ...
    'BRISK (L)', CSV_SEPARATOR, 'BRISK (R)', CSV_SEPARATOR, ...
    'FAST (L)', CSV_SEPARATOR, 'FAST (R)', CSV_SEPARATOR, ...
    'HARRIS (L)', CSV_SEPARATOR, 'HARRIS (R)', CSV_SEPARATOR, ...
    'MIN8VAL (L)', CSV_SEPARATOR, 'MIN8VAL (R)', CSV_SEPARATOR, ...
    'MSER (L)', CSV_SEPARATOR, 'MSER (R)', CSV_SEPARATOR, ...
    'SURF (L)', CSV_SEPARATOR, 'SURF (R)', CSV_SEPARATOR, ...
    '\n' ...
);
fprintf(cornCsv, fileStream);

fileStream = strcat( ...
    'IMAGE NAME', CSV_SEPARATOR, ...
    'BRISK', CSV_SEPARATOR, ...
    'FAST', CSV_SEPARATOR, ...
    'HARRIS', CSV_SEPARATOR, ...
    'MIN8VAL', CSV_SEPARATOR, ...
    'MSER', CSV_SEPARATOR, ...
    'SURF', CSV_SEPARATOR, ...
    '\n' ...
);
fprintf(matcCsv, fileStream);

fileStream = strcat( ...
    'IMAGE NAME', CSV_SEPARATOR, ...
    'BRISK (%%)', CSV_SEPARATOR, ...
    'FAST (%%)', CSV_SEPARATOR, ...
    'HARRIS (%%)', CSV_SEPARATOR, ...
    'MIN8VAL (%%)', CSV_SEPARATOR, ...
    'MSER (%%)', CSV_SEPARATOR, ...
    'SURF (%%)', CSV_SEPARATOR, ...
    '\n' ...
);
fprintf(rateCsv, fileStream);

fileStream = strcat( ...
    'IMAGE NAME', CSV_SEPARATOR, ...
    'BRISK (s)', CSV_SEPARATOR, ...
    'FAST (s)', CSV_SEPARATOR, ...
    'HARRIS (s)', CSV_SEPARATOR, ...
    'MIN8VAL (s)', CSV_SEPARATOR, ...
    'MSER (s)', CSV_SEPARATOR, ...
    'SURF (s)', CSV_SEPARATOR, ...
    '\n' ...
);
fprintf(timeCsv, fileStream);

fileStream = strcat( ...
    'IMAGE NAME', CSV_SEPARATOR, ...
    'BRISK (matches/s)', CSV_SEPARATOR, ...
    'FAST (matches/s)', CSV_SEPARATOR, ...
    'HARRIS (matches/s)', CSV_SEPARATOR, ...
    'MIN8VAL (matches/s)', CSV_SEPARATOR, ...
    'MSER (matches/s)', CSV_SEPARATOR, ...
    'SURF (matches/s)', CSV_SEPARATOR, ...
    '\n' ...
);
fprintf(crpsCsv, fileStream);

% ================= CALCULATING THE CORNERS AND MATCHES ===================

%   First, loads the image list...
imgList = dir(strcat('../dataset/', DATA_SOURCE));

imgList = imgList(3:end,:);
numImgs = size(imgList);

%   ...and loads the values for the statistic evaluation.
lCorners = zeros(numImgs(1), 6);
rCorners = zeros(numImgs(1), 6);
allMtchs = zeros(numImgs(1), 6);
allRates = zeros(numImgs(1), 6);
allTimes = zeros(numImgs(1), 6);
allCrPrS = zeros(numImgs(1), 6);

for i = 1 : numImgs
       
    %   Then, loads the stereo pair...
    [lImg, rImg] = loadPair(DATA_SOURCE, FILE_FORMAT, imgList(i).name);
    
    %   ...applies noise if needed...
    [lImg, rImg] = applyNoiseIfNeeded(lImg, rImg, NOISE_TYPE);
    
    %   ...writes the name of stereo pair on each CSV...
    fprintf(cornCsv, strcat('%12s', CSV_SEPARATOR), imgList(i).name);
    fprintf(matcCsv, strcat('%12s', CSV_SEPARATOR), imgList(i).name);
    fprintf(rateCsv, strcat('%12s', CSV_SEPARATOR), imgList(i).name);
    fprintf(timeCsv, strcat('%12s', CSV_SEPARATOR), imgList(i).name);
    fprintf(crpsCsv, strcat('%12s', CSV_SEPARATOR), imgList(i).name);
    
    %   ...converts the stereo pair to a grayscale if needed...
    if size(lImg, 3) == 3 
        lImg = rgb2gray(lImg);
        rImg = rgb2gray(rImg);
    end
    
    %   ...detects features using all the choosen corner detectors...
    [lBrisk, rBrisk, tBrisk]     = getFeatures(lImg, rImg, 'BRISK'  );
    [lFast, rFast, tFast]        = getFeatures(lImg, rImg, 'FAST'   );
    [lHarris, rHarris, tHarris]  = getFeatures(lImg, rImg, 'Harris' );
    [lMinVal, rMinVal, tMinVal]  = getFeatures(lImg, rImg, 'Min8Val');
    [lMser, rMser, tMser]        = getFeatures(lImg, rImg, 'MSER'   );
    [lSurf, rSurf, tSurf]        = getFeatures(lImg, rImg, 'SURF'   );
           
    %   ...and writes the obtained values in the first CSV file.
    fprintf(cornCsv, strcat('%d', CSV_SEPARATOR), length(lBrisk));
    fprintf(cornCsv, strcat('%d', CSV_SEPARATOR), length(rBrisk));
    fprintf(cornCsv, strcat('%d', CSV_SEPARATOR), length(lFast));
    fprintf(cornCsv, strcat('%d', CSV_SEPARATOR), length(rFast));
    fprintf(cornCsv, strcat('%d', CSV_SEPARATOR), length(lHarris));    
    fprintf(cornCsv, strcat('%d', CSV_SEPARATOR), length(rHarris));    
    fprintf(cornCsv, strcat('%d', CSV_SEPARATOR), length(lMinVal));
    fprintf(cornCsv, strcat('%d', CSV_SEPARATOR), length(rMinVal));
    fprintf(cornCsv, strcat('%d', CSV_SEPARATOR), length(lMser));    
    fprintf(cornCsv, strcat('%d', CSV_SEPARATOR), length(rMser));
    fprintf(cornCsv, strcat('%d', CSV_SEPARATOR), length(lSurf));    
    fprintf(cornCsv, strcat('%d', CSV_SEPARATOR), length(rSurf));
    
    %   Then, calculate the number of unique matches for each image...
    mBrisk  = matchNumber(lImg, rImg, lBrisk , rBrisk );
    mFast   = matchNumber(lImg, rImg, lFast  , rFast  );
    mHarris = matchNumber(lImg, rImg, lHarris, rHarris);
    mMinVal = matchNumber(lImg, rImg, lMinVal, rMinVal);
    mMser   = matchNumber(lImg, rImg, lMser  , rMser  );
    mSurf   = matchNumber(lImg, rImg, lSurf  , rSurf  );
        
    %   ...and writes the obtained values in the second CSV file.
    fprintf(matcCsv, strcat('%d', CSV_SEPARATOR), length(mBrisk) );
    fprintf(matcCsv, strcat('%d', CSV_SEPARATOR), length(mFast)  );
    fprintf(matcCsv, strcat('%d', CSV_SEPARATOR), length(mHarris));
    fprintf(matcCsv, strcat('%d', CSV_SEPARATOR), length(mMinVal));
    fprintf(matcCsv, strcat('%d', CSV_SEPARATOR), length(mMser)  );
    fprintf(matcCsv, strcat('%d', CSV_SEPARATOR), length(mSurf)   );
    
    %   Then, calculate the match rate (%%) for each image...    
    mrBrisk  = matchRate(mBrisk , lBrisk , rBrisk );
    mrFast   = matchRate(mFast  , lFast  , rFast  );
    mrHarris = matchRate(mHarris, lHarris, rHarris);
    mrMinVal = matchRate(mMinVal, lMinVal, rMinVal);
    mrMser   = matchRate(mMser  , lMser  , rMser  );
    mrSurf   = matchRate(mSurf  , lSurf  , rSurf  );
        
    %   ...and writes the obtained rates in the third CSV file.    
    fprintf(rateCsv, strcat('%1.2f', CSV_SEPARATOR), mrBrisk );
    fprintf(rateCsv, strcat('%1.2f', CSV_SEPARATOR), mrFast  );
    fprintf(rateCsv, strcat('%1.2f', CSV_SEPARATOR), mrHarris);
    fprintf(rateCsv, strcat('%1.2f', CSV_SEPARATOR), mrMinVal);
    fprintf(rateCsv, strcat('%1.2f', CSV_SEPARATOR), mrMser  );
    fprintf(rateCsv, strcat('%1.2f', CSV_SEPARATOR), mrSurf  );
    
    %   The, writes the time spent finding corners in the forth file...
    fprintf(timeCsv, strcat('%1.3f', CSV_SEPARATOR), tBrisk );
    fprintf(timeCsv, strcat('%1.3f', CSV_SEPARATOR), tFast  );
    fprintf(timeCsv, strcat('%1.3f', CSV_SEPARATOR), tHarris);
    fprintf(timeCsv, strcat('%1.3f', CSV_SEPARATOR), tMinVal);
    fprintf(timeCsv, strcat('%1.3f', CSV_SEPARATOR), tMser  );
    fprintf(timeCsv, strcat('%1.3f', CSV_SEPARATOR), tSurf  );
    
    %   ...and the corners per second ratio in the last file.
    fprintf(crpsCsv, strcat('%.2f', CSV_SEPARATOR), ...
           round((length(lBrisk) + length(rBrisk))   / tBrisk ));
    fprintf(crpsCsv, strcat('%.2f', CSV_SEPARATOR), ...
           round((length(lFast) + length(rFast))     / tFast  ));
    fprintf(crpsCsv, strcat('%.2f', CSV_SEPARATOR), ...
           round((length(lHarris) + length(rHarris)) / tHarris));
    fprintf(crpsCsv, strcat('%.2f', CSV_SEPARATOR), ...
           round((length(lMinVal) + length(rMinVal)) / tMinVal));
    fprintf(crpsCsv, strcat('%.2f', CSV_SEPARATOR), ...
           round((length(lMser) + length(rMser))     / tMser  ));
    fprintf(crpsCsv, strcat('%.2f', CSV_SEPARATOR), ...
           round((length(lSurf) + length(rSurf))     / tSurf  ));
       
    %   Finally, finishes the file edit...
    fprintf(cornCsv, '\n');
    fprintf(matcCsv, '\n');
    fprintf(rateCsv, '\n');
    fprintf(timeCsv, '\n');
    fprintf(crpsCsv, '\n');
    
    %   ...and updates the needed values for post-calculation, if needs.
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

%   Writes the average of each set of values...
fprintf(cornCsv, '\n');
fprintf(matcCsv, '\n');
fprintf(rateCsv, '\n');
fprintf(timeCsv, '\n');
fprintf(crpsCsv, '\n');

fprintf(cornCsv, strcat('%12s', CSV_SEPARATOR), "AVRG");
fprintf(matcCsv, strcat('%12s', CSV_SEPARATOR), "AVRG");
fprintf(rateCsv, strcat('%12s', CSV_SEPARATOR), "AVRG");
fprintf(timeCsv, strcat('%12s', CSV_SEPARATOR), "AVRG");
fprintf(crpsCsv, strcat('%12s', CSV_SEPARATOR), "AVRG");

for i = 1:6
    fprintf(cornCsv, strcat('%1.2f', CSV_SEPARATOR), mean(lCorners(:,i)));
    fprintf(cornCsv, strcat('%1.2f', CSV_SEPARATOR), mean(rCorners(:,i)));
    fprintf(matcCsv, strcat('%1.2f', CSV_SEPARATOR), mean(allMtchs(:,i)));
    fprintf(rateCsv, strcat('%1.2f', CSV_SEPARATOR), mean(allRates(:,i)));
    fprintf(timeCsv, strcat('%1.3f', CSV_SEPARATOR), mean(allTimes(:,i)));
    fprintf(crpsCsv, strcat('%1.2f', CSV_SEPARATOR), mean(allCrPrS(:,i)));
end

%   ... and the standart deviation.
fprintf(cornCsv, '\n');
fprintf(matcCsv, '\n');
fprintf(rateCsv, '\n');
fprintf(timeCsv, '\n');
fprintf(crpsCsv, '\n');

fprintf(cornCsv, strcat('%12s', CSV_SEPARATOR), "STD_DER");
fprintf(matcCsv, strcat('%12s', CSV_SEPARATOR), "STD_DER");
fprintf(rateCsv, strcat('%12s', CSV_SEPARATOR), "STD_DER");
fprintf(timeCsv, strcat('%12s', CSV_SEPARATOR), "STD_DER");
fprintf(crpsCsv, strcat('%12s', CSV_SEPARATOR), "STD_DER");

for i = 1:6
    fprintf(cornCsv, strcat('%1.2f', CSV_SEPARATOR), std(lCorners(:,i)));
    fprintf(cornCsv, strcat('%1.2f', CSV_SEPARATOR), std(rCorners(:,i)));
    fprintf(matcCsv, strcat('%1.2f', CSV_SEPARATOR), std(allMtchs(:,i)));
    fprintf(rateCsv, strcat('%1.2f', CSV_SEPARATOR), std(allRates(:,i)));
    fprintf(timeCsv, strcat('%1.3f', CSV_SEPARATOR), std(allTimes(:,i)));
    fprintf(crpsCsv, strcat('%1.2f', CSV_SEPARATOR), std(allCrPrS(:,i)));
end

%   At the end, closes all the CSV files...
fclose(cornCsv);
fclose(matcCsv);
fclose(rateCsv);
fclose(timeCsv);
fclose(crpsCsv);

%   ...and displays a success message.
disp(strcat(NOISE_TYPE, ' tests were performed successfully.'));

% Ends the script.
end