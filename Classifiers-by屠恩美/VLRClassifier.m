function lab_vlr=VLRClassifier(X_L,labels, alpha, gamma, sigma, Xtest)
%gamma is the regularization parameter
%alpha is the random walk probability, 1-alpha is the return probability
%labeled samples first
% labels(i)>=0 if x_i is labled
[Dim,N]=size(X_L);
idx_label=labels>=0;
CL=unique(labels(idx_label));
CN=length(CL);

W=construct_graph(X_L,sigma,'full',5);

% W=W-diag(diag(W));
% d=1./sqrt(sum(W));
% D=repmat(d,N,1);
% S=D'.*W.*D;
% R=(eye(N)-0.99*S);
% % initial assignment matrix
% Y=zeros(N,CN);
% for c=1:CN
%     l=labels==CL(c);
%     Y(l,c)=1;
% end
% % learning
% F_c=R\Y;
% S=diag(sum(F_c,2));
% e=ones(N,1);
% L_s=S-1/(e'*S*e)*S*e*e'*S;
% C_s=eye(N)-1/(e'*S*e)*S*e*e';
% W=inv(X_L*L_s*X_L'+gamma*eye(Dim))*X_L*C_s*F_c;
% b=1/(e'*S*e)*(F_c'-W'*X_L*S)*e;
% 
% Y_L=zeros(N,CN);
% for k=1:N
%     x=X_L(:,k);
%     Y_L(k,1:CN)=W'*x+b;
% end
% [~,lab_vlr]=max(Y_L,[],2);




P=diag(1./sum(W))*W;
I_alpha=diag(~idx_label);I_alpha=I_alpha*alpha;
I_beta=eye(N)-I_alpha;
Phat=I_alpha*P;
G=(eye(N)-Phat)\I_beta;


Y=zeros(N,CN+1);
for k=1:N
    if labels(k)>=0
        idx=find(labels(k)==CL);
        Y(k,idx)=1;
    else
        Y(k,CN+1)=1;
    end
end

F=G*Y;
F_c=F(:,1:CN);

S=diag(sum(F_c,2));
e=ones(N,1);
L_s=S-1/(e'*S*e)*(S*e)*(e'*S);
C_s=eye(N)-1/(e'*S*e)*(S*e)*e';
W=inv(X_L*L_s*X_L'+gamma*eye(Dim))*X_L*C_s*F_c;
b=1/(e'*S*e)*(F_c'-W'*X_L*S)*e;

[D,N]=size(Xtest);
% Ytest=zeros(N,CN);
% for k=1:N
%     x=Xtest(:,k);
%     Ytest(k,1:CN)=W'*x+b;
% end
tic
Ytest=W'*Xtest+repmat(b,1,N);
[~,lab_vlr]=max(Ytest',[],2);
fprintf('VLR time for prediction: %.02f\n',toc)




return;

t=sum(idx_label); %number of labeled samples
X_l=X_L(:,1:t);
e_l=ones(t,1);
L_c=eye(t)-e_l*e_l'/t;
F_tilde=X_l'*W+e_l*b';
T=Y(1:t,1:CN);
W_o=pinv(F_tilde'*L_c*F_tilde)*F_tilde'*L_c*T;
b_o=(F_tilde'-W_o'*X_l)*e_l/t;

Y_L=zeros(N,CN);
for k=1:N
    x=X_L(:,k);
    Y_L(k,1:CN)=W_o'*(W'*x+b)+b_o;
end
[~,lab_vlr]=max(Y_L,[],2);
