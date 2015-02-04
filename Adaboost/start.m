function start
open usps.mat;
load usps.mat;
runAdaBoosting(train,train_label,test,test_label)