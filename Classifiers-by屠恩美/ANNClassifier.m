function lab=ANNClassifier(X_T, lab_T, X_U, NNLayers)
% X_T: training set, DxN
% labels: label of training samples
% NNLayers: vector to specify how many neurons and how may layers, i.e. [3
% 4 5]means three layers, and neuron number of each layer is 3, 4 and 5.
if nargin<4
    NNLayers=min(100,max(ceil(size(X_T,1)/2),10));
end
if ~isvector(lab_T)
    error('labels must be a one dimension vector');
end
if size(X_T,2) ~= length(lab_T)
    X_T=X_T';
    X_U=X_U';
end
classes=unique(lab_T);
CN=length(classes);
inputs = X_T;
Yn=zeros(size(X_T,2),CN);

for k=1:length(lab_T)
    for c=1:length(classes)
        if lab_T(k)==classes(c)
            Yn(k,c)=1;
        end
    end
end
targets = Yn';
net = patternnet(NNLayers);
net.trainFcn='trainscg';
net.trainParam.showWindow=false;
net.divideParam.trainRatio = 1;
net.divideParam.valRatio = 0;
net.divideParam.testRatio = 0;
net.trainParam.epochs=500;
net = train(net,inputs,targets);
tic
outputs = net(X_U);
[~,lab]=max(outputs,[],1);

lab=lab'-1+min(lab_T);
fprintf('ANN time for prediction: %.02f\n',toc)