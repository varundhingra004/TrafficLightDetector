function traffic_light(  )
%Detecting traffic lights using structural information and Hough transforms

input_image_RGB = imread('dataset/simple_green.JPEG');
input_image_RGB = im2double(input_image_RGB);
imshow(input_image_RGB)

%Noise cleaning

input_image_RGB = imgaussfilt(input_image_RGB,2);

[normalized_red, normalized_green, normalized_blue, normalized_rgb] = normalized_RGB(input_image_RGB);


imshow(normalized_rgb);
size_of_normalized_image = size(input_image_RGB);
nrows = size_of_normalized_image(1);
ncols = size_of_normalized_image(2);

%{
normalized_rgb = reshape(input_image_RGB,nrows , ncols, 3);
[idx,C] = kmeans(normalized_rgb(:), 5, 'Replicates',5, 'MaxIter', 100,'distance','cityblock');

B = reshape(idx, nrows, ncols, 3);
imshow(B,[])

%}

pixel_clustering(normalized_rgb, input_image_RGB);
%{
input_image_HSV = rgb2hsv(input_image_RGB);
input_image_saturation_channel = input_image_HSV(:,:,2); 
imshow(input_image_saturation_channel);

% input_image_saturation_channel = imsharpen(input_image_saturation_channel);
% imshow(input_image_saturation_channel);

edges_input_image = edge(input_image_saturation_channel, 'canny', 0.19);
imshow(edges_input_image);
%}

end


function [normalized_red, normalized_green, normalized_blue, normalized_rgb] = normalized_RGB(input_rgb)

red_channel = input_rgb(:,:,1);
green_channel = input_rgb(:,:,2);
blue_channel = input_rgb(:,:,3);



cummulative_sum_of_channels = red_channel + green_channel + blue_channel;



if cummulative_sum_of_channels == 0
    normalized_red = 0;
    normalized_green = 0;
    normalized_blue = 0;
else
    normalized_red = (red_channel ./ cummulative_sum_of_channels);% * 255;
    normalized_green = (green_channel ./ cummulative_sum_of_channels);% * 255;
    normalized_blue = (blue_channel ./ cummulative_sum_of_channels);% * 255;
end

normalized_rgb = input_rgb;
normalized_rgb(:,:,1) = normalized_red;
normalized_rgb(:,:,2) = normalized_green;
normalized_rgb(:,:,3) = normalized_blue;

end

function pixel_clustered_image = pixel_clustering(input_image_RGB_normalized, input_image_RGB)
size_input_image = size(input_image_RGB);
no_of_rows_in_input_image = size_input_image(1);
no_of_cols_in_input_image = size_input_image(2);
red_channel = input_image_RGB(:,:,1);
green_channel = input_image_RGB(:,:,2);
blue_channel = input_image_RGB(:,:,3);

red_channel_normalized = input_image_RGB_normalized(:,:,1);
green_channel_normalized = input_image_RGB_normalized(:,:,2);
blue_channel_normalized = input_image_RGB_normalized(:,:,3);

if size(input_image_RGB_normalized) == size(input_image_RGB)
    pixel_clustered_image = zeros(no_of_rows_in_input_image, no_of_cols_in_input_image);
    
    pixel_clustered_image_red_light_on = (red_channel > 100) & (red_channel_normalized > 0.4) & (green_channel_normalized < 0.3) & (blue_channel_normalized < 0.3);
    pixel_clustered_image_yellow_light_on = (red_channel > 100) & (red_channel_normalized > 0.4) & (green_channel_normalized > 0.3) & (blue_channel_normalized < 0.3);
    pixel_clustered_image_green_light_on = (green_channel + blue_channel > 100) & (red_channel_normalized < 0.3) & (green_channel_normalized > 0.45) & (blue_channel_normalized > 0.45);
    pixel_clustered_image_all_lights_off = (red_channel + green_channel + blue_channel) < 300;
    pixel_clustered_image_not_a_light = (~pixel_clustered_image_red_light_on) & (~pixel_clustered_image_yellow_light_on) & (pixel_clustered_image_green_light_on) & (pixel_clustered_image_all_lights_off);
    
%     imshow(pixel_clustered_image_not_a_light)
    
end


end