function mapped_angles = map_angles(u,v,n)

L1 = 0:n;
L2 = n-1:-1:1;

colorwheel = [L1,L2]';
ncols = length(colorwheel);
a = atan2(-v, -u)/pi;

fk = (a+1) /2 * (ncols-1) + 1;  % -1~1 maped to 1~ncols

k0 = floor(fk);                 % 1, 2, ..., ncols

k1 = k0+1;
k1(k1==ncols+1) = 1;

f = fk - k0;

% for i = 1:size(colorwheel,2)
tmp = colorwheel;
col0 = tmp(k0)/(n);
col1 = tmp(k1)/(n);
mapped_angles = (1-f).*col0 + f.*col1;