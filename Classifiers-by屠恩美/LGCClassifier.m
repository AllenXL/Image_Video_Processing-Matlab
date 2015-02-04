function [lab, F]=LGC(X_T,lab_T, X_U,sigma,standard,ratio, const)
% lab: the class label of the first samples in X
% standard=0: standard matrix invert implementation; standard=1: iteration
% implemented; standard==2: personalized
% ratio: for personalized on, the proportion of propagation rate less than
% 0.99.
% const: the pair wise constrations. const{1}=[1 3 4] means samples 1 3 4 must link for class one;
% const{2}=[ 5 6] means sample 5 and 6 must line for class 2. 

% reference: Dengyong Zhou, Local and global consistency, NIPS 2003
X=cat(2,X_T,X_U);
lab=lab_T;
if nargin<6
    const=[];
    if nargin<5
        ratio=0.1;
        if nargin<4
            standard=0;
            if nargin<3
                sigma=get_sigma(X);
            end
        end
    end
end
N=size(X,2);
W=construct_graph(X,sigma,'full');
if ~isempty(const)
    for k=1:length(const)
        idx=const{k};
        W(idx,idx)=200; % constraints of must-link
    end
    for i=1:length(const)
        idxi=const{i};
        for j=i+1:length(const)
            idxj=const{j};
            W(idxi,idxj)=0; %constraints of cannot-link
        end
    end
end

%compute graph matrix
% idx=sub2ind(size(W),1:N,1:N);
% W(idx)=0;
d=1./sqrt(sum(W)+eps);
D=repmat(d,size(X,2),1);
S=D'.*W.*D;
clear D W
R=(eye(size(X,2))-0.99*S);
%prepare initial label matrix Y

CN=length(unique(lab));
CL=unique(lab);
Y=zeros(N,CN);
for c=1:CN
    l=find(lab==CL(c));
    Y(l,c)=1;
end


%iteration
% F=Y;
% for k=1:500
%     F=0.99*S*F+0.01*Y;
%     F=diag(1./sum(F,2))*F;
% end

if standard==0
    %standard
    
    F=R\Y+eps;
elseif standard==1 %iteration
    
    F=Y;
    for k=1:500
        F=0.99*S*F+0.01*Y;
        [U,A,V]=svd(F);
        for i=1:size(F,2)
            A(i,i)=1;
        end
        F=U*A*V';
        F(F<0)=0;
    end
    t=0;
elseif standard==2
    % personalized
    
    K=10;
    [~,D] = knnsearch(X',X', 'K', K+1);
    D=D(:,2:end);
    dmean=mean(D,2);
    
%     % if ratio=0.1,f0=0.95 means more than 10% of alpha's are greater than 0.95;
%     
%     f0=0.95;
%     [ds,ix]=sort(dmean);
%     n1=ceil(length(ds)*ratio);
%     x1=ds(n1);
%     n2=ceil(length(ds)*(1-ratio));
%     x2=ds(n2);
%     mu=(x1+x2)/2;
%     sigma2=(x1-mu)/log((1-f0)/f0);
%     sigma=sqrt(sigma2);
%     
%     alpha=calc_alpha(dmean,mu,sigma);
%     alpha(alpha<0.5)=0;
%     Id=repmat(alpha,1,N);
%     
%     F=Y;
%     for k=1:500
%         F=Id.*S*F+repmat(1-alpha,1,CN).*Y;
%     end
%     t=0;
    
    
    K=10;
    [~,D] = knnsearch(X',X', 'K', K+1);
    D=D(:,2:end);
    dmean=mean(D,2);
    [~,ix]=sort(dmean,'descend');
    idx=floor(N*ratio);
    sigmad=sqrt(-dmean(ix(idx))/(2*log(0.99)));
    alpha=exp(-dmean/(2*sigmad^2));
    Id=repmat(alpha,1,N);
    R=(eye(size(X,2))-Id.*S);
    F=R\(repmat(1-alpha,1,CN).*Y)+eps;
elseif standard==3 %row orthorgnal constraint
    I=eye(size(S));
    mu=1/99;
    L=I-S;
    Y=zeros(size(I,1),2);
    Y(1,1)=1;
    Y(2,2)=1;
    fvar{1}=L; fvar{2}=Y;fvar{3}=mu;fvar{4}=5;
    [fk,xk]=gradient_descent(@fun, @grad, @proj,R\Y, fvar, fvar, fvar,1000,1e-5);
    F=xk;
end
[~,lab]=max(F,[],2);
lab=lab(length(lab_T)+1:end);

function alpha=calc_alpha(x,mu,sigma)
% sigma=1;
% mu=1;
% x=-10:.01:10;
alpha=1./(1+exp((x-mu)/sigma^2));
