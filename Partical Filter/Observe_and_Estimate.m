function [Sample_probability,Estimate,vx,vy,after_prop]=Observe_and_Estimate(Sample_Set,Estimate,target_histgram,new_sita,loop,after_prop,I,N,first)

Total_probability=0;
for i=1:1:N
    Sample_histgram(i).element=histgram1((Sample_Set(i).x),(Sample_Set(i).y),(Sample_Set(i).Hx),(Sample_Set(i).Hy),I); 
    Sample_probability(i)=weight(target_histgram,Sample_histgram(i).element,new_sita);
    Total_probability=Total_probability+Sample_probability(i);
end
Total_probability;
Estimate(loop).x=0;
Estimate(loop).y=0;
Estimate(loop).Hx=0;
Estimate(loop).Hy=0;
for i=1:1:N
    Estimate(loop).x=Estimate(loop).x+double(Sample_Set(i).x)*(Sample_probability(i)/Total_probability); 
    Estimate(loop).y=Estimate(loop).y+double(Sample_Set(i).y)*(Sample_probability(i)/Total_probability);
    
    Estimate(loop).Hx=Estimate(loop).Hx+double(Sample_Set(i).Hx)*(Sample_probability(i)/Total_probability); 
    Estimate(loop).Hy=Estimate(loop).Hy+double(Sample_Set(i).Hy)*(Sample_probability(i)/Total_probability);
end
Estimate(loop).histgram=histgram1(round(Estimate(loop).x),round(Estimate(loop).y),round(Estimate(loop).Hx),round(Estimate(loop).Hy),I);
Estimate(loop).prob=weight(target_histgram,Estimate(loop).histgram,new_sita);  %%%这是一个检测变量，是判断是否进行颜色参考模型更新的主要依据，
                                                                              %%%根据颜色参考分布和当前目标颜色分布的Bhattacharyya系数对参考颜色柱状图进行实时跟新
                                                

%计算速度
a=floor(Estimate(loop).x);
b=floor(Estimate(loop-1).x);
vx=a-b;
c=floor(Estimate(loop).y);
d=floor(Estimate(loop-1).y);
vy=c-d;
e=floor(Estimate(loop).Hx);
f=floor(Estimate(loop).Hy);

i=1;
for new_x=a-i:a+i;
       for new_y=c-i:c+i;
          after_prop(new_y,new_x,:)=255;
       end;
end;

 edge_x=a-e;
 edge_y=c-f;
 
 for i=1:2*e
     after_prop(c-f,edge_x+i,:)=255;
     after_prop(c+f,edge_x+i,:)=255;
 end;
 for i=1:2*f
     after_prop(edge_y+i,a-e,:)=255;
     after_prop(edge_y+i,a+e,:)=255;
end;
    
%a=num2str(loop,'%03.3g');
a=num2str(loop+first-1,'%04.4g');
% b=['e:\result1\',a,'.bmp'];
% imwrite(after_prop,[a,'.bmp']);
% imshow([b]);
    
