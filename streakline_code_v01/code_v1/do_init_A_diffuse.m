pth = 'C:/Users/ramin/PhD/Datasets/Crowd/boston4'
OPTICAL_FLOW_SWITCH =  1;
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
cleaning_ratio = .4;
