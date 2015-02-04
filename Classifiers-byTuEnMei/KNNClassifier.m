function lab=KNNClassifier(X_T,lab_T,X_U, NumNeighbors)

if nargin<4
    NumNeighbors=3;
end

if ~isvector(lab_T)
    error('labels must be a one dimension vector');
end
if size(X_T,2) ~= length(lab_T)
    X_T=X_T';
    X_U=X_U';
end

NL=length(lab_T);
CL=unique(lab_T);
CN=length(CL);
prior=zeros(CN,1);
for k=1:CN
    prior(k)=sum(lab_T==CL(k));
end

mdl = ClassificationKNN.fit(X_T',lab_T,'Prior',prior/NL,'NumNeighbors',NumNeighbors);
tic
lab = predict(mdl,X_U');
fprintf('KNN time for prediction: %.02f\n',toc)