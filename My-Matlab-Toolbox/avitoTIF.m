%avi to tif
clear all
close all
clc
%导入视频，转换为图片；
aviPath='C:\Documents and Settings\Administrator\桌面\walk\daria_walk.avi';
mov=VideoReader(aviPath);     %读入视频文件
for i=1:10%mov.numberofframes       %获得总帧数，并依次读取
b=read(mov,i);
imwrite(b,strcat(int2str(i),'.tif'),'tif');   %把第i帧的图片写为'mi.bmp'
end