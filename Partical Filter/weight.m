function w=weight(p,q,sita)
% given the standard deviaton sita, and the Bhattacharyya distacne d of two
% color hisgrams(one of them is the target's, the other is the sample's),
% the function return the sample's coresponding weight.
% This weighting data is the base for the tracking algorithem
m=512;
simi=0;
for i=1:1:m;
 simi=simi+(p(i)*q(i))^0.5;  %%其中q是目标模板的颜色直方图，p是以某一中心候选区域的颜色直方图，通过Bhattacharyya系数来衡量她们的相似程度
end
d=(1-simi)^0.5;   %%相应的Bhattacharyya距离，作为该粒子的观测

w=(1/(sita*(2*pi)^0.5))*exp(-(d^2)/(2*sita^2));   %%p（z/x）=(1/(sita*(2*pi)^0.5))*exp(-(d^2)/(2*sita^2))为该粒子的观测概率，均方差sita通常取为0.2
%w=simi;   %更有利于理想实验，不同背景的为零

return
