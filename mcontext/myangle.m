%(C) Du Tran dutran2@uiuc.edu 2008
function alpha = myangle(ox, oy, x, y) %ox,oyΪͼ���������꣬x,yΪһ�㣬��������õ�������ϵ�������Ƕ�
if (x == ox) && (y == oy)
    alpha = 0;
    return;
end;
if (x == ox)
    if (y < oy)
        alpha = 90;
    else
        alpha = 270;
    end;
else
    t = double(y-oy)/(x-ox);
    t = (atan(t)/pi)*180;
    if (t == 0)&&(x>ox)
        t = t +180;
    end;
    if t < 0
        t = t+180;
    end;
    if (y > oy)
        t = t + 180;
    end;
    alpha = t;
end;
