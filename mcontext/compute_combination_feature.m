%(C) Du Tran dutran2@uiuc.edu 2008
function [flow_feature sil_feature] = compute_combination_feature(v0, u0, b0, sbox, angel_matrix, k, scale)
b1 = b0(sbox(2):sbox(4),sbox(1):sbox(3));
v1 = v0(sbox(2):sbox(4),sbox(1):sbox(3));
u1 = u0(sbox(2):sbox(4),sbox(1):sbox(3));

h = size(b1,1);
w = size(b1,2);
if h > w   %长的一边固定为120，长宽比不变
    h1 = scale;
    w1 = w/h*scale;
else
    w1 = scale;
    h1 = h/w*scale;
end
u2 = zeros(scale,scale,'double');
v2 = zeros(scale,scale,'double');
b2 = zeros(scale,scale,'uint8');

b1 = imresize(b1, [h1 w1], 'bilinear');
v1 = imresize(v1, [h1 w1], 'bilinear');
u1 = imresize(u1, [h1 w1], 'bilinear');
h1 = size(b1,1);
w1 = size(b1,2);
scale2 = scale/2; 
haft = int16(w1/2);
u2(scale-h1+1:scale,scale2-haft+1:scale2-haft+w1)=u1; %box中的灰度值，复制到120*120的模板中，底部居中
v2(scale-h1+1:scale,scale2-haft+1:scale2-haft+w1)=v1;
b2(scale-h1+1:scale,scale2-haft+1:scale2-haft+w1)=b1;

sil_feature = compute_du_feature(b2,k,angel_matrix,1,18);  %计算直方图
f_v = compute_du_feature(v2,k,angel_matrix,0,18);
f_u = compute_du_feature(u2,k,angel_matrix,0,18);
sil_feature = normalize_vector(sil_feature);
flow_feature = normalize_vector([f_v f_u]);


