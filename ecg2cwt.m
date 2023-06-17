% Function Comment:
% This MATLAB function takes ECG data and a CWT filter bank object as 
% inputs and generates a set of CWT images for each ECG signal.

% Input Parameters:
% - ecgdata: The input ECG data, represented as a matrix where each row
%   corresponds to a different ECG signal.
% - cwtfb: The CWT filter bank object used for the wavelet transform.

% Output:
% - cwtImages: A cell array that stores the generated CWT images for each 
%   ECG signal.

function cwtImages = ecg2cwt(ecgdata, cwtfb)
    nos = 10;  % number of signals
    signallength = 500; % signal length
    colormap = jet(128);
    cwtImages = cell(30 * nos, 1); % Cell array to store the CWT images

    findx = 0;
    for i = 1:30
        indx = 0;
        for k = 1:nos
            ecgsignal = ecgdata(i, indx+1: indx+signallength);
            cfs = abs(cwtfb.wt(ecgsignal));
            im = ind2rgb(im2uint8(rescale(cfs)), colormap);
            cwtImages{findx + k} = imresize(im, [227 227]);
            %227 for AlexNet and Squeezenet  
            %224 for googlenet
            indx = indx + signallength;
        end
        findx = findx + nos;
    end
end

% Code Explanation:
% 1. The number of signals, 'nos', is set to 10, indicating the number of
%    ECG signals being processed.
% 2. The signal length, 'signallength', is set to 500, specifying the length of each ECG signal.
% 3. The 'colormap' is initialized using the 'jet' colormap with 128 colors.
% 4. A cell array, 'cwtImages', is created to store the generated CWT images. 
%    It has a length of 30 times the number of signals.
% 5. Two loop variables, 'findx' and 'indx', are initialized to keep track of indices 
%    while iterating through the signals and generating CWT images.
% 6. The outer loop iterates 30 times, representing a set of ECG signals.
% 7. The inner loop iterates 'nos' times, processing each ECG signal within the current set.
% 8. The ECG signal corresponding to the current iteration is extracted from 'ecgdata'.
% 9. The wavelet transform is applied to the ECG signal using the 'wt' method of the CWT filter 
%    bank object, resulting in the complex CWT coefficients.
% 10. The absolute values of the CWT coefficients are computed using 'abs'.
% 11. The CWT coefficients are rescaled and converted to 8-bit intensity values using 'rescale' 
%     and 'im2uint8' functions.
% 12. The rescaled CWT coefficients are converted to an RGB image using the 'ind2rgb' function and 
%     the predefined 'colormap'.
% 13. The resulting image is resized to a fixed size of 227x227 pixels, suitable for models like AlexNet
%     and SqueezeNet.
% 14. The resized image is stored in the 'cwtImages' cell array at the appropriate index.
% 15. The 'indx' variable is updated to keep track of the next ECG signal within the current set.
% 16. The 'findx' variable is updated to keep track of the next available index in 'cwtImages' for the next 
%     set of ECG signals.
% 17. The process continues until all sets of ECG signals have been processed.

% Note:
% - The image size (227x227) mentioned in the comment corresponds to the input size required by models 
%   like AlexNet and SqueezeNet. For GoogleNet, the size is 224x224.
% - This function provides a convenient way to convert ECG signals into CWT images for further analysis 
%   or input to deep learning models.