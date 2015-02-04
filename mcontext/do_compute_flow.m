%(C) Du Tran dutran2@uiuc.edu 2008
function do_compute_flow(frm_dir, flow_dir, file_ext)
dir_u = sprintf('%su/',flow_dir);
du_mkdir(dir_u);
dir_v = sprintf('%sv/',flow_dir);
du_mkdir(dir_v);
dirs = dir(frm_dir);
for i=3:size(dirs,1)
    cur_frm_dir = sprintf('%s%s/',frm_dir,dirs(i).name);
    cur_u_dir = sprintf('%s%s/',dir_u,dirs(i).name);
    cur_v_dir = sprintf('%s%s/',dir_v,dirs(i).name);
    du_mkdir(cur_u_dir);
    du_mkdir(cur_v_dir);
    img_files = dir([cur_frm_dir file_ext]);
    if size(img_files,1) == 0
        continue;
    end
    im1 = imread(sprintf('%s%s',cur_frm_dir,img_files(1).name));
    im1 = rgb2gray(im1); %first frame
    for j=2:size(img_files,1)
        fn = img_files(j).name;
        fn = fn(1:size(fn,2)-4);
        v_mat = sprintf('%s%s.mat', cur_v_dir, fn);
        u_mat = sprintf('%s%s.mat', cur_u_dir, fn);
        if exist(u_mat,'file')&&exist(v_mat,'file')
            continue;
        end
        im2 = imread(sprintf('%s%s',cur_frm_dir,img_files(j).name));
        im2 = rgb2gray(im2);
        [u0,v0] = HierarchicalLK(im1, im2, 1, 3, 1, 0);
        save(v_mat,'v0');
        save(u_mat,'u0');
        im1 = im2;
    end
end