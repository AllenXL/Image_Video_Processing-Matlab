%(C) Du Tran dutran2@uiuc.edu 2008
function m = compute_angle_matrix(s,N)
o = s/2;
a1 = 360/N;
m = zeros(s(2),s(1));
for i = 1:s(2)
    for j = 1:s(1)
        ang = int16(myangle(o(1), o(2), j, i)); %����õ������ĽǶ�
        ang1 = div(ang,a1)+1; %���ýǶ��������Ƕ�����
        if (ang1>N)
            ang1 = N;
        end
        m(i,j) = ang1;
    end;
end;

