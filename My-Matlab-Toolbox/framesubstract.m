clear all;

%������Ƶ��ת��ΪͼƬ��
N=6;   %����ǰ6֡��֡���ַ�����Ҫ��ȡǰ7֡��
avi=VideoReader('F:\\2.avi');     %������Ƶ�ļ�
mov=zeros(avi.Height,avi.Width,N+1);                                         

for k=1:N+1
    mov(:,:,k)=rgb2gray(read(avi,k));
end
alldiff=zeros(avi.Height,avi.Width,N);              
  
for k=1:N
  diff=abs(mov(:,:,k)-mov(:,:,k+1));           %��֡���
  idiff=diff>10;                          %��ֵ��
  alldiff(:,:,k)=double(idiff);           %�洢��֡�Ĳ�ֽ��
end

%�۲�֡���ֵĶ�ֵ�����������۲�ǰ��֡��������֡��ֶ�ֵ�����
subplot(3,2,1),imshow(alldiff(:,:,1)),title('��1,2֡���')
subplot(3,2,2),imshow(alldiff(:,:,2)),title('��2,3֡���')
subplot(3,2,3),imshow(alldiff(:,:,3)),title('��3,4֡���')
subplot(3,2,4),imshow(alldiff(:,:,4)),title('��4,5֡���')
subplot(3,2,5),imshow(alldiff(:,:,5)),title('��5,6֡���')
subplot(3,2,6),imshow(alldiff(:,:,5)),title('��6,7֡���')
 

