function rename_files(path, ext)
if ~exist(path, 'dir')
    disp('path is not exist!');
    return;
end

old_path = pwd;
cd(path);

files=dir(['./',ext]);

for i=2:length(files)
    i
    %old_name=files(i).name;
    %new_name=strcat('pts',old_name);
    %eval(['!rename',' ',old_name,' ',new_name]);
    load(files(i).name);
    pts=pos;
    save(files(i).name, 'pts');
end

cd(old_path);
end

