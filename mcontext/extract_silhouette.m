%(C) Du Tran dutran2@uiuc.edu 2008
function p = extract_silhouette(im)
h = sum(im');
v = sum(im);
[x x0] = max(v);
[c y0] = max(h);

p = zeros(1,4);
p(1) = x0;
p(2) = y0;
while (p(1)>1) && (v(p(1))>0)
    p(1) = p(1) - 1;
end
while (p(2)>1) && (h(p(2))>0)
    p(2) = p(2) - 1;
end

p(3) = x0;
p(4) = y0;
while (p(3)<size(v,2)) && (v(p(3))>0)
    p(3) = p(3) + 1;
end
while (p(4)<size(h,2)) && (h(p(4))>0)
    p(4) = p(4) + 1;
end
