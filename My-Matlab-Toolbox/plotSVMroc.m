
function AUC=plotSVMroc(true_labels,dec_values,classnumber)
% plotSVMroc
% by faruto
% Email:farutoliyang@gmail.com
% 2010.01.11
%%
if nargin == 2
    classnumber = 2;
end
%%
[X,Y,THRE,AUC,OPTROCPT,SUBY,SUBYNAMES] = ...
perfcurve(true_labels,dec_values(:,1),'1');
%AUC=1-AUC;
true_labels= [true_labels, 1 - true_labels];

len = length(true_labels);
label = zeros(1,classnumber);
label(1) = true_labels(1);
currentindex = 1;
for run = 2:len
    flag = 0;
    for class = 1:currentindex
        if true_labels(run) == label(class)  
            flag = 1;
        end
    end
    if flag == 1
        continue;
    else        
        label(currentindex+1) = true_labels(run);
        currentindex = currentindex + 1;
    end
end
%%
targets_true = zeros(classnumber,len);
outputs_predict = dec_values';
for class = 1:classnumber
    for run = 1:len
        if true_labels(run) == label(class)
            targets_true(class,run) = 1;
        end
    end
end
%% plot ROC curve
plotroc(targets_true,outputs_predict);
grid on;
%% plot ROC curve subplot
str = ['plotroc('];
for class = 1:classnumber
    
    str_temp = ['targets_true(',num2str(class),...
        ',:),','outputs_predict(',num2str(class),',:),',...
        '''class ','',num2str(class),'(label:',...
        num2str(label(class)),')''',','];
    
    str = [str str_temp];
    
end
str = str(1:end-1);
str = [str ')'];
eval(str);




