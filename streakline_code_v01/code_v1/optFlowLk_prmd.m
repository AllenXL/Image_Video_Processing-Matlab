function [u,v,reliab]=optFlowLk_prmd( I1, I2, winN, ...
    winSig, sigma, thr, show ,levels)
% Calculate optical flow using Lucas & Kanade.  Fast, parallel code.
%
% [Vx,Vy,reliab]=optFlowLk( I1, I2, winN, ...
%   winSig, sigma, thr, show )

[ I1pyre, I2pyre ] = pyramidInit( I1, I2, levels, winN );


for i = levels:-1:1
    if i <levels
        
        I1_new = I1pyre{i};
        I2_new = imWarp( u, v, I2pyre{i} );
    else
        I1_new = I1pyre{i};
        I2_new = I2pyre{i};
        u = 0*I1_new;
        v = 0*I1_new;
    end;
    
    [Vx,Vy,reliab]=optFlowLk( I1_new, I2_new, winN, winSig, sigma, thr, show );
    u = u + Vx;
    v = v + Vy;
    if i ~= 1
        u = 2 * imresize(u,size(I1pyre{i-1}),'bilinear');
        v = 2 * imresize(v,size(I1pyre{i-1}),'bilinear');
    end
    
    
end;