function lab_U=wKNNClassifier(X_T,lab_T,X_U,K, sigma)
%X_T: training set, d x n

% Klaus Hechenbichler, Weighted k-Nearest-Neighbor Techniques and Ordinal
% Classification, 2004
if nargin<5
    sigma=1;
    if nargin<4
        K=5;
    end
end
if ~isvector(lab_T)
    error('labels must be a one dimension vector');
end
labels=lab_T(:);
if size(X_T,2) ~= length(labels)
    X_T=X_T';
    X_U=X_U';
end

[IDX,D] = knnsearch(X_T',X_U','K',K+1);
IDX=IDX(:,1:end-1);
D=D(:,1:end-1)./repmat(D(:,end)+eps,1,K);
Kd=exp(-D/(2*sigma^2)); %kernel similarity between each sample and its neighbors

Nu=size(X_U,2);
cls=unique(lab_T);
CN=length(cls);

%class label of the neighbors
tlab=zeros(size(IDX));
for k=1:Nu
    tlab(k,:)=lab_T(IDX(k,:));
end

W=zeros(Nu,CN);
for c=1:CN
    Kd2=Kd;
    L=tlab==c;
    Kd2(~L)=0;
    W(:,c)=sum(Kd2,2);
end
[~,lab_U]=max(W,[],2);    