function [lab,prob]=SVMClassifier(X_T,lab_T,X_U, para,  kernel)
% X_T: DxN data matrix
% kernel:  % 0: linear, 1: polynomial, 2:radial basis, 3:sigmoid, 4: precomputed
% sigma: n/a(kernel=0), degree(kernel=1), sigma(kernel=2), gamma(kernel=3)

if nargin<5
    kernel=2;
    if nargin<4
        para=2;
    end
end
sigma=para;
if sigma<=0
    if size(X_T,1)~=size(X_T,2)
        error('First parameter have to be the kernel matrix of training sample, if sigma<0');
    end
    [~,p]=chol(X_T);
    if p~=0
        error('Kernel matrix have be positive semidefinite');
    end
    kernel=4;
end

if ~isvector(lab_T)
    error('labels must be a one dimension vector');
end

labels=lab_T(:);
if size(X_T,2) ~= length(labels)
    X_T=X_T';
    X_U=X_U';
end

if size(X_T,3)~=1 || size(X_U,3)~=1
    error('Data matrix must be two dimension');
end

switch kernel+1
    case 1 %linear
        s=sprintf('-t 0 -b 1');
    case 2 %poly
        s=sprintf('-t 1 -d %d -b 1', sigma); 
    case 3 %radial
        s=sprintf('-t 2 -g %f -b 1', sigma);
    case 4 %sigmoid
        s=sprintf('-t 3 -g %f -b 1', sigma);
    case 5 %predefined kernel
        s=sprintf('-t 4  -b 1'); %X_T is the training kernel Kt=Xt'*Xt; X_U is the test-training joint kernel, Kut=Xu'*Xt
end


if kernel<4
    model=svmtrain(labels,X_T',s);
    tic
    [lab, acc, prob]=svmpredict(ones(size(X_U,2),1), X_U',model,'-b 1');
else
    N=size(X_T,1);
    K1 = [(1:N)', X_T];
    model= svmtrain(labels, K1, '-t 4 -b 1');
    
    tic
    N=size(X_U,1);
    K2=[(1:N)', X_U];
    [lab, acc, prob]=svmpredict(ones(size(X_U,2),1),K2, model,'-b 1');
end
fprintf('SVM time for prediction: %.02f\n',toc)
% if nargin<4 || isempty(sigma)
%     model=svmtrain(lab_T,X_T','-b 1');
%     [lab, acc, prob]=svmpredict(ones(size(X_U,2),1), X_U',model,'-b 1');
% elseif sigma>0
%     s=sprintf('-g %f -b 1',sigma);
%     model=svmtrain(lab_T,X_T',s);
%     [lab, acc, prob]=svmpredict(ones(size(X_U,2),1), X_U',model,'-b 1');
% elseif sigma<=0 
%     % predefined kernel matrix, X_T is the kernel of training samples, 
%     %Xtest is the joint kernel between testing and traing samples
%     N=size(X_T,1);
%     K1 = [(1:N)', X_T];
%     model= svmtrain(lab_T, K1, '-t 4 -b 1');
%     
%     N=size(Xtest,1);
%     K2=[(1:N)', X_U];
%     [lab, acc, prob]=svmpredict(ones(size(X_U,2),1),K2, model,'-b 1');
% end
