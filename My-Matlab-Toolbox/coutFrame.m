%cout frame
clear all
close all
clc
%导入视频，转换为图片；
%f=fopen('label.txt','wt');
filePath='F:\行为方面的资料\WeizmannDataset\';
files=dir(filePath);
count=0;
labelnum=1;
aviNum=1;
for i=3:size(files)
    aviPath=sprintf('%s%s\\',filePath,files(i).name);
    aviFiles=dir([aviPath '*.avi']);
   
    for j=1:size(aviFiles)
        aviName=sprintf('%s%s',aviPath,aviFiles(j).name);
        mov=VideoReader(aviName);
        str=sprintf('%s  %d',aviFiles(j).name,mov.numberofframes);
        disp(str);
        count=count+mov.numberofframes-1;
        aviLabel(aviNum)=labelnum;
        aviContFrames(aviNum)=mov.numberofframes-1;
        aviNum=aviNum+1;
    end
    for cnt=1:count
     %fprintf(f,'%d\n',labelnum);
    end
    count=0;
    labelnum=labelnum+1;
end
%fclose(f);
%weizmann_label=load('label.txt');
%save('weizmann_label.mat','weizmann_label');
save('aviLabel.mat','aviLabel');
save('aviContFrames.mat','aviContFrames');
