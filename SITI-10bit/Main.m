% Main matlabl script to call the SI TI calculation function, SITI_10bit for 8-bit YUV, 4:2:0 chroma-subsampling videos.
% #################################### Input  ###########################
% Calling this script will calculate the SI TI vals for all .yuv videos of a particular resolution in
% the same folder. However, the script could be modified to include videos for different resolutions. 
% There is support for both Full Range YUV as well as Limited Range YUV (in 10-bit Limited Range YUV files, pixel values
% are in the range from 64-940).
%##################################### Output ############################
    % The output results are stored in the SITIVals.csv file.
    % Only the Luminance (Y) component is taken into account for SI TI calculation
    % The .mat files are saved in the current directory which can be used
    % later for per-frame SI TI calculations and other analysis.
%########################################################################
% Author: Nabajeet Barman, Kingston University, London.
% Email:  n.barman@ieee.org; nabajeetbarman4@gmail.com
%########################################################################

clear
close all
%clc
fns = dir('*.yuv'); % assumes YUV videos to be present in the same directory as this script

% Assuming a video of 4096x2160 resolution

video_height = 2160; 
video_width = 3840;
% Full Range or Limited Range, default is Limited Range
Range = 0; % 0 --> Limited Range, 1 -- Full Range (default)
out_fid = fopen( 'SITIVals2.csv', 'w' );
fprintf( out_fid, '%s, %s, %s, %s\n', 'Sequence Name', 'SI', 'TI', 'DR');

for i = 1:length(fns)
    fid = fopen(append('',fns(i).name));
    current_file = fns(i).name;
    first_splits = split(current_file, 'x'); % Part I: Two arrays 
    height_splits = split(first_splits{1},'_'); % Part I: Split by '_'
                                                % last_elem has height val.
    width_splits = split(first_splits{2},'_'); % Part I: Split by '_'
                                                % last_elem has width val.

    video_height = str2double(cell2mat(height_splits(end))); %PartII: Parse
    video_width = str2double(cell2mat(width_splits(1))); %PartII: Parse
    disp(video_width);
    tic;
    [SI, TI, DR] = SITI_10bit(append('',fns(i).name),video_height,video_width, Range);
    toc;
    fprintf( out_fid, '%s,%d, %d, %d\n', fns(i).name, SI, TI, DR);
    fclose(fid);
end