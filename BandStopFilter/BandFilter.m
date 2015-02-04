%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 高斯带阻滤波器
% 滤波器的传递函数为H(u,v)=1-exp(-1/2*((D^2-D0^2)/(D*W))^2)
% 其中W是频带宽度,D0是频带的中心半径
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ImgOut=BandFilter(ImgIn,d0,W)
s=fftshift(fft2(ImgIn));               %将灰度图像的二维不连续Frourier变换的零频率成分移到频谱的中心
[M,N]=size(s);                      %分别返回s的行数到M中，列数到N中
n1=floor(M/2)+1;                    %对M/2进行取整
n2=floor(N/2)+1;                    %对N/2进行取整
for i=1:M
    for j=1:N
        d=sqrt((i-n1)^2+(j-n2)^2);         %点（i,j）到傅立叶变换中心的距离
        h=exp(-1/2*((d^2-d0^2)/(d*W))^2);%GBEF滤波函数
        s1(i,j)=h*s(i,j);                   %GBEF滤波后的频域表示
        H(i,j)=h;
    end
end
figure;
subplot(1,3,1),imshow(log(abs(s)+1),[]);title('滤波前图像傅里叶频谱取对数');
subplot(1,3,2),imshow(log(abs(s1)+1),[]);title('滤波后图像傅里叶频谱取对数');
subplot(1,3,3),mesh(H);title('滤波器频域图');
s=ifftshift(s1);                           %对s进行反FFT移动
%对s进行二维反离散的Fourier变换后，取复数的实部转化为无符号8位整数
s=uint8(real(ifft2(s)));
ImgOut=s;
