%(C) Du Tran dutran2@uiuc.edu 2008
function extract_boxs(dir_in, txt_file, file_ext)
f = fopen(txt_file,'wt');
files = dir([dir_in file_ext]);
for i=1:size(files)
    fn = sprintf('%s%s',dir_in,files(i).name);
    im = imread(fn);
    p = extract_silhouette(im);
    fprintf(f,'%4d%4d%4d%4d\n',p(1),p(2),p(3),p(4));
end;
fclose(f);