%the fuction calculate the histgram of a given sample(which is a elliptic region defined by x,y,Hx and Hy)

function bin=histgram1(x,y,Hx,Hy,I)
global v_count;
global matrix;  

bin=zeros(1,v_count);
    
dx=double(Hx);
dy=double(Hy);
a=(dx.^2+dy.^2)^0.5;  %a is adjust parament 
pixel_distance=a;   %%a�ǹ�һ������
d=0;
r=0;

count=0;   %test how many pixels are included for the calculation of histgram     count��Ϊ�����ڵ����ظ���


%I=getimage  

 for pixel_x=(x-Hx):1:(x+Hx)
      for pixel_y=(y-Hy):1:(y+Hy)   %%�ڸ��ٿ�Χ�ڽ���ͳ��
            if(((x-pixel_x)^2/Hx+(y-pixel_y)^2/Hy)<=1)
             R=double(I(pixel_y,pixel_x,1));
             G=double(I(pixel_y,pixel_x,2));
             B=double(I(pixel_y,pixel_x,3)) ; %get the r,g,b of the current pixel 
             a1=floor(R/32);
             a2=floor(G/32);
             a3=floor(B/32);  %%%RGB������ɫͨ������ÿ��ͨ��������Ϊ32���Ҷȼ�
             bin_id=matrix(a1*64+a2*8+a3+1);%all colorbin function, return the corresponding color bin for the pixel 
                %bin_id=colorbin(R,G,B);
             pixel_distance=((double(x-pixel_x).^2)+(double(y-pixel_y).^2)).^0.5;   %%%x��yΪ��ѡĿ��������������꣬pixel_x��pixel_yΪ������ÿ�����ص�����
             r=pixel_distance/a;
             k=1-r^2;   % k is the weight of the current pixel for its color bin--in other words, k is the data will be added to the color bin,
%               k=exp((-1.0/2)*r^2)%%%������ú˺����Ǹ�˹�ˣ��Ǹ�����Ŀ�����ĵ����ظ���ϸߵ�Ȩ�أ�
                                 %%%����Ч�ı���Ŀ����Χ���������ڵ��͸��ŵȲ��ȶ�����
             bin(bin_id)=bin(bin_id)+k;   %bin[i] is the ith color bin,the data in all of bins together make the color histgram(a vector)b[x]��ʾx�����ص���ɫֵ
             d=d+k;                       %d is an accumulative paramater, to adjust the vector,which you will see later how bin[] is made
    %  
          end;
     end;
 end;
            
f=1/d;
time=1:1:v_count;
bin(time)=f*bin(time);