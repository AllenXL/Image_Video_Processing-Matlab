%(C) Du Tran dutran2@uiuc.edu 2008
function do_box_localize(bkg_dir,box_dir,file_ext)
du_mkdir(box_dir);
video_bkg_dirs = dir(bkg_dir);
for i=3:size(video_bkg_dirs,1)
    cur_bkg_dir = sprintf('%s%s/',bkg_dir,video_bkg_dirs(i).name);
    box_file = sprintf('%s%s.txt',box_dir,video_bkg_dirs(i).name);
    extract_boxs(cur_bkg_dir, box_file, file_ext);
end