clear all;

%导入视频，转换为图片；
N=6;   %考虑前6帧的帧间差分法（需要读取前7帧）
avi=VideoReader('F:\\2.avi');     %读入视频文件
mov=zeros(avi.Height,avi.Width,N+1);                                         

for k=1:N+1
    mov(:,:,k)=rgb2gray(read(avi,k));
end
alldiff=zeros(avi.Height,avi.Width,N);              
  
for k=1:N
  diff=abs(mov(:,:,k)-mov(:,:,k+1));           %邻帧差分
  idiff=diff>10;                          %二值化
  alldiff(:,:,k)=double(idiff);           %存储各帧的差分结果
end

%观察帧间差分的二值化结果，这里观察前五帧的相邻两帧差分二值化结果
subplot(3,2,1),imshow(alldiff(:,:,1)),title('第1,2帧差分')
subplot(3,2,2),imshow(alldiff(:,:,2)),title('第2,3帧差分')
subplot(3,2,3),imshow(alldiff(:,:,3)),title('第3,4帧差分')
subplot(3,2,4),imshow(alldiff(:,:,4)),title('第4,5帧差分')
subplot(3,2,5),imshow(alldiff(:,:,5)),title('第5,6帧差分')
subplot(3,2,6),imshow(alldiff(:,:,5)),title('第6,7帧差分')
 

