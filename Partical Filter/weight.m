function w=weight(p,q,sita)
% given the standard deviaton sita, and the Bhattacharyya distacne d of two
% color hisgrams(one of them is the target's, the other is the sample's),
% the function return the sample's coresponding weight.
% This weighting data is the base for the tracking algorithem
m=512;
simi=0;
for i=1:1:m;
 simi=simi+(p(i)*q(i))^0.5;  %%����q��Ŀ��ģ�����ɫֱ��ͼ��p����ĳһ���ĺ�ѡ�������ɫֱ��ͼ��ͨ��Bhattacharyyaϵ�����������ǵ����Ƴ̶�
end
d=(1-simi)^0.5;   %%��Ӧ��Bhattacharyya���룬��Ϊ�����ӵĹ۲�

w=(1/(sita*(2*pi)^0.5))*exp(-(d^2)/(2*sita^2));   %%p��z/x��=(1/(sita*(2*pi)^0.5))*exp(-(d^2)/(2*sita^2))Ϊ�����ӵĹ۲���ʣ�������sitaͨ��ȡΪ0.2
%w=simi;   %������������ʵ�飬��ͬ������Ϊ��

return
