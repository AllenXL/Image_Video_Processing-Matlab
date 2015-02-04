imshow('0431.bmp');
rect = getrect()
x1 = rect(2); x2 = rect(2) + rect(4);
y1 = rect(1); y2 = rect(1) + rect(3);
cpoint = [round((x2+x1)/2),round((y2+y1)/2)]

x=round((y2+y1)/2);y=round((x2+x1)/2);hx=20;hy=20;N=500;n=100;new_sita=0.20;%%%输入图像并选择感兴趣区域

F = getframe;
mkdir('result1');
image_source=strcat('result1\','1.bmp');
imwrite(F.cdata,image_source);


global v_count;
global matrix;
global first;
v_count=512;
matrix=1:1:v_count;   %%%%%maybe it should be changed to global variable
first=0384;

Hx=int16(hx);
Hy=int16(hy);

name=num2str(first,'%04.4g');
firstname=[name,'.bmp'];
I=imread(firstname);




% function bin=histgram1(x,y,Hx,Hy,I)
global v_count;
global matrix;

bin=zeros(1,v_count);
    
dx=double(Hx);
dy=double(Hy);
a=(dx.^2+dy.^2)^0.5;  %a is adjust parament
pixel_distance=a;
d=0;
r=0;

count=0;   %test how many pixels are included for the calculation of histgram


%I=getimage  

 for pixel_x=(x-Hx):1:(x+Hx)
      for pixel_y=(y-Hy):1:(y+Hy)
            if(((x-pixel_x)^2/Hx+(y-pixel_y)^2/Hy)<=1)
             R=double(I(pixel_y,pixel_x,1));
             G=double(I(pixel_y,pixel_x,2));
             B=double(I(pixel_y,pixel_x,3)) ; %get the r,g,b of the current pixel 
             a1=floor(R/32);
             a2=floor(G/32);
             a3=floor(B/32);
             bin_id=matrix(a1*64+a2*8+a3+1);%all colorbin function, return the corresponding color bin for the pixel 
                %bin_id=colorbin(R,G,B);
             pixel_distance=((double(x-pixel_x).^2)+(double(y-pixel_y).^2)).^0.5;   %%%%%%%%%%%%%it has been modified here:   .^ instead of ^
             r=pixel_distance/a;
             k=1-r^2;   % k is the weight of the current pixel for its color bin--in other words, k is the data will be added to the color bin,
%              k=exp((-1.0/2)*r^2)%%%这里采用核函数是高斯核，是给靠近目标中心的像素赋予较高的权重，
                                 %%%能有效的避免目标外围像素易受遮挡和干扰等不稳定问题
             bin(bin_id)=bin(bin_id)+k;   %bin[i] is the ith color bin,the data in all of bins together make the color histgram(a vector)
             d=d+k;                       %d is an accumulative paramater, to adjust the vector,which you will see later how bin[] is made
    %  
          end;
     end;
 end;
            
f=1/d;
time=1:1:v_count;
bin(time)=f*bin(time);
stem(bin(time),'.');