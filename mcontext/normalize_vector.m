%(C) Du Tran dutran2@uiuc.edu 2008
function f = normalize_vector(a)
n = norm(a);
if n > 0
    f = a/n;
else
    f = a;
end