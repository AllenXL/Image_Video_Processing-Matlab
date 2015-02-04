function auc = ROC_Curve(deci,label_y)

[val,ind] = sort(deci,'descend');

roc_y = label_y(ind);

stack_x = cumsum(roc_y == -1)/sum(roc_y == -1);  %FPR

stack_y = cumsum(roc_y == 1)/sum(roc_y == 1);    %TPR

auc = sum((stack_x(2:length(roc_y),1)-stack_x(1:length(roc_y)-1,1)).*stack_y(2:length(roc_y),1));

%Comment the above lines if using perfcurve of statistics toolbox

%[stack_x,stack_y,thre,auc]=perfcurve(label_y,deci,1);

p = plot(stack_x,stack_y);grid on;

set(p,'Color','red');

xlabel('FPR');

ylabel('TPR');

set(gca,'FontSize',10);

title(['ROC curve (AUC = ' num2str(auc) ' )'], 'FontSize',14);
set(get(gca,'XLabel'),'FontSize',14);
set(get(gca,'YLabel'),'FontSize',14);


end


