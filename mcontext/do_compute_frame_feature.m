%(C) Du Tran dutran2@uiuc.edu 2008
function do_compute_frame_feature(frm_dir, bkg_dir, flow_dir, box_dir, file_ext, tmp_dir)
txt_files = dir([box_dir '*.txt']);
scale = 120;
ki = 2;
N = 18;
angel_matrix = compute_angle_matrix([scale/ki scale/ki],N);
num = 0;
f = [];
s = [];
for j=1:size(txt_files,1) 
    box_file = sprintf('%s%s', box_dir, txt_files(j).name);
    mov_num = txt_files(j).name;
    mov_num = mov_num(1:size(mov_num,2)-4);
    frms = dir([sprintf('%s%s/',frm_dir,mov_num) file_ext]);
    bkgs = dir([sprintf('%s%s/',bkg_dir,mov_num) file_ext]);
    boxs = load(box_file);
    dir_v = sprintf('%sv/%s/',flow_dir,mov_num);
    dir_u = sprintf('%su/%s/',flow_dir,mov_num);
    for k=2:size(boxs,1)
        frm_name = frms(k).name;
        frm_name = frm_name(1:size(frm_name,2)-4);
        fn = sprintf('%s%s.mat', dir_v, frm_name);
        load(fn, 'v0');
        fn = sprintf('%s%s.mat', dir_u, frm_name);
        load(fn, 'u0');
        fn = sprintf('%s%s/%s%s', bkg_dir, mov_num, bkgs(k).name);
        bk = imread(fn);
        v0 = medfilt2(v0, [5 5]);
        u0 = medfilt2(u0, [5 5]);
        [flow sil] = compute_combination_feature(v0, u0, bk, boxs(k,1:4), angel_matrix, ki, scale);
        num = num + 1;
        f = [f; flow];
        s = [s; sil];
        l(num) = cellstr(fn);
    end
end
du_mkdir(tmp_dir);
fn = sprintf('%sflow_feature.mat',tmp_dir);
save(fn,'f');
fn = sprintf('%ssil_feature.mat',tmp_dir);
save(fn,'s');
fn = sprintf('%slist.mat',tmp_dir);
save(fn,'l');