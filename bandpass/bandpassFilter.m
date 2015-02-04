I= imread('arm2.jpg'); 

I=double(rgb2gray(I));   


I1=fft2(I);        % 傅立叶变换
I2=fftshift(I1); 
[M,N]=size(I2);
D0=80;W=240;

m=fix(M/2); n=fix(N/2);  
for x=1:M
       for y=1:N
          D(x,y)=((x-m).^2+(y-n).^2).^0.5;
          %采用高斯带通滤波处理周期噪声
          H(x,y)=1-exp(-0.5*(((D(x,y).^2-D0^2)./D(x,y)/W)^2));
             
           I2(x,y)=H(x,y).*I2(x,y);
       end
end
figure(1);
mesh(H);
I3=real(ifft2(ifftshift(I2)));
figure(2);
subplot(131),imshow(I,[]);           title('原图');
subplot(132),imshow(log(abs(I2)),[]);title('滤波后频谱图');
subplot(133),imshow(I3,[]);          title('滤波后图像');