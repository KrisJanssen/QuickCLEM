function [ localizedPositions ] = localize()
%LOCALIZE Display an 'open file' dialog and perform a localization
%(PALM/STORM/...) analysis.
%   localizedPositions = localize() will perform a localization analysis
%   and return a 2D matrix containing the localized positions. This
%   function is intended mostly as a demonstration and documentation
%   example. Starting from this file it should be easy to include the
%   localization functionality into your own code.
%   
%   localize() wraps around LocalizerMatlab(), which is the external (mex)
%   function that is provided by LocalizerMatlab.mexw32 (or .mexw64). To
%   get a description of this function, simply enter LocalizerMatlab('localize')
%   in the Matlab command line, and a description will be shown in the 
%   resulting error text.
%   
%   localizedPositions is always a 2D matrix. For N emitters this matrix
%   will contain N rows, and a number of columns depends on the selected
%   localization algorithm. The meaning of each columns is as follows
%   (indices start from 0 - add 1 to get the Matlab index):
%     - 2DGauss:
%     0. frame number
%     1. integrated intensity
%     2. standard deviation (width)
%     3. x position
%     4. y position
%     5. background level (offset)
%     6. deviation on the integrated intensity
%     7. deviation on the standard deviation
%     8. deviation on the x position
%     9. deviation on the y position
%     10. deviation on the background
%     11. number of frames in which the emitter is assumed to be present
% 
% 
%     - 2DGaussFixedWidth:
%     0. frame number
%     1. integrated intensity
%     2. x position
%     3. y position
%     4. background level (offset)
%     5. deviation on the integrated intensity
%     6. deviation on the x position
%     7. deviation on the y position
%     8. deviation on the background
%     9. number of frames in which the emitter is assumed to be present
% 
% 
%     - Ellipsoidal2DGauss:
%     0. frame number
%     1. integrated intensity
%     2. standard deviation in x direction
%     3. standard deviation in y direction
%     4. x position
%     5. y position
%     6. correlation between x and y
%     7. background level (offset)
%     8. deviation on the integrated intensity
%     9. deviation on the standard deviation in x direction
%     10. deviation on the standard deviation in y direction
%     11. deviation on the x position
%     12. deviation on the y position
%     13. deviation on the correlation
%     14. deviation on the background
%     15. number of frames in which the emitter is assumed to be present
% 
% 
%     - IterativeMultiplication
%     0. frame number
%     1. width of the Gaussian used in the calculation
%     2. x position
%     3. y position
%     4. number of frames in which the emitter is assumed to be present
% 
% 
%     - Centroid
%     0. frame number
%     1. x position
%     2. y position
%     3. number of frames in which the emitter is assumed to be present
% 
%     - MLEwG
%     0. frame number
%     1. integrated intensity
%     2. standard deviation
%     3. x position
%     4. y position
%     5. background level (offset)
%     6. localization error
%     7. number of frames in which the emitter is assumed to be present

    [fileName,pathName] = uigetfile();
    if isequal(fileName,0)
        return
    end
    filePath = strcat(pathName, fileName);
    
    psfWidth = 3; %in pixels
    pfa = 50;

    localizedPositions = LocalizerMatlab('localize', psfWidth, 'glrt', pfa, '2DGauss', filePath);
end

