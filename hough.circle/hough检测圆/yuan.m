
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��hough�任�԰뾶δ֪��Բ���м��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;clc;        %����
I = imread('tupian.jpg'); %����ͼ��
figure;
imshow(I); 
I =im2bw(I);                    %��ͼ���ֵ��
[y,x]=find(I);                   %�ҳ�I�з���Ԫ�ص�λ��
[sy,sx]=size(I);   
figure;%�ҳ�I���к��еĴ�С����ֵ��sy��sx
imshow(I);                     %��ʾI
totalpix = length(x);   
HM = zeros(sy,sx,50);
R = 1:50;
R2 = R.^2;
sz = sy*sx;                                       %����I������Ԫ�ص��ܺ�
tic;%��ʱ
for cnt = 1:totalpix
for cntR = 1:50
b = 1:sy;
a = (round(x(cnt) - sqrt(R2(cntR) - (y(cnt) - [1:sy]).^2)));    %a=x-genhao(r^2-(y-b)^2);
b = b(imag(a)==0 & a>0);                              %�������������imag(a)==0 & a>0����һϵ�е�a,bֵ
a = a(imag(a)==0 & a>0);
ind = sub2ind([sy,sx],b,a);                           %�������[sy,sx]�е�Բ��[b,a]�ĵ��±ꡣ
HM(sz*(cntR-1)+ind) = HM(sz*(cntR-1)+ind) + 1;        %�����������ĵ㣨a��b�����ۼ�����1.
end
end
for cnt = 1:50                        
H(cnt) = max(max(HM(:,:,cnt)));
end
plot(H,'*-');
[maxval, maxind] = max(H);           %����H�е����ֵmaxval(��Ϊmax value)������maxind(��Ϊ���ֵ����һ��)
[B,A] = find(HM(:,:,maxind)==maxval);%�ҵ����ֵ�ĺ������꣬��Բ�ġ�
toc;
imshow(I);
hold on;                            %��ʾI��
plot(mean(A),mean(B),'xr')          %mean(A)(��A��ƽ��),mean(B)(��B��ƽ��)�����xr��
text(mean(A),mean(B),num2str(maxind),'color','green')

