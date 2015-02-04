
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%用hough变换对半径未知的圆进行检测%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;clc;        %清屏
I = imread('tupian.jpg'); %读入图像
figure;
imshow(I); 
I =im2bw(I);                    %将图像二值化
[y,x]=find(I);                   %找出I中非零元素的位置
[sy,sx]=size(I);   
figure;%找出I的行和列的大小，赋值给sy，sx
imshow(I);                     %显示I
totalpix = length(x);   
HM = zeros(sy,sx,50);
R = 1:50;
R2 = R.^2;
sz = sy*sx;                                       %矩阵I的所有元素的总和
tic;%计时
for cnt = 1:totalpix
for cntR = 1:50
b = 1:sy;
a = (round(x(cnt) - sqrt(R2(cntR) - (y(cnt) - [1:sy]).^2)));    %a=x-genhao(r^2-(y-b)^2);
b = b(imag(a)==0 & a>0);                              %求出满足条件（imag(a)==0 & a>0）的一系列的a,b值
a = a(imag(a)==0 & a>0);
ind = sub2ind([sy,sx],b,a);                           %求出数组[sy,sx]中的圆心[b,a]的单下标。
HM(sz*(cntR-1)+ind) = HM(sz*(cntR-1)+ind) + 1;        %对满足条件的点（a，b），累加器加1.
end
end
for cnt = 1:50                        
H(cnt) = max(max(HM(:,:,cnt)));
end
plot(H,'*-');
[maxval, maxind] = max(H);           %返回H中的最大值maxval(即为max value)和索引maxind(即为最大值的那一层)
[B,A] = find(HM(:,:,maxind)==maxval);%找到最大值的横纵坐标，即圆心。
toc;
imshow(I);
hold on;                            %显示I。
plot(mean(A),mean(B),'xr')          %mean(A)(求A的平均),mean(B)(求B的平均)。标记xr。
text(mean(A),mean(B),num2str(maxind),'color','green')

