% function Estimate=tracker(x,y,hx,hy,N,first,n,new_sita)%%%�Ƿ���Ըĳ�ֱ�Ӷ���Ƶ���и��ٲ���
imshow('0375.bmp');
rect = getrect()
x1 = rect(2); x2 = rect(2) + rect(4);
y1 = rect(1); y2 = rect(1) + rect(3);
cpoint = [round((x2+x1)/2),round((y2+y1)/2)]





x=round((y2+y1)/2);y=round((x2+x1)/2);hx=20;hy=20;N=500;n=100;new_sita=0.20;

global v_count;
global matrix;
global first;
v_count=512;
matrix=1:1:v_count;   %%%%%maybe it should be changed to global variable
first=375;

%image_boundary_x=int16(720);%int16(700); 
%image_boundary_y=int16(576);%int16(550);
image_boundary_x=int16(384);
image_boundary_y=int16(288);%%��ζ�ȡĿ�����������ֵ

Hx=int16(hx);
Hy=int16(hy);
vx=0;
vy=0;
name=num2str(first,'%04.4g');
firstname=[name,'.bmp'];
I=imread(firstname);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imshow('0375.bmp')
F = getframe;
mkdir('result');
image_source=strcat('result\','1.jpg');
imwrite(F.cdata,image_source);
[Sample_Set,Sample_probability,Estimate,target_histgram]=initial1(x,y,Hx,Hy,vx,vy,I,N);

for loop=2:1:n;
    if Estimate(loop-1).prob>=0.05
       k=target_histgram;%�жϸ���Ч���������һ����Χ���򲻸���ģ��
       %target_histgram=0.8*k+0.2*Estimate(loop-1).histgram;
       if(loop<100)
         target_histgram=0.90*k+0.10*Estimate(loop-1).histgram;%����ģ��
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
                        New_Sample_Set=Select(Sample_Set,Sample_probability,loop,I,N);%%�ز������֣�SIR������
               [Sample_Set,after_prop]=Propagation(New_Sample_Set,vx,vy,image_boundary_x,image_boundary_y,I,N);%%�����������100����ѡ����
   [Sample_probability,Estimate,vx,vy,TargetPic]=Observe_and_Estimate(Sample_Set,Estimate,target_histgram,new_sita,loop,after_prop,I,N,first);
    else 
        a=0;
        return;
    end
    %figure;%%%%%%%%%
    imshow(TargetPic);%%%%%%%%%%%%%%%%%


   F = getframe;
    image_source=strcat('result\',num2str(loop),'.bmp');
     imwrite(F.cdata,image_source);  
    %%�����Ǽӵ�ͼƬ�Զ�����ָ��
end


fidout=fopen('data.txt','w'); %%%����һ����⺯�����������Ƿ�ɹ�
for loop=2:1:n;
    fprintf(fidout,'%02.4f\n',Estimate(loop).prob);                              
end
fclose(fidout);

