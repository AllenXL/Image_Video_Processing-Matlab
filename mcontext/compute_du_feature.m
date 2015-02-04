%(C) Du Tran dutran2@uiuc.edu 2008
function fea = compute_du_feature(im, k, angel_matrix, opt,N)
s = size(im)/k;
fea = [];
for i = 1:k  % k*kµÄ×Ó´°¿Ú
    for j = 1:k
        subim = im((i-1)*s(1)+1:i*s(1),(j-1)*s(2)+1:j*s(2));
        if size(subim,1) > size(angel_matrix,1) || size(subim,2) > size(angel_matrix,2)
            disp('there is a bug');
        end
            
        des = compute_du_descriptor(subim, angel_matrix, opt,N);
        fea = [fea des];
    end;
end;
