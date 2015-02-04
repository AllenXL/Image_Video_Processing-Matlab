function [Sample_Set,Sample_probability,Estimate,target_histgram]=initial1(x,y,Hx,Hy,vx,vy,I,N)

Estimate(1).x=x;
Estimate(1).y=y;
Estimate(1).prob=0.98;


       for i=1:1:N
        
        Sample_Set(i).x=x;
        Sample_Set(i).y=y;    
        Sample_Set(i).Hx=Hx;
        Sample_Set(i).Hy=Hy; 
        
       end

target_histgram=histgram1(x,y,Hx,Hy,I);  %%%调用子函数histgram1，提取目标区域的颜色直方图
Estimate(1).histgram=target_histgram;
initial_probability=0.98;
%initial_probability=weight(target_histgram,target_histgram,new_sita);

    for i=1:1:N
  
     Sample_histgram(i).element=histgram1(Sample_Set(i).x,Sample_Set(i).y,Sample_Set(i).Hx,Sample_Set(i).Hy,I);
     Sample_probability(i)=initial_probability;        %first use Sample_probability
    end
   
    j=1;
    new_pic=I;
    for new_x=x-j:x+j;
        for new_y=y-j:y+j;
            new_pic(new_y,new_x,:)=255;
        end;
    end;
    
    a=num2str(1,'%04.4g');
    b=['D:\result\',a,'.bmp'];
    %imwrite(new_pic,b);
    
 edge1=x-Hx;
 edge2=y-Hy;
 for i=1:2*Hx
     new_pic(edge2,edge1+i,:)=255;
     new_pic(y+Hy,edge1+i,:)=255;
 end;
 for i=1:2*Hy
    new_pic(edge2+i,edge1,:)=255;
    new_pic(edge2+i,x+Hx,:)=255;
end;
  imwrite(new_pic,'org.bmp')          
 
