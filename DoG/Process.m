% DoG Process
% -----------------------------------------------------------
% img - Input Image
% sig1, sig2 - Sigma values
function [ out_img ] = Process( img, sig1, sig2, size )
x = size;

ksig1 = fspecial('gaussian', [x x], sig1);
ksig2 = fspecial('gaussian', [x x], sig2);

A = imfilter(img, ksig1);
B = imfilter(img, ksig2);
out_img = A-B;

end

