%(C) Du Tran dutran2@uiuc.edu 2008
function do_all(dir_in)
% PARAMETERS
% dir_in is a folder which contains
% 1. a sub-folder whose name 'frm'
%     1.1 the folder 'frm' contains k sub-folders containing images
%         - each folder is a video (you have k-video)
% 2. a sub-folder whose name 'bkg'
%     2.1 the folder 'bkg' contains k sub-folders containing 
%         background images of the conressponding videos in 'frm'
% See the folder 'dir' for mo detail

% you may use jpg, bmp, etc.
file_ext = '*.tif'; 

disp('extracting silhouettes...');
do_box_localize('dir/bkg/','dir/box/',file_ext);

disp('computing optical flows...');
do_compute_flow('dir/frm/','dir/flow/',file_ext);

disp('do compute frame features...');
do_compute_frame_feature('dir/frm/', 'dir/bkg/','dir/flow/','dir/box/',file_ext, 'dir/feature/');

disp('do PCA on the features, and compute motion context...');
do_pca_on_frame_feature('dir/feature/');