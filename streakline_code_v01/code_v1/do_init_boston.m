pth = 'data/boston_short'
OPTICAL_FLOW_SWITCH =  1; %1 = compute optical flow 0= load optical flow (set the path in the main file)
output_dir = 'results/segmentation_boston';
mkdir(output_dir)
mkdir([output_dir '/Segmentation'])
    
% input images
prefix = 'boston_';
img_fileformat = '%06d.jpg'
img_outputfileformat = '%06d.jpg';
d = dir(sprintf('%s/*.jpg',pth));

% image resize factor for speed up
RESIZE_FACTOR = .5;
% length of streaklines
streak_len = 20;

% for clean segmentation
cleaning_ratio = .1; % set hedges above mean+cleaning_ratio*std to highest, typical range [-.2,.5]
