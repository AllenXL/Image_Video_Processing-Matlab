function lab=NBClassifier(X_T, lab_T, X_U,sigma)
% Naive Bayes classifier
% X_T: training set, DxN
% lab_T: label of training samples
if ~isvector(lab_T)
    error('labels must be a one dimension vector');
end
if size(X_T,2) ~= length(lab_T)
    X_T=X_T';
    X_U=X_U';
end
labels=lab_T;
NL=length(labels);
CL=unique(labels);
CN=length(CL);
prior=zeros(CN,1);
for k=1:CN
    prior(k)=sum(labels==CL(k));
end
if nargin>3
    nb = NaiveBayes.fit(X_T', labels, 'Prior',prior/NL, 'Distribution','kernel','KSWidth',sigma);
else
    nb = NaiveBayes.fit(X_T', labels, 'Prior',prior/NL, 'Distribution','kernel');
end
tic
lab = predict(nb,X_U','HandleMissing','on');
fprintf('NB time for prediction: %.02f\n',toc)
