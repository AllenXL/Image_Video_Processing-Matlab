%(C) Du Tran dutran2@uiuc.edu 2008
function vlabels = get_vid(l)
cur_id = 1;
n = size(l,2);
vlabels = zeros(1,n,'uint16');
cur_name = parse_name(char(l(1)));
for i=1:n
    tmp = parse_name(char(l(i)));
    if ~strcmp(tmp,cur_name)
        cur_name = tmp;
        cur_id = cur_id + 1;
    end
    vlabels(i) = cur_id;
end

function str = parse_name(s)
p = strfind(s,'/');
k = size(p,2);
str = s(p(k-1)+1:p(k)-1);