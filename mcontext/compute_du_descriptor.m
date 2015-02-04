%(C) Du Tran dutran2@uiuc.edu 2008
function f = compute_du_descriptor(subim, angel_matrix, opt, N) %计算直方图向量(1*N)
f = zeros(1,N);
for i = 1:size(subim,1)
    for j = 1:size(subim,2)
        ang = angel_matrix(i,j);
        if opt == 1
            f(ang) = f(ang) + (subim(i,j)>0); %对于silhouette，统计角度区间中，非零像素点的个数
        else
            f(ang) = f(ang) + subim(i,j); %对于光流图，统计角度区间中，所有像素点值之和
        end
    end;
end;