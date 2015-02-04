function [phi,psi,w_so,w_ir]= compute_phi_psi(px,py)
   
    n = 1;
    Lx = n.*pi; Ly = n.*pi;
 [w_so,w_ir] = compute_irro_solen(size(py,2),size(px,1),px,py,Lx,Ly);
    
    
    phi = .5*(cumsum(w_ir.x,2)+cumsum(w_ir.y,1)+repmat(cumsum(w_ir.x(1,:),2),size(px,1),1)+repmat(cumsum(w_ir.y(:,1),1),1,size(px,2)));
    psi = .5*(cumsum(w_so.x,1)-cumsum(w_so.y,2)+repmat(cumsum(w_so.x(:,1),1),1,size(px,2))-repmat(cumsum(w_so.y(1,:),2),size(px,1),1));
    
    