function x_avg = vector_mean_filter( x, n )
%x is 1*N vector, ������x����ֵ�˲�, n��ʾȡǰ��n������ƽ��
s=length(x);
x1=x;
for i=0:n-2
    y=[x(1:n-1), x(n-1-i:end-1-i)];
    x1=x1+y;
end

x_avg = x1/n;

end

