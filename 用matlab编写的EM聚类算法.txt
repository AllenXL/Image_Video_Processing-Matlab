close all;clear;clc;
%   参考书籍Pattern.Recognition.and.Machine.Learning.pdf
%   2009/10/15
%% 
M=3;          % number of Gaussian
N=600;        % total number of data samples
th=0.000001;  % convergent threshold
K=2;          % demention of output signal

% 待生成数据的参数
a_real =[2/3;1/6;1/6];
mu_real=[3 4 6;
         5 3 7];
cov_real(:,:,1)=[5 0;
                 0 0.2];
cov_real(:,:,2)=[0.1 0;
                 0 0.1];
cov_real(:,:,3)=[0.1 0;
                 0 0.1];                     
% 这里生成的数据全部符合标准
x=[ mvnrnd( mu_real(:,1) , cov_real(:,:,1) , round(N*a_real(1)) )' ,...
    mvnrnd( mu_real(:,2) , cov_real(:,:,2) , round(N*a_real(2)) )' ,...
    mvnrnd( mu_real(:,3) , cov_real(:,:,3) , round(N*a_real(3)) )' ];

figure(1),plot(x(1,:),x(2,:),'.')

%% EM Algorothm
% 参数初始化
a=[1/3,1/3,1/3]; %各类的比例
mu=[1 2 3;       %均值初始化
    2 1 4];
cov(:,:,1)=[1 0; %协方差初始化
            0 1];
cov(:,:,2)=[1 0;
            0 1];
cov(:,:,3)=[1 0;
            0 1];

t=inf;
count=0;
figure(2),hold on
while t>=th
    a_old  = a;
    mu_old = mu;
    cov_old= cov;      
    rznk_p=zeros(M,N);
    for cm=1:M
        mu_cm=mu(:,cm);
        cov_cm=cov(:,:,cm);
        for cn=1:N
            p_cm=exp(-0.5*(x(:,cn)-mu_cm)'/cov_cm*(x(:,cn)-mu_cm));
            rznk_p(cm,cn)=p_cm;
        end
        rznk_p(cm,:)=rznk_p(cm,:)/sqrt(det(cov_cm));
    end
    rznk_p=rznk_p*(2*pi)^(-K/2);
%E step
    %开始求rznk
    rznk=zeros(M,N);%r(Z
    pikn=zeros(1,M);%r(Z
    pikn_sum=0;
    for cn=1:N
        for cm=1:M
            pikn(1,cm)=a(cm)*rznk_p(cm,cn);
%           pikn_sum=pikn_sum+pikn(1,cm);
        end
        for cm=1:M
            rznk(cm,cn)=pikn(1,cm)/sum(pikn);
        end
    end
        %求rank结束
% M step
    nk=zeros(1,M);
    for cm=1:M
        for cn=1:N
            nk(1,cm)=nk(1,cm)+rznk(cm,cn);
        end
    end
    a=nk/N;
    rznk_sum_mu=zeros(M,1);
        
    % 求均值MU
    for cm=1:M
        rznk_sum_mu=0;
        for cn=1:N
            rznk_sum_mu=rznk_sum_mu+rznk(cm,cn)*x(:,cn);
        end
        mu(:,cm)=rznk_sum_mu/nk(cm);
    end
    
    % 求协方差COV   
    for cm=1:M
        rznk_sum_cov=zeros(K,K);
        for cn=1:N
            rznk_sum_cov=rznk_sum_cov+rznk(cm,cn)*(x(:,cn)-mu(:,cm))*(x(:,cn)-mu(:,cm))';
        end
        cov(:,:,cm)=rznk_sum_cov/nk(cm);
    end
         
    t=max([norm(a_old(:)-a(:))/norm(a_old(:));norm(mu_old(:)-mu(:))/norm(mu_old(:));norm(cov_old(:)-cov(:))/norm(cov_old(:))]);
 
    temp_f=sum(log(sum(pikn)));
    plot(count,temp_f,'r+')
    count=count+1;        
end  %while 
   
hold off
f=sum(log(sum(pikn)));
  
% 输出结果
a
mu
cov

figure(3),
hold on
plot(x(1,:),x(2,:),'k.');
plot(mu_real(1,:),mu_real(2,:),'*c');
plot(mu(1,:),mu(2,:),'+r');
hold off

figure(4),
hold on
for i=1:N
    [max_temp,ind_temp]=max(rznk(:,i));
    if ind_temp==1
        plot(x(1,i),x(2,i),'k.');
    end
    if ind_temp==2
        plot(x(1,i),x(2,i),'b.');
    end
    if ind_temp==3
        plot(x(1,i),x(2,i),'r.');
    end    
end
        
        
%fcm聚类
[center, U, OBJ_FCN]=fcm(x',3);
figure(5),
hold on
for i=1:N
    [max_temp,ind_temp]=max(U(:,i));
    if ind_temp==1
        plot(x(1,i),x(2,i),'k.');
    end
    if ind_temp==2
        plot(x(1,i),x(2,i),'b.');
    end
    if ind_temp==3
        plot(x(1,i),x(2,i),'r.');
    end    
end
        
plot(center(:,1),center(:,2),'c*')

hold off  
        
        
        
        
        
        
        
        



