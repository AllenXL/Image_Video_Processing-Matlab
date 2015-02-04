function lab=TriTClassifier(X_L, labels, Xtest, groundtruth)
%put labeled samples first
% labels(i)>=0 if x_i in X_L is labled
% groundtruth: true label of X_L
if nargin<4
    groundtruth=[];
end
[Dim,N]=size(X_L);
idx_label=labels>=0;
NL=sum(idx_label);
CL=unique(labels(idx_label));
CN=length(CL);
lab=labels(1:sum(idx_label)); %label of the first NL samples in X_L

X_T=X_L(:,idx_label);
bootstrap_idx=randi(NL,[3,NL]);
S1=X_T(:,bootstrap_idx(1,:)); lab1=lab(bootstrap_idx(1,:));
S2=X_T(:,bootstrap_idx(2,:)); lab2=lab(bootstrap_idx(2,:));
S3=X_T(:,bootstrap_idx(3,:)); lab3=lab(bootstrap_idx(3,:));

X_U=X_L(:,NL+1:end);
if ~isempty(groundtruth)
    truth=groundtruth(NL+1:end);
end

lab_L1=ANNClassifier(S1,lab1,X_L);
labtest1=lab_L1(NL+1:end);
lab_L2=DTClassifier(S2,lab2,X_L);
labtest2=lab_L2(NL+1:end);
lab_L3=NBClassifier(S3,lab3,X_L);
labtest3=lab_L3(NL+1:end);
lab=labvote(lab_L1,lab_L2,lab_L3,truth,NL);

lab_U{1}=labtest1;
lab_U{2}=labtest2;
lab_U{3}=labtest3;

L_U{1}=[];
L_U{2}=[];
L_U{3}=[];
lab_Li{1}=[];
lab_Li{2}=[];
lab_Li{3}=[];
h=[1 2 3];

% if ~isempty(groundtruth)
%
%     fprintf('All:%d,ANN:%d, DT:%d, NB:%d\n',sum(lab~=truth),sum(labtest1(:)~=truth(:)),sum(labtest2(:)~=truth(:)),sum(labtest3(:)~=truth(:)));
% end
minERR=sum(lab~=truth);
L_Um=[];
lab_Lim=[];
for loop=1:10
    for i=1:3
        idx=find(h~=i);
        labj=lab_U{idx(1)}; %classification results of X_U
        labk=lab_U{idx(2)};
        Li=[];
        labi=[];
        
        for n=1:length(labj)
            if labj(n)==labk(n)
                Li=cat(2,Li,X_U(:,n)); %add xi to label set
                labi=cat(1,labi,labj(n));
            end
        end
        l_i=floor(size(Li,2)*0.5);
        if l_i>(N-NL)*0.05
            idx=randperm(size(Li,2),max(1,round((N-NL)*0.05)));
            Li=Li(:,idx);
            labi=labi(idx);
        end
        Li2=L_U{i};
        labi2=lab_Li{i};
        L_U{i}=cat(2,Li2,Li);
        lab_Li{i}=cat(1,labi2,labi);
    end
    
    %re-training
    lab_L1=ANNClassifier(cat(2,S1,L_U{1}),cat(1,lab1,lab_Li{1}),X_L);
    lab_L2=DTClassifier(cat(2,S2,L_U{2}),cat(1,lab2,lab_Li{2}),X_L);
    lab_L3=NBClassifier(cat(2,S3,L_U{3}),cat(1,lab3,lab_Li{3}),X_L);
    labtest1=lab_L1(NL+1:end);
    labtest2=lab_L2(NL+1:end);
    labtest3=lab_L3(NL+1:end);
    lab=labvote(lab_L1,lab_L2,lab_L3,truth,NL);
    lab_U{1}=labtest1;
    lab_U{2}=labtest2;
    lab_U{3}=labtest3;
    
    %     if ~isempty(groundtruth)
    %         lab=labvote(lab_L1,lab_L2,lab_L3,truth,NL);
    %         fprintf('All:%d,ANN:%d, DT:%d, NB:%d\n',sum(lab~=truth),sum(labtest1(:)~=truth(:)),sum(labtest2(:)~=truth(:)),sum(labtest3(:)~=truth(:)));
    %     end
    ERR=sum(lab~=truth);
    if ERR<minERR
        minERR=ERR;
        L_Um=L_U;
        lab_Lim=lab_Li;
    end
    %     L_U{1}=[];
    %     L_U{2}=[];
    %     L_U{3}=[];
    %     lab_Li{1}=[];
    %     lab_Li{2}=[];
    %     lab_Li{3}=[];
end
tic
if ~isempty(L_Um)
    lab_L1=ANNClassifier(cat(2,S1,L_Um{1}),cat(1,lab1,lab_Lim{1}),Xtest);
    lab_L2=DTClassifier(cat(2,S2,L_Um{2}),cat(1,lab2,lab_Lim{2}),Xtest);
    lab_L3=NBClassifier(cat(2,S3,L_Um{3}),cat(1,lab3,lab_Lim{3}),Xtest);
else
    lab_L1=ANNClassifier(S1,lab1,Xtest);
    lab_L2=DTClassifier(S2,lab2,Xtest);
    lab_L3=NBClassifier(S3,lab3,Xtest);
end
lab=labvote(lab_L1,lab_L2,lab_L3);
fprintf('TriT time for prediction: %.02f\n',toc)

function lab=labvote(lab1,lab2,lab3,truth,N_L)
if nargin>3
    lab1=lab1(:);
    lab2=lab2(:);
    lab3=lab3(:);
    labi{1}=lab1;
    labi{2}=lab2;
    labi{3}=lab3;
    truth=truth(:);
    Err=[sum(lab1(N_L+1:end)~=truth) sum(lab2(N_L+1:end)~=truth) sum(lab3(N_L+1:end)~=truth)];
    idx=find(Err==min(Err));
    minElab=labi{idx(1)};
else
    N_L=0;
end
lab=zeros(length(lab1),1);
for k=N_L+1:length(lab1)
    if lab1(k)==lab2(k)
        lab(k)=lab1(k);
    elseif lab2(k)==lab3(k)
        lab(k)=lab2(k);
    elseif lab1(k)==lab3(k)
        lab(k)=lab1(k);
    else
        if nargin>3
            lab(k)=minElab(k);
        else
            lab(k)=lab1(k);
        end
    end
end
if nargin>3
    lab=lab(N_L+1:end);
end