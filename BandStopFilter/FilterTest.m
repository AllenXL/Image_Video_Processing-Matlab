%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 高斯带阻滤波器
% 滤波器的传递函数为H(u,v)=1-exp(-1/2*((D^2-D0^2)/(D*W))^2)
% 其中W是频带宽度,D0是频带的中心半径
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close all;
% clear all;
% f=imread('SinNoisy.jpg');           %读取图像
% I=rgb2gray(f);                      %将图像变为灰度图象
% I1=BandFilter(I,60,30);         
% I2=BandFilter(I1,103,30);
% I3=BandFilter(I2,150,20);
% figure;
% subplot(1,2,1),imshow(f);title('滤波前');
% subplot(1,2,2),imshow(I3);title('滤波后');

close all;
clear all;
f=imread('arm2.jpg');           %读取图像
I=rgb2gray(f);                      %将图像变为灰度图象
I1=BandFilter(I,20,10);         
% I2=BandFilter(I1,150,30);
% I3=BandFilter(I2,200,20);        

%I3=medfilt2(I,[8,8]);

figure;
imshow(I1);
%subplot(1,2,1),imshow(f);title('滤波前');
%subplot(1,2,2),
%imshow(I3);
% imshow(((I3-I)>10)&((I3-I)<30)&(I>40)&(I<60));title('滤波后');
% figure
% imshow(I3);















