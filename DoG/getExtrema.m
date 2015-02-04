function [out_img] = getExtrema (A, B, C, thresh)
[x,y] = size(A);

extr = zeros(x,y);

for i = 2:x-1,
    for j = 2:y-1,
        block = ([A(i-1:i+1, j-1:j+1); B(i-1:i+1, j-1:j+1); C(i-1:i+1 ,j-1:j+1)]);
        [c,index] = max(block(:));
        if (index == 14),
            if (c>thresh),
                extr(i,j)=1;
            end
        end
        [c,index] = min(block(:));
        if (index == 14),
            if (c<-thresh),
                extr(i,j)=-1;
            end
        end           
    end 
end
out_img = extr;
end
