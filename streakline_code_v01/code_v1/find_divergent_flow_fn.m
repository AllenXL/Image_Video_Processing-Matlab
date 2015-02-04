function find_divergent_flow_fn(u_new,v_new,xmesh,ymesh,xfmat,yfmat)

% compute potentials
[phi,psi,w_so,w_ir]= compute_phi_psi(u_new,v_new);
% find peaks
F = phi2peaks(phi,0.033);

% the regions size
bx_size = [30 30];

[gx,nouse]= gradient(xfmat);
[gy,nouse]= gradient(yfmat);
value = zeros(size(F,1),1);
% thresh = .1 ; %
thresh = -.1 ; % threshold

figure(2)
imagesc(phi), hold on
jump  = 10;
h=quiver(xmesh(1:jump:end,1:jump:end),ymesh(1:jump:end,1:jump:end),u_new(1:jump:end,1:jump:end),v_new(1:jump:end,1:jump:end),'AutoScaleFactor',.9,'LineWidth',1.5,'Color',[0 0 0])
for i = 1:size(F,1)
    W = [F(i,1)-bx_size(1)/2,F(i,2)-bx_size(2)/2,bx_size(1),bx_size(2)];
    Xs = imcrop(xmesh,W);
    Xs(Xs>max(xmesh(:))) = max(xmesh(:));
    Xs(Xs<1) = 1;
    Ys = imcrop(ymesh,W);
    Ys(Ys>max(ymesh(:))) = max(ymesh(:));
    Ys(Ys<1) = 1;
    inds =sub2ind(size(xmesh),Ys(:),Xs(:));
    
    origins =[xfmat(inds,1)';yfmat(inds,1)'];
    dist_vecs = origins - repmat(F(i,1:2)',1,length(inds(:)));
    for j = 1:size(gx,2)
        streak_vecs =[gy(inds,j)';gy(inds,j)'];
        s=sum(dist_vecs.*streak_vecs) ./ (eps+ sqrt(sum(streak_vecs.^2).*sum(dist_vecs.^2)));
        value(i) = value(i) + sum(s);
    end;
    value(i) = value(i)./(length(inds)*size(gx,2));
    
    
    h=rectangle('Curvature', [1 1], 'Position',W,'LineWidth',2);
    
    if value(i) > thresh
        set(h,'EdgeColor',[1 0 0 ]);
        seh=text(F(i,1),F(i,2),sprintf('Divergent Region'),'BackgroundColor',[ 1 1 1])
    elseif value(i) <= thresh
        set(h,'EdgeColor',[0 1 0 ]);
        text(F(i,1),F(i,2),sprintf('Convergent Region'),'BackgroundColor',[ 1 1 1])
    end;
    plot(F(i,1),F(i,2),'k*','LineWidth',3)
    axis ij
    
    
end;
