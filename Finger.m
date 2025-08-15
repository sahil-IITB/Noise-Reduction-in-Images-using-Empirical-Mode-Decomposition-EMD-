clc;close all;clear all;
%% Step 1: Load the fingerprint image
fingerprint_image = imread('finger.png');  % Load your fingerprint image
if size(fingerprint_image, 3) == 3  % Check if the image is RGB
    fingerprint_image = rgb2gray(fingerprint_image);  % Convert to grayscale if needed
end

%% Step 2: Preprocessing the fingerprint image (contrast enhancement, thresholding, etc.)
fingerprint_image = double(fingerprint_image);  % Convert to double for processing
fingerprint_image = fingerprint_image / max(fingerprint_image(:));  % Normalize the image

%% Step 3: Apply EMD to decompose the fingerprint image
% Flatten the image for EMD (because EMD works on 1D signals)
[imf, res] = emd(fingerprint_image(:));  % Decompose into IMFs
% Reshape the IMFs back to the original image size
imf_images = reshape(imf, [size(fingerprint_image), size(imf, 2)]);

%% Step 4: Visualize the original image and the IMFs
figure;
subplot(2, 1, 1);
imshow(fingerprint_image, []);
title('Original Fingerprint Image');

% Number of IMFs
num_imfs = size(imf_images, 3);

% Dynamically create subplots based on the number of IMFs
subplot_rows = ceil(num_imfs / 3);  % Calculate the number of rows needed
subplot_cols = min(3, num_imfs);    % Max of 3 columns for IMFs
for i = 1:num_imfs
    subplot(subplot_rows, 3, i);  % Adjust subplot grid dynamically
    imshow(imf_images(:, :, i), []);  % Display each IMF
    title(['IMF ' num2str(i)]);
end

%% Step 5: Extract ridge features (typically from higher-frequency IMFs)
% Higher-frequency IMFs represent finer details such as the ridges in the fingerprint
% Here, we will choose the third IMF, which typically contains the ridge pattern

ridge_image = imf_images(:, :, 1);  % Select the IMF that corresponds to ridges

%% Step 6: Check the dynamic range of the IMF and apply adaptive thresholding
min_val = min(ridge_image(:));
max_val = max(ridge_image(:));
fprintf('Ridge IMF min: %f, max: %f\n', min_val, max_val);

% Apply an adaptive threshold based on the dynamic range of the IMF
threshold_value = (max_val - min_val) * 0.3 + min_val;  % 30% of the dynamic range
fprintf('Threshold value set to: %f\n', threshold_value);

% Apply the threshold to enhance ridges
ridge_image(ridge_image < threshold_value) = 0;  % Set values below threshold to zero

%% Step 7: Enhance the ridges using contrast stretching
ridge_image = (ridge_image - min(ridge_image(:))) / (max(ridge_image(:)) - min(ridge_image(:)));  % Normalize to [0, 1]

%% Step 8: Visualize the extracted ridge features
figure;
imshow(ridge_image, []);
title('Enhanced Ridge Features from Fingerprint');

%% Step 9: (Optional) Further processing (e.g., binarization, enhancement)
% If needed, you can apply additional processing like binarization to enhance features
bin_ridge_image = ridge_image > 0.5;  % Binarize the ridge image

%% Step 10: Feature extraction - Minutiae points 
% Detect minutiae points from the binarized ridge image (simple method for illustration)
minutiae_map_bin = bwmorph(bin_ridge_image, 'endpoints');  % Detect endpoints (minutiae)
figure;
imshow(bin_ridge_image, []);
hold on;
[y, x] = find(minutiae_map_bin);  % Get the coordinates of minutiae points
plot(x, y, 'r*');  % Plot minutiae points in red
title('Minutiae Points Detected');

% Detect minutiae points from the binarized ridge image (simple method for illustration)
minutiae_map = bwmorph(fingerprint_image, 'endpoints');  % Detect endpoints (minutiae)
figure;
imshow(fingerprint_image, []);
hold on;
[y, x] = find(minutiae_map);  % Get the coordinates of minutiae points
plot(x, y, 'r*');  % Plot minutiae points in red
title('Minutiae Points Detected');
%% Step 11: Save or use the extracted features
% You can save the processed image or minutiae points for matching or further analysis
save('ridge_features.mat', 'ridge_image');  % Save ridge image for future use
save('minutiae_points.mat', 'x', 'y');  % Save minutiae points
