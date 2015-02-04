function lab=DTClassifier(X_T,lab_T, X_U)
%decision tree classifier

if ~isvector(lab_T)
    error('labels must be a one dimension vector');
end
if size(X_T,2) ~= length(lab_T)
    X_T=X_T';
    X_U=X_U';
end

tree = ClassificationTree.fit(X_T',lab_T);

[~,~,~,bestlevel] = cvLoss(tree,...
    'subtrees','all','treesize','min');

if bestlevel>=2
    tree = prune(tree,'Level',bestlevel);
end
tic
lab = predict(tree,X_U');
fprintf('DT time for prediction: %.02f\n',toc)