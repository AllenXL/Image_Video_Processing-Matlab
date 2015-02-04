%%
% file: getError.m
% This function calculates the error returned by the current run of the weak learner.
%%
function [errorTrain,errorTest]=getError(boost,train,train_label,test,test_label)
    disp('run getError');
    d=size(boost);
    num=size(train);
    prediction=zeros(num(1),1);
    % geting the train error
    for h=1:d(1)
        prediction=prediction-log(boost(h,1))*(train(:,boost(h,2))>=boost(h,3));
    end
    temp=-sum(log(boost(:,1)))/2;
    errorTrain=sum(abs((train_label>=5)-(prediction>=temp)))/num(1);
    prediction=zeros(1000,1);
    % geting the test error
    for h=1:d(1)
        prediction=prediction-log(boost(h,1))*(test(:,boost(h,2))>=boost(h,3));
    end
    errorTest=sum(abs((test_label>=5)-(prediction>=temp)))/1000;
