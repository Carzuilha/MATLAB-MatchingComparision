%==========================================================================
%                             MAIN SCRIPT
% 
%   This is the mains script of the project. It is necessary a webcam pair 
% or a stereo image pair previously captured to make this script works.
%==========================================================================

function compareCornerDetectors

% ========================= CHOOSING DATABASE =============================

%DATABASE_NAME = 'Middlebury';
DATABASE_NAME = 'Minoru3D';

DATABASE_TYPE = 'png';
%DATABASE_TYPE = 'jpg';


%  ================== GENERATING CORNERS AND MATCHES =======================

% Create CSV files for the corners, the matches and the rates -------------

csvCorn = fopen(strcat(DATABASE_NAME, '_Corners.csv'), 'w');
csvMatc = fopen(strcat(DATABASE_NAME, '_Matches.csv'), 'w');
csvRate = fopen(strcat(DATABASE_NAME, '_Rates.csv'), 'w');

% Writes the header of the table in each file -----------------------------

fprintf(csvCorn, 'IMAGE NAME,');
fprintf(csvCorn, 'BRISK (Left), BRISK (Right),');
fprintf(csvCorn, 'FAST (Left), FAST (Right),');
fprintf(csvCorn, 'HARRIS (Left), HARRIS (Right),');
fprintf(csvCorn, 'MIN8VAL (Left), MIN8VAL (Right),');
fprintf(csvCorn, 'SURF (Left), SURF (Right),');
fprintf(csvCorn, 'MSER (Left), MSER (Right)');
fprintf(csvCorn, '\n');

fprintf(csvMatc, 'IMAGE NAME,');
fprintf(csvMatc, 'BRISK,FAST,HARRIS,MIN8VAL,SURF,MSER\n');

fprintf(csvRate, 'IMAGE NAME,');
fprintf(csvRate, 'BRISK (%%),FAST (%%),HARRIS (%%),');
fprintf(csvRate, 'MIN8VAL (%%), SURF (%%) ,MSER (%%)\n');

%   Calculates the corners, matches and match rate for each image ---------

imgList = dir(strcat('dataset/', DATABASE_NAME));

for i = 3:size(imgList)
       
    % Load the stereo pair...
    imgName = imgList(i).name;    
    lImg = imread(strcat('dataset/', DATABASE_NAME, '/', imgName, '/im0.', DATABASE_TYPE));
    rImg = imread(strcat('dataset/', DATABASE_NAME, '/', imgName, '/im1.', DATABASE_TYPE));
    
    % ...writes the name of stereo pair on each CSV...
    fprintf(csvCorn, '%12s,' , imgName);
    fprintf(csvMatc, '%12s,' , imgName);
    fprintf(csvRate, '%12s,' , imgName);
    
    % ...converts the stereo pair to a grayscale if needed...
    if size(lImg, 3) == 3 
        lImg = rgb2gray(lImg);
        rImg = rgb2gray(rImg);
    end
    
    % ...detects features using all the choosen corner detectors...
    briskL = detectBRISKFeatures(lImg);
    briskR = detectBRISKFeatures(rImg);
    
    fastL = detectFASTFeatures(lImg);
    fastR = detectFASTFeatures(rImg);
    
    harrisL = detectHarrisFeatures(lImg);
    harrisR = detectHarrisFeatures(rImg);
    
    minvalL = detectMinEigenFeatures(lImg);
    minvalR = detectMinEigenFeatures(rImg);
    
    surfL = detectSURFFeatures(lImg);
    surfR = detectSURFFeatures(rImg);
    
    mserL = detectMSERFeatures(lImg);
    mserR = detectMSERFeatures(rImg);
       
    % ...and writes the obtained values in the first CSV file.
    fprintf(csvCorn, '%d,%d,', length(briskL) , length(briskR) );
    fprintf(csvCorn, '%d,%d,', length(fastL)  , length(fastR)  );
    fprintf(csvCorn, '%d,%d,', length(harrisL), length(harrisR));
    fprintf(csvCorn, '%d,%d,', length(minvalL), length(minvalR));
    fprintf(csvCorn, '%d,%d,', length(surfL)  , length(surfR)  );
    fprintf(csvCorn, '%d,%d' , length(mserL)  , length(mserR)  );
    fprintf(csvCorn, '\n');
    
    %   Then, calculate the number of unique matches for each image, writing
    % on the second CSV file...
    [briskFeatL, briskVldPts] = extractFeatures(lImg, briskL);
    [briskFeatR, ~          ] = extractFeatures(lImg, briskR);        
    briskNumM = matchFeatures(briskFeatL, briskFeatR);
    briskM = briskVldPts(briskNumM(:,1),:);
        
    [fastFeatL, fastVldPts] = extractFeatures(lImg, fastL);
    [fastFeatR, ~         ] = extractFeatures(lImg, fastR);    
    fastNumM = matchFeatures(fastFeatL, fastFeatR);
    fastM = fastVldPts(fastNumM(:,1),:);
    
    [harrisFeatL, harrisVldPts] = extractFeatures(lImg, harrisL);
    [harrisFeatR, ~           ] = extractFeatures(lImg, harrisR);
    harrisNumM = matchFeatures(harrisFeatL, harrisFeatR);
    harrisM = harrisVldPts(harrisNumM(:,1),:);
    
    [minvalFeatL, minvalVldPts] = extractFeatures(lImg, minvalL);
    [minvalFeatR, ~            ] = extractFeatures(lImg, minvalR);    
    minvalNumM = matchFeatures(minvalFeatL, minvalFeatR);
    minvalM = minvalVldPts(minvalNumM(:,1),:);
    
    [surfFeatL, surfVldPts] = extractFeatures(lImg, surfL);
    [surfFeatR, ~         ] = extractFeatures(lImg, surfR);    
    surfNumM = matchFeatures(surfFeatL, surfFeatR);
    surfM = surfVldPts(surfNumM(:,1),:);
        
    [mserFeatL, mserVldPts] = extractFeatures(lImg, mserL);
    [mserFeatR, ~         ] = extractFeatures(lImg, mserR);    
    mserNumM = matchFeatures(mserFeatL, mserFeatR);
    mserM = mserVldPts(mserNumM(:,1),:); 
    
    % ...and writes the obtained values in the second CSV file.
    fprintf(csvMatc, '%d,', length(briskM));
    fprintf(csvMatc, '%d,', length(fastM));
    fprintf(csvMatc, '%d,', length(harrisM));
    fprintf(csvMatc, '%d,', length(minvalM));
    fprintf(csvMatc, '%d,', length(surfM));
    fprintf(csvMatc, '%d' , length(mserM));
    fprintf(csvMatc, '\n');
    
    % Finally, calculate the match rate (%%) for each image...
    
    briskR  = (length(briskM) / ((length(briskL) + length(briskR)) / 2)) * 100;
    fastR   = (length(fastM) / ((length(fastL) + length(fastR)) / 2)) * 100;
    harrisR = (length(harrisM) / ((length(harrisL) + length(harrisR)) / 2)) * 100;
    minvalR = (length(minvalM) / ((length(minvalL) + length(minvalR)) / 2)) * 100;
    surfR   = (length(surfM) / ((length(surfL) + length(surfR)) / 2)) * 100;
    mserR   = (length(mserM) / ((length(mserL) + length(mserR)) / 2)) * 100;
    
    % ...and writes the obtained rates in the third CSV file.
    
    fprintf(csvRate, '%.2f,', briskR);
    fprintf(csvRate, '%.2f,', fastR);
    fprintf(csvRate, '%.2f,', harrisR);
    fprintf(csvRate, '%.2f,', minvalR);
    fprintf(csvRate, '%.2f,', surfR);
    fprintf(csvRate, '%.2f' , mserR);
    fprintf(csvRate, '\n');
    
end

% Closes all the CSV files ------------------------------------------------
fclose(csvCorn);
fclose(csvMatc);
fclose(csvRate);

% End of the script.
end