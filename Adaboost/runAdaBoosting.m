%%
% File Name: runAdaBoosing
% This is the "main" it runs the ada boost algorithm and for different sizes of
% training sets. It provides a graph of the errors according to the size of the
% training set.
%%
%!Important: run this commands in the Matlab "Command Window" before you run  
%open usps.mat;
%load usps.mat;

function runAdaBoosting(train,train_label,test,test_label)
disp('run adaboost with cycles=100');
step=100;
cycles=100;
for m=step:step:1000
    disp(m);
    boost=adaBoost(train(1:m,:),train_label(1:m),cycles);
    [errorTrain(m/step),errorTest(m/step)]=getError(boost,train(1:m,:),train_label(1:m),test,test_label);
end

% image figure No. 1
f1h = figure;   
% set various properties and display images
set(f1h,'units','normalized');  
set(f1h,'position',[0 0 0.5 1]); 
set(f1h,'numbertitle','off');
titleName='adaboost first work';
set(f1h,'name',titleName);
X = step : step : 1000 ;
plot(X,errorTrain,'r+:',X,errorTest,'bd-');
title('adaboost vs. size of train file','Fontsize',16);
xlabel('num of samples (on train file)');
ylabel('Errrors rate');
legend('error on train file','error on test file');
grid on;
clear errorTrain;
clear errorTest;
disp('run adaboost algorothm with different boosting');

step=20;
maxCycles=100;
for cycles=step:step:maxCycles
    disp(cycles);
    boost=adaBoost(train,train_label,cycles);
    [errorTrain(cycles/step),errorTest(cycles/step)]=getError(boost,train,train_label,test,test_label);
    clear boost;
end

 % image figure No. 2
f2h = figure;      
% set various properties and display images
set(f2h,'units','normalized');  
set(f2h,'position',[0 0 0.5 1]); 
set(f2h,'numbertitle','off');
set(f2h,'name',titleName);
X = step : step : maxCycles ;
plot(X,errorTrain,'r+:',X,errorTest,'bd-');
title('adaboost vs. boosting cycles','Fontsize',16);
xlabel('num of samples (on train file)');
ylabel('Errrors rate');
legend('error on train file','error on test file');
grid on;


         
        
        