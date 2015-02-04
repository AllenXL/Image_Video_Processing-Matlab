%(C) Du Tran dutran2@uiuc.edu 2008
function [pr cu ne] = get_5windows(f, i, vl) %previous current next window
zr = zeros(1,size(f,2));
pr = [];
for t=-7:1:-3  
    if (i+t>0)&&(vl(i+t)==vl(i))
        pr = [pr f(i+t,:)];
    else
        pr = [pr zr]; %不够用零向量填充
    end
end
ne = [];
for t=3:1:7
    if (i+t<=size(f,1))&&(vl(i+t)==vl(i))
        ne = [ne f(i+t,:)];
    else
        ne = [ne zr];
    end
end
cu = [];
for t=[-2 -1]
    if (i+t>0)&&(vl(i+t)==vl(i))
        cu = [cu f(i+t,:)];
    else
        cu = [cu zr];
    end
end
cu = [cu f(i,:)];
for t=[1 2]
    if (i+t<=size(f,1))&&(vl(i+t)==vl(i))
        cu = [cu f(i+t,:)];
    else
        cu = [cu zr];
    end
end

