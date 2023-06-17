% Function Comment:
% This MATLAB function takes ECG data and converts it into Short-Time 
% Fourier Transform (STFT) images using a sliding window approach.

% Input Parameters:
% - data: The input ECG data, represented as a matrix where each row 
%   corresponds to a different ECG signal.
% - windowLength: The length of the window used for computing the STFT.
% - overlapRatio: The ratio of overlap between consecutive windows.
% - Fs: The sampling frequency of the ECG data.

% Output:
% - stftImages: A cell array that stores the generated STFT images.

function stftImages = ecg2stft(data, windowLength, overlapRatio, Fs)
    numSignals = size(data, 1);
    numWindows = ceil(size(data, 2) / windowLength);
    numImages = min(numSignals * numWindows, 300);
    stftImages = cell(numImages, 1);
    
    % Preallocate memory for the colormap
    colormapSize = 128;
    cmap = jet(colormapSize);
    
    % Compute the overlap indices for windowing
    overlapIndices = round(overlapRatio * windowLength);
    
    imageIndex = 1;
    for i = 1:numSignals
        for j = 1:numWindows
            if imageIndex > numImages
                break;  % Exit the loop if the desired number of images is reached
            end
            
            startIndex = (j - 1) * overlapIndices + 1;
            endIndex = min(startIndex + windowLength - 1, size(data, 2));
            x = data(i, startIndex:endIndex);
            
            % Compute STFT
            [~, ~, ~, stft] = spectrogram(x, windowLength, overlapIndices, [], Fs);
            
            % Convert STFT to colored image
            stftMagnitude = abs(stft);
            stftMagnitude = rescale(stftMagnitude);
            stftImage = ind2rgb(uint8(mat2gray(stftMagnitude) * (colormapSize-1) + 1), cmap);
            stftImage = imresize(stftImage, [227 227]);
            
            % Store the colored STFT image
            stftImages{imageIndex} = stftImage;
            
            imageIndex = imageIndex + 1;
        end
    end
end

% Code Explanation:
% 1. The number of signals, 'numSignals', is determined by the number of 
%    rows in the input 'data' matrix.
% 2. The number of windows, 'numWindows', is calculated based on the window 
%    length and the size of the data matrix.
% 3. The number of images to generate, 'numImages', is set as the minimum 
%    between 'numSignals * numWindows' and 300.
% 4. A cell array, 'stftImages', is created to store the generated STFT images. 
%    Its size is determined by 'numImages'.
% 5. Memory is preallocated for the colormap, 'cmap', using the 'jet' colormap 
%    with 'colormapSize' (128) colors.
% 6. The overlap indices for windowing, 'overlapIndices', are computed based on 
%    the overlap ratio and the window length.
% 7. An index variable, 'imageIndex', is initialized to keep track of the generated
%    images.
% 8. The outer loop iterates over the signals in the 'data' matrix.
% 9. The inner loop iterates over the windows within each signal.
% 10. If the desired number of images is reached ('imageIndex' exceeds 'numImages'), 
%     the loop is terminated using 'break'.
% 11. The start and end indices are calculated to extract the windowed portion of the 
%     current signal.
% 12. The windowed portion of the signal, 'x', is obtained.
% 13. The STFT is computed using the 'spectrogram' function, with parameters 'windowLength',
%     'overlapIndices', and 'Fs'.
% 14. The magnitude of the STFT, 'stftMagnitude', is obtained.
% 15. The magnitude values are rescaled to the range [0, 1] using 'rescale'.
% 16. The rescaled magnitude values are converted to an RGB image using 'ind2rgb' and the 
%     'cmap' colormap.
% 17. The resulting image is resized to a fixed size of 227x227 pixels.
% 18. The resized image is stored in the 'stftImages' cell array at the appropriate index.
% 19. The 'imageIndex' variable is incremented.
% 20. The process continues until all signals and windows are processed, or the desired number 
%     of images is reached.

% Note:
% - The image size (227x227) mentioned in the comment corresponds to a specific size suitable 
%   for input to certain deep learning models.
% - This function allows the transformation of ECG signals into STFT images for further 
%   analysis or for input to deep learning models.
