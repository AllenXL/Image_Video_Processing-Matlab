function [Sample_Set,after_prop]=Propagation(New_Sample_Set,vx,vy,image_boundary_x,image_boundary_y,I,N)

sigma_x=5;
sigma_y=5;
%sigma_x=12;
%sigma_y=12;

sigma_Hx=0.2;
sigma_Hy=0.2;

after_prop=I;

u1=double(vx);
u2=double(vy);
%u1=0;
%u2=0;
rn=random('Normal',u1,sigma_x,1,100*N);
rn2=random('Normal',u2,sigma_y,1,100*N);

rHn=random('Normal',0,sigma_Hx,1,100*N);
rHn2=random('Normal',0,sigma_Hy,1,100*N);

count=1;
i=1;


while count<=N
    current_x=int16(New_Sample_Set(count).x);
    current_y=int16(New_Sample_Set(count).y);
    
    current_Hx=int16(New_Sample_Set(count).Hx);
    current_Hy=int16(New_Sample_Set(count).Hy);

    rand_x=int16(rn(i));
    rand_y=int16(rn2(i));
    
    rand_Hx=int16(rHn(i));
    rand_Hy=int16(rHn2(i));
    
    while (current_x+rand_x-current_Hx<1||current_y+rand_y-current_Hy<1||current_x+rand_x+current_Hx>image_boundary_x||current_y+rand_y+current_Hy>image_boundary_y)
        i=i+1;
        rand_x=int16(rn(i));
        rand_y=int16(rn2(i));
         rand_Hx=int16(rHn(i));
         rand_Hy=int16(rHn2(i));
    end
 %after select born new sample set 
 %linear stochastic differential equation  rand_x/y 
    Sample_Set(count).x=current_x+rand_x;
    Sample_Set(count).y=current_y+rand_y;     
    
    Sample_Set(count).Hx=current_Hx+rand_Hx;
    Sample_Set(count).Hy=current_Hy+rand_Hy;  
     count=count+1;
    i=i+1;
end

%sample_draw    %to draw the samples out in output images
i=1;
for  i=1:1:N
  
           after_prop(Sample_Set(i).y,Sample_Set(i).x,2)=0;
           after_prop(Sample_Set(i).y,Sample_Set(i).x,3)=0;
           after_prop(Sample_Set(i).y,Sample_Set(i).x,1)=255;
end;


 
