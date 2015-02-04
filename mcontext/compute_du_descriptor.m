%(C) Du Tran dutran2@uiuc.edu 2008
function f = compute_du_descriptor(subim, angel_matrix, opt, N) %����ֱ��ͼ����(1*N)
f = zeros(1,N);
for i = 1:size(subim,1)
    for j = 1:size(subim,2)
        ang = angel_matrix(i,j);
        if opt == 1
            f(ang) = f(ang) + (subim(i,j)>0); %����silhouette��ͳ�ƽǶ������У��������ص�ĸ���
        else
            f(ang) = f(ang) + subim(i,j); %���ڹ���ͼ��ͳ�ƽǶ������У��������ص�ֵ֮��
        end
    end;
end;