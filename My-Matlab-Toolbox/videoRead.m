clear all
close all
clc
%������Ƶ��ת��ΪͼƬ��
mov=VideoReader('F:\\2.avi');     %������Ƶ�ļ�
for i=1:100%mov.numberofframes       %�����֡���������ζ�ȡ
b=read(mov,i);
imwrite(b,strcat('m',int2str(i),'.jpg'),'bmp');   %�ѵ�i֡��ͼƬдΪ'mi.bmp'
end
clear all
close all
clc
I=imread('m88.jpg');%��ȡͼƬ��
% size(I)
imshow(I)
%ͼƬ�ֿ飻
rs = size(I, 1); cs = size(I, 2);
sz = 64;
numr = rs/sz;
numc = cs/sz;
ch = sz; cw = sz;
t1 = (0:numr-1)*ch + 1; t2 = (1:numr)*ch;
t3 = (0:numc-1)*cw + 1; t4 = (1:numc)*cw;
figure; 
k = 0;
for i = 1 : numr
    for j = 1 : numc        
        temp = I(t1(i):t2(i), t3(j):t4(j), :); %64*64 sub pic,every channel
        k = k + 1;
        subplot(numr, numc, k);
        imshow(temp);
        pause(0.5);
    end
end
