%(C) Du Tran dutran2@uiuc.edu 2008
function m = compute_angle_matrix(s,N)
o = s/2;
a1 = 360/N;
m = zeros(s(2),s(1));
for i = 1:s(2)
    for j = 1:s(1)
        ang = int16(myangle(o(1), o(2), j, i)); %计算该点所处的角度
        ang1 = div(ang,a1)+1; %将该角度量化到角度区间
        if (ang1>N)
            ang1 = N;
        end
        m(i,j) = ang1;
    end;
end;

