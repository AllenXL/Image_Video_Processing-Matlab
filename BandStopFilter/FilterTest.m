%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��˹�����˲���
% �˲����Ĵ��ݺ���ΪH(u,v)=1-exp(-1/2*((D^2-D0^2)/(D*W))^2)
% ����W��Ƶ�����,D0��Ƶ�������İ뾶
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close all;
% clear all;
% f=imread('SinNoisy.jpg');           %��ȡͼ��
% I=rgb2gray(f);                      %��ͼ���Ϊ�Ҷ�ͼ��
% I1=BandFilter(I,60,30);         
% I2=BandFilter(I1,103,30);
% I3=BandFilter(I2,150,20);
% figure;
% subplot(1,2,1),imshow(f);title('�˲�ǰ');
% subplot(1,2,2),imshow(I3);title('�˲���');

close all;
clear all;
f=imread('arm2.jpg');           %��ȡͼ��
I=rgb2gray(f);                      %��ͼ���Ϊ�Ҷ�ͼ��
I1=BandFilter(I,20,10);         
% I2=BandFilter(I1,150,30);
% I3=BandFilter(I2,200,20);        

%I3=medfilt2(I,[8,8]);

figure;
imshow(I1);
%subplot(1,2,1),imshow(f);title('�˲�ǰ');
%subplot(1,2,2),
%imshow(I3);
% imshow(((I3-I)>10)&((I3-I)<30)&(I>40)&(I<60));title('�˲���');
% figure
% imshow(I3);















