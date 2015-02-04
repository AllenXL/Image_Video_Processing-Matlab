 %function Estimate=tracker(x,y,hx,hy,N,first,n,new_sita)%%%是否可以改成直接对视频进行跟踪操作



imshow('0376.bmp');
rect = getrect()
x1 = rect(2); x2 = rect(2) + rect(4);
y1 = rect(1); y2 = rect(1) + rect(3);
cpoint = [round((x2+x1)/2),round((y2+y1)/2)]

x=round((y2+y1)/2);y=round((x2+x1)/2);hx=20;hy=20;N=500;n=200;new_sita=0.20;  %%x，y为目标中心的图像坐标，hx和hy为目标外接矩形的宽和高

global v_count;
global matrix;
global first;
v_count=512;
matrix=1:1:v_count;   %%%%%maybe it should be changed to global variable
first=0376;

%%%%%%
xxx= zeros(1,100); %%%这是用来存储程序运行时间的数组


image_boundary_x=int16(384);
image_boundary_y=int16(288);%%所处理的图像序列的图片大小

Hx=int16(hx);
Hy=int16(hy);
vx=0;
vy=0;
name=num2str(first,'%04.4g');
firstname=[name,'.bmp'];
I=imread(firstname);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imshow('0376.bmp')
F = getframe;
mkdir('result');
image_source=strcat('result\','1.jpg');
imwrite(F.cdata,image_source);  %%保存初始帧图片指令


[Sample_Set,Sample_probability,Estimate,target_histgram]=initial1(x,y,Hx,Hy,vx,vy,I,N); %%%调用子函数initial，

st=cputime;        % 程序开始运行时的cpu时间
% 程序开始

for loop=2:1:n;
%     F = getframe;
    if Estimate(loop-1).prob>=0.05   %%%颜色参考模型的更新判断，其中0.05为阈值
        k=target_histgram;       
%        target_histgram=0.8*k+0.2*Estimate(loop-1).histgram;
       if(loop<100)
         target_histgram=0.90*k+0.10*Estimate(loop-1).histgram;      %%%更新颜色参考模型
       elseif(loop<200)
           new_sita=0.25;
         target_histgram=0.99*k+0.01*Estimate(loop-1).histgram;  
       elseif(loop<280)
            new_sita=0.30;
         target_histgram=0.99*k+0.01*Estimate(loop-1).histgram; 
       else
            new_sita=0.30;
         target_histgram=0.99*k+0.01*Estimate(loop-1).histgram; 
       end
    a=num2str(loop+first-1,'%04.4g');
    b=[a,'.bmp'];
    I=imread(b);
                        New_Sample_Set=Select(Sample_Set,Sample_probability,loop,I,N);%%重采样部分（SIR方法）
               [Sample_Set,after_prop]=Propagation(New_Sample_Set,vx,vy,image_boundary_x,image_boundary_y,I,N);%%随机采样产生100个候选粒子
   [Sample_probability,Estimate,vx,vy,TargetPic]=Observe_and_Estimate(Sample_Set,Estimate,target_histgram,new_sita,loop,after_prop,I,N,first);
    else 
        a=0;
        return;
    end

    % 程序结束
et=cputime-st;        % 计算程序运行所用的时间

xxx(loop)=et; 
%figure;%%%%%%%%%
    imshow(TargetPic);%%%%%%%%%%%%%%%%%


   F = getframe;
    image_source=strcat('result\',num2str(loop),'.bmp');
     imwrite(F.cdata,image_source);  
    %%以上是加的图片自动保存指令
end


fidout=fopen('data.txt','w'); %%%这是一个检测函数，用来检测是否进行模板更新的依据
for loop=2:1:n;
    fprintf(fidout,'%02.4f\n',Estimate(loop).prob);                              
end
fclose(fidout);

