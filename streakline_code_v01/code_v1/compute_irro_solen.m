function [w_so,w_ir] = compute_irro_solen(Nx,Ny,u,v,Lx,Ly)
% Function to compute irrotational and solenoidal components of a
% non-laminar flow using inverse Fourier transform.
% Nx, Ny are number of grid points in x and y
% Lx and Ly are domain lengths in x and y
% % % specify domain

% Lx = 2.*pi; Ly = 2.*pi; % domain size
% Fourier wavenumber operators
dx = (-Nx/2:Nx/2-1)  * (2*pi/Lx);
dy = (-Ny/2:Ny/2-1)  * (2*pi/Ly);
[k.x k.y] = meshgrid(dx,dy);
k.x = fftshift(k.x);   k.y = fftshift(k.y);

% compute Fourier transform of the flow
w_hat.x = fft2(u);
w_hat.y = fft2(v);
 

% irrotational part
tmp = (k.x.^2+k.y.^2);
ind = find(tmp==0);
tmp(ind) = 1;
% tmp(floor(Ny/2)+1,floor(Nx/2)+1) = 1;
tmp = 1./tmp;
tmp(ind) = 1;

% tmp(floor(Ny/2)+1,floor(Nx/2)+1) = 0;
k_normal.x = k.x.*tmp;
k_normal.y = k.y.*tmp;
tmp = (k.x.*w_hat.x+k.y.*w_hat.y);
w_hat_ir.x = tmp.*k_normal.x;
w_hat_ir.y = tmp.*k_normal.y;
w_ir.x = real(ifft2(w_hat_ir.x));
w_ir.y = real(ifft2(w_hat_ir.y));


%% solenoidal
tmp2 = (-k.y.*w_hat.x+k.x.*w_hat.y);
w_hat_so.x = tmp2.*(-1).*k_normal.y;
w_hat_so.y = tmp2.*k_normal.x;


w_so.x = real(ifft2(w_hat_so.x));
w_so.y = real(ifft2(w_hat_so.y));

% DZi = DZ;  DZi(1,1) = 1;  DZi = 1./DZi;  DZi(1,1) = 0;
% now invert for streamfunction
% zetaT = fft2(zeta); zetaT(1,1) = 0; % spectral vorticity
% psiT  = DZi.*zetaT; % spectral streamfunction



% % psi = real(ifft2(psiT)); % grid point streamfunction
% % check
% check = real(ifft2(DZ.*fft2(psi))); % del^2(psi)
% clc;
% disp(['max error = ',num2str(max(max(abs(check-zeta))))])

