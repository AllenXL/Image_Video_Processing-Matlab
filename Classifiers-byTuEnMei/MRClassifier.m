function [labsvm,labrls]=MRClassifier(X_L,lab_T, X_U,SIGMA,gamma_A,gamma_I,DEGREE,NN) 
% Manifold Regularization Classifier
%labsvm is the result of LapSVM and labrls is the result of LapRLS

% sigma: Gaussian kernel width, for graph construction and kernel in SVM
% gamma_A and gamma_I: smoothness regularizer and intrinsic penalty
% Degree: graph Laplacian degree, usually 2
% NN: number of nearest neighbors in graph construction, default 5

% Mikhail Belkin, Manifold Regularization: A Geometric Framework for Learning, JMLR 2006
if ~isvector(lab_T)
    error('labels must be a one dimension vector');
end
if size(X_L,2) ~= length(lab_T)
    X_L=X_L';
    X_U=X_U';
end
tt=0;
X=X_L;
Y=ones(size(X,1),1);
Y(1:length(lab_T))=lab_T;
Xt=X_U;
nar=nargin;
idxLabs=1:length(lab_T);
Yt=ones(size(Xt,1),1);
if nar<8
    NN=10;
    if nar<7
        DEGREE=2;
        if nar<6
            gamma_I=0.01;
            if nar<5
                gamma_A=1e-6;
                if nar<4
                    SIGMA=1;
                end
            end
        end
    end
end




C=unique(Y);
if length(C)==2
             C=[1 -1]; nclassifiers=1;
else
               nclassifiers=length(C);
end
% options contains the optimal parameter settings for the data 
options=make_options;
options.NN=NN;
options.Kernel='rbf';
options.KernelParam=SIGMA;
options.gamma_A=gamma_A; 
options.gamma_I=gamma_I; 
options.GraphWeights='heat';
options.GraphWeightParam=SIGMA;
options.LaplacianDegree=DEGREE;
if ~exist('M','var') 
  M=laplacian(options,X);
end
M=M^options.LaplacianDegree;
tic;
% construct and deform the kernel
% K contains the gram matrix of the warped data-dependent semi-supervised kernel
G=calckernel(options,X);
r=options.gamma_I/options.gamma_A;
% the deformed kernel matrix evaluated over test data
% fprintf(1,'Deforming Kernel\n');
if exist('Xt','var')
    tic
 Gt=calckernel(options,X,Xt);
 [K, Kt]=Deform(r,G,M,Gt);
 tt=toc;
else
  K=Deform(r,G,M);
end
% run over the random splits
if exist('folds','var')
   number_runs=size(folds,2);
else
   number_runs=size(idxLabs,1); 
end
for R=1:number_runs
	if exist('folds','var')
      L=find(folds(:,R));
    else
      L=idxLabs(R,:);
    end
    
    U=(1:size(K,1))'; 
    U(L)=[];
	data.K=K(L,L); data.X=X(L,:); 
 
    fsvm=[];
    frlsc=[];
    fsvm_t=[];
    frlsc_t=[];
 
    for c=1:nclassifiers
%         if nclassifiers>1
%             fprintf(1,'Class %d versus rest\n',C(c)); 
%         end
        data.Y=(Y(L)==C(c))-(Y(L)~=C(c)); % labeled data
        classifier_svm=svm(options,data);
        classifier_rlsc=rlsc(options,data);
         
        fsvm(:,c)=K(U,L(classifier_svm.svs))*classifier_svm.alpha-classifier_svm.b;
        frlsc(:,c)=K(U,L(classifier_rlsc.svs))*classifier_rlsc.alpha-classifier_rlsc.b;

     
        if exist('bias','var')
          [fsvm(:,c),classifier_svm.b]  = adjustbias(fsvm(:,c)+classifier_svm.b,  bias);
          [frlsc(:,c),classifier_rlsc.b] = adjustbias(frlsc(:,c)+classifier_rlsc.b,bias);
        end
 
        results(R).fsvm(:,c)=fsvm(:,c);
        results(R).frlsc(:,c)=frlsc(:,c); 
        yu=(Y(U)==C(c))-(Y(U)~=C(c));
 
        
        if exist('Xt','var')
            tic
            fsvm_t(:,c)=Kt(:,L(classifier_svm.svs))*classifier_svm.alpha-classifier_svm.b;
            frlsc_t(:,c)=Kt(:,L(classifier_rlsc.svs))*classifier_rlsc.alpha-classifier_rlsc.b;
            results(R).fsvm_t(:,c)=fsvm_t(:,c);
            results(R).frlsc_t(:,c)=frlsc_t(:,c);
            yt=(Yt==C(c))-(Yt~=C(c));
            tt=tt+toc;
        end
    end
  
 
   tic
   if nclassifiers==1
        fsvm=sign(results(R).fsvm);
        frlsc=sign(results(R).frlsc);
        if exist('Xt','var')
          fsvm_t=sign(results(R).fsvm_t);
          frlsc_t=sign(results(R).frlsc_t);
        end
   else
        [e,fsvm]=max(results(R).fsvm,[],2); fsvm=C(fsvm);
        [e,frlsc]=max(results(R).frlsc,[],2); frlsc=C(frlsc);
        if exist('Xt','var')
          [e,fsvm_t]=max(results(R).fsvm_t,[],2); fsvm_t=C(fsvm_t);
          [e,frlsc_t]=max(results(R).frlsc_t,[],2); frlsc_t=C(frlsc_t);
        end
   end
   tt=tt+toc;
   
   cm=confusion(fsvm,Y(U)); results(R).cm_svm=cm; 
   results(R).err_svm=100*(1-sum(diag(cm))/sum(cm(:)));
   cm=confusion(frlsc,Y(U)); results(R).cm_rlsc=cm; 
   results(R).err_rlsc=100*(1-sum(diag(cm))/sum(cm(:)));
        
   if exist('Xt','var')
        cm=confusion(fsvm_t,Yt); results(R).cm_svm_t=cm; 
        results(R).err_svm_t=100*(1-sum(diag(cm))/sum(cm(:)));
        cm=confusion(frlsc_t,Yt); results(R).cm_rlsc_t=cm; 
        results(R).err_rlsc_t=100*(1-sum(diag(cm))/sum(cm(:)));
   end
        
% fprintf(1,'split=%d LapSVM (transduction) err = %f \n',R, results(R).err_svm);
% fprintf(1,'split=%d LapRLS (transduction) err = %f \n',R, results(R).err_rlsc);

     
if exist('Xt','var')
%     fprintf(1,'split=%d LapSVM (out-of-sample) err = %f\n',R, results(R).err_svm_t);
%     fprintf(1,'split=%d LapRLS (out-of-sample) err = %f\n',R, results(R).err_rlsc_t);
end


end



% fprintf(1,'\n\n');
% disp('LapSVM (transduction) mean confusion matrix');
% disp(round(mean(reshape(vertcat(results.cm_svm)',[size(results(1).cm_svm,1) size(results(1).cm_svm,1) length(results)]),3)));
% disp('LapRLS (transduction) mean confusion matrix');
% disp(round(mean(reshape(vertcat(results.cm_rlsc)',[size(results(1).cm_rlsc,1) size(results(1).cm_rlsc,1) length(results)]),3)));
% fprintf(1,'LapSVM (transduction mean(std)) err = %f (%f) \n',mean(vertcat(results.err_svm)),std(vertcat(results.err_svm)));  
% fprintf(1,'LapRLS (transduction mean(std)) err = %f (%f)  \n',mean(vertcat(results.err_rlsc)),std(vertcat(results.err_rlsc)));
% if exist('Xt','var')
%     fprintf(1,'\n\n');
%     disp('LapSVM (out-of-sample) mean confusion matrix');
%     disp(round(mean(reshape(vertcat(results.cm_svm_t)',[size(results(1).cm_svm_t,1) size(results(1).cm_svm_t,1) length(results)]),3)));
%     disp('LapRLS (out-of-sample) mean confusion matrix');
%     disp(round(mean(reshape(vertcat(results.cm_rlsc_t)',[size(results(1).cm_rlsc_t,1) size(results(1).cm_rlsc_t,1) length(results)]),3)));
%     fprintf(1,'LapSVM (out-of-sample mean(std)) err = %f (%f)\n',mean(vertcat(results.err_svm_t)), std(vertcat(results.err_svm_t)));  
%     fprintf(1,'LapRLS (out-of-sample mean(std)) err = %f (%f)\n',mean(vertcat(results.err_rlsc_t)),std(vertcat(results.err_rlsc_t)));
% end
labsvm=fsvm_t;
labrls=frlsc_t;
fprintf('MR time for prediction: %.02f\n',tt)
  
function [f1,b]=adjustbias(f,bias)
     jj=ceil((1-bias)*length(f));
     g=sort(f);
     b=0.5*(g(jj)+g(jj+1));
     f1=f-b;
     