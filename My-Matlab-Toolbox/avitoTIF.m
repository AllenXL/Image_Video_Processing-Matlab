%avi to tif
clear all
close all
clc
%������Ƶ��ת��ΪͼƬ��
aviPath='C:\Documents and Settings\Administrator\����\walk\daria_walk.avi';
mov=VideoReader(aviPath);     %������Ƶ�ļ�
for i=1:10%mov.numberofframes       %�����֡���������ζ�ȡ
b=read(mov,i);
imwrite(b,strcat(int2str(i),'.tif'),'tif');   %�ѵ�i֡��ͼƬдΪ'mi.bmp'
end