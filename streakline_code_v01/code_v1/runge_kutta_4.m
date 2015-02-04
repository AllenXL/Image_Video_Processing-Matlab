function [xflowmap,yflowmap]=runge_kutta_4(xflowmap,yflowmap,N,u,v,un,vn,xmesh,ymesh,h)

% X part
k1 = h*interp2(xmesh, ymesh, u, xflowmap{N-1}, yflowmap{N-1}, 'linear', 0);
        k1(isnan(k1))= 0;
       
k2c = h*interp2(xmesh, ymesh, u, xflowmap{ N-1}+(1/4)*k1, yflowmap{ N-1}+(1/4)*k1, 'linear', 0);
        k2c(isnan(k2c))= 0;
k2n = h*interp2(xmesh, ymesh, un, xflowmap{ N-1}+(1/4)*k1, yflowmap{ N-1}+(1/4)*k1, 'linear', 0);
        k2n(isnan(k2n))= 0;

k2 = k2c + (k2n-k2c)*(h/4);

k3c = h*interp2(xmesh, ymesh, u, xflowmap{ N-1}+(3/32)*k1+(9/32)*k2, yflowmap{ N-1}+(3/32)*k1+(9/32)*k2, 'linear', 0);
        k3c(isnan(k3c))= 0;

k3n = h*interp2(xmesh, ymesh, un, xflowmap{ N-1}+(3/32)*k1+(9/32)*k2, yflowmap{ N-1}+(3/32)*k1+(9/32)*k2, 'linear', 0);
        k3n(isnan(k3n))= 0;

k3 = k3c + (k3n-k3c)*(3*h/8);

k4c = h*interp2(xmesh, ymesh, u, xflowmap{ N-1}+(1932/2197)*k1-(7200/2197)*k2+(7296/2197)*k3, yflowmap{ N-1}+(1932/2197)*k1-(7200/2197)*k2+(7296/2197)*k3, 'linear', 0);
        k4c(isnan(k4c))= 0;
k4n = h*interp2(xmesh, ymesh, un, xflowmap{ N-1}+(1932/2197)*k1-(7200/2197)*k2+(7296/2197)*k3, yflowmap{ N-1}+(1932/2197)*k1-(7200/2197)*k2+(7296/2197)*k3, 'linear', 0);
        k4n(isnan(k4n))= 0;

k4 = k4c + (k4n-k4c)*(12*h/13);

k5c = h*interp2(xmesh, ymesh, u, xflowmap{ N-1}+(439/216)*k1-8*k2+(3680/513)*k3-(845/4104)*k4, yflowmap{ N-1}+(439/216)*k1-8*k2+(3680/513)*k3-(845/4104)*k4, 'linear', 0);
        k5c(isnan(k5c))= 0;

k5n = h*interp2(xmesh, ymesh, un, xflowmap{ N-1}+(439/216)*k1-8*k2+(3680/513)*k3-(845/4104)*k4, yflowmap{ N-1}+(439/216)*k1-8*k2+(3680/513)*k3-(845/4104)*k4, 'linear', 0);
        k5n(isnan(k5n))= 0;

k5 = k5c + (k5n-k5c)*(h);

%             k6c = h*interp2(xmesh, ymesh, u, xflowmap{ N-1}-(8/27)*k1+2*k2-(3544/2565)*k3+(1859/4104)*k4-(11/40)*k5, yflowmap{ N-1}-(8/27)*k1+2*k2-(3544/2565)*k3+(1859/4104)*k4-(11/40)*k5, 'linear', 0);
%             k6n = h*interp2(xmesh, ymesh, un, xflowmap{ N-1}-(8/27)*k1+2*k2-(3544/2565)*k3+(1859/4104)*k4-(11/40)*k5, yflowmap{ N-1}-(8/27)*k1+2*k2-(3544/2565)*k3+(1859/4104)*k4-(11/40)*k5, 'linear', 0);
%             k6 = k6c + (k6n-k6c)*(h/2);

xflowmap{N} = xflowmap{N-1} + (25/216)*k1 + (1408/2565)*k3 + (2197/4101)*k4 - (1/5)*k5;

% Y part
k1 = h*interp2(xmesh, ymesh, v, xflowmap{N-1}, yflowmap{N-1}, 'linear', 0);
        k1(isnan(k1))= 0;

k2c = h*interp2(xmesh, ymesh, v, xflowmap{ N-1}+(1/4)*k1, yflowmap{ N-1}+(1/4)*k1, 'linear', 0);
        k2c(isnan(k2c))= 0;

k2n = h*interp2(xmesh, ymesh, vn, xflowmap{ N-1}+(1/4)*k1, yflowmap{ N-1}+(1/4)*k1, 'linear', 0);
        k2n(isnan(k2n))= 0;

k2 = k2c + (k2n-k2c)*(h/4);

k3c = h*interp2(xmesh, ymesh, v, xflowmap{ N-1}+(3/32)*k1+(9/32)*k2, yflowmap{ N-1}+(3/32)*k1+(9/32)*k2, 'linear', 0);
        k3c(isnan(k3c))= 0;

k3n = h*interp2(xmesh, ymesh, vn, xflowmap{ N-1}+(3/32)*k1+(9/32)*k2, yflowmap{ N-1}+(3/32)*k1+(9/32)*k2, 'linear', 0);
        k3n(isnan(k3n))= 0;

k3 = k3c + (k3n-k3c)*(3*h/8);

k4c = h*interp2(xmesh, ymesh, v, xflowmap{ N-1}+(1932/2197)*k1-(7200/2197)*k2+(7296/2197)*k3, yflowmap{ N-1}+(1932/2197)*k1-(7200/2197)*k2+(7296/2197)*k3, 'linear', 0);
        k4c(isnan(k4c))= 0;

k4n = h*interp2(xmesh, ymesh, vn, xflowmap{ N-1}+(1932/2197)*k1-(7200/2197)*k2+(7296/2197)*k3, yflowmap{ N-1}+(1932/2197)*k1-(7200/2197)*k2+(7296/2197)*k3, 'linear', 0);
        k4n(isnan(k4n))= 0;

k4 = k4c + (k4n-k4c)*(12*h/13);

k5c = h*interp2(xmesh, ymesh, v, xflowmap{ N-1}+(439/216)*k1-8*k2+(3680/513)*k3-(845/4104)*k4, yflowmap{ N-1}+(439/216)*k1-8*k2+(3680/513)*k3-(845/4104)*k4, 'linear', 0);
        k5c(isnan(k5c))= 0;

k5n = h*interp2(xmesh, ymesh, vn, xflowmap{ N-1}+(439/216)*k1-8*k2+(3680/513)*k3-(845/4104)*k4, yflowmap{ N-1}+(439/216)*k1-8*k2+(3680/513)*k3-(845/4104)*k4, 'linear', 0);
        k5n(isnan(k5n))= 0;

k5 = k5c + (k5n-k5c)*(h);

%             k6c = h*interp2(xmesh, ymesh, v, xflowmap{ N-1}-(8/27)*k1+2*k2-(3544/2565)*k3+(1859/4104)*k4-(11/40)*k5, yflowmap{ N-1}-(8/27)*k1+2*k2-(3544/2565)*k3+(1859/4104)*k4-(11/40)*k5, 'linear', 0);
%             k6n = h*interp2(xmesh, ymesh, vn, xflowmap{ N-1}-(8/27)*k1+2*k2-(3544/2565)*k3+(1859/4104)*k4-(11/40)*k5, yflowmap{ N-1}-(8/27)*k1+2*k2-(3544/2565)*k3+(1859/4104)*k4-(11/40)*k5, 'linear', 0);
%             k6 = k6c + (k6n-k6c)*(h/2);

yflowmap{N} = yflowmap{N-1} + (25/216)*k1 + (1408/2565)*k3 + (2197/4101)*k4 - (1/5)*k5;
