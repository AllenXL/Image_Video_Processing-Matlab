function [ extr ] = checkExtrema( ex1, ex2, ex3 )
[x,y] = size(ex1);
extre = zeros(x,y);
for i = 1:x,
    for j = 1:y,
        if ((ex2(i,j) == ex1(i,j))||(ex3(i,j) == ex1(i,j))||(ex2(i,j) == ex3(i,j))),
            extre(i,j) = ex1(i,j);   
        end
    end
end
extr = extre;
end

