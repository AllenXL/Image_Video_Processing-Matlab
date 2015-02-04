%(C) Du Tran dutran2@uiuc.edu 2008
function do_pca_on_frame_feature(feature_dir)
fn = sprintf('%sflow_feature.mat',feature_dir);
load(fn,'f');
fn = sprintf('%ssil_feature.mat',feature_dir);
load(fn,'s');
fn = sprintf('%slist.mat',feature_dir);
load(fn,'l');

vl = get_vid(l); %标记样本
fn = sprintf('%svlabels.mat',feature_dir);
save(fn,'vl'); 

feature = [f s];
clear ('l');
n = size(f,1);
f5 = [];
for i=1:n-4
    if vl(i+4) == vl(i)
        f5 = [f5; feature(i,:) feature(i+1,:) feature(i+2,:) feature(i+3,:) feature(i+4,:)];
    end
end
fn = sprintf('%sf5.mat',feature_dir);
save(fn, 'f5');
x = f5 - ones(size(f5,1),1)*mean(f5); %每个元素减去该列的平均值
clear('f5');
[pc, score, latent] = princomp(x); %PCA, pc：each column containing coefficients for one principal component
clear('x');
pc50 = pc(:,1:50); %取前50组系数，比如x的某一行为a,a*pc的一列，就组合出a的一个主成分(就是特征抽取),
                   %50组系数就有50个主成分，原数据a将成50维
fn = sprintf('%spc50.mat',feature_dir);
save(fn,'pc50');
clear('score');
clear('latent');

win_feature = [];
for i=1:size(f,1)
    [prev_win cur_win next_win] = get_5windows(feature, i, vl);
    w = f(i,:);
    f_temp = cur_win*pc50;
    w = [w f_temp];
    f_temp = prev_win*pc50(:,1:10);
    w = [w f_temp];
    f_temp = next_win*pc50(:,1:10);
    w = [w f_temp];
    win_feature = [win_feature; w];
end
fn = sprintf('%swin_feature.mat',feature_dir);
save(fn,'win_feature');
