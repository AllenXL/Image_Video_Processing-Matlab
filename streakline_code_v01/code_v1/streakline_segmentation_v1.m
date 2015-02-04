close all
clear
warning off
%% main initialization of variables and paths
% addpath('FigureManagement')
addpath (genpath('piotr_toolbox'));
addpath('colorcodedopticalflow');
addpath('gridfitdir')


% do_init_shybuya % shybuya initialization
do_init_A_diffuse  %_diffuse % boston initialization

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% parameter initialization
img1 = imread([pth sprintf(['/%s' img_fileformat],prefix,1)]);
img1 = imresize(img1,RESIZE_FACTOR);
jump = 1;
[xmesh,ymesh] = meshgrid(1:jump:size(img1,2),1:jump:size(img1,1));
xflowmap{1} = xmesh;
yflowmap{1} = ymesh;

streak.gx = 0*xmesh(:);
streak.gy = 0*ymesh(:);


%% main loop
strt = 2;
for i = strt:length(d)-1
    %     figure(1)
    %     profile on
    fprintf('%d/%d\n',i,length(d));
    img1 = imread([pth sprintf(['/%s' img_fileformat],prefix,i-1)]);
    %     img1 = circshift(img1,[0 i 0]);
    
    img2 = imread([pth sprintf(['/%s' img_fileformat],prefix,i)]);
    img3 = imread([pth sprintf(['/%s' img_fileformat],prefix,i+1)]);
    
    
    img1 = imresize(img1,RESIZE_FACTOR);
    img2 = imresize(img2,RESIZE_FACTOR);
    img3 = imresize(img3,RESIZE_FACTOR);
    
    if OPTICAL_FLOW_SWITCH
        [px,py]=optFlowLk_prmd( double( rgb2gray(img1)),...
            double( rgb2gray(img2)), [], 2, .05, 3e-6, 0,2);
        [pxn,pyn]=optFlowLk_prmd( double( rgb2gray(img2)),...
            double( rgb2gray(img3)), [], 2, .05, 3e-6, 0,2);
    else
        v = load(sprintf('/video/OpticalFlow/OpticalFlow%04d.mat',i));
        px =imresize(v.u,[size(img1,1),size(img1,2)]);
        py =imresize(v.v,[size(img1,1),size(img1,2)]);
    end;
    
    
    if i ==strt
        streak.gx = px(:);
        streak.gy = py(:);
    end;
    
    r = min(i-strt+2,streak_len);
    
    % Forward advection
    for N  = r:-1:2
        
        % do particle advection: Runge Kutta 4th order
        [xflowmap,yflowmap]=runge_kutta_4(xflowmap,yflowmap,N,px,py,pxn,pyn,xmesh,ymesh,1);
        % extended streaklines: save the initiating velocity of each
        % particle
        streak.gx(:,N) = streak.gx(:,N-1);
        streak.gy(:,N) = streak.gy(:,N-1);
    end;
    streak.gx(:,1) = px(:);
    streak.gy(:,1) = py(:);
    
    % construct streakline matrix
    xfmat_ = cell2mat(xflowmap);
    xfmat = reshape(xfmat_,size(xflowmap{1},1)*size(xflowmap{1},2),[]);
    yfmat_ = cell2mat(yflowmap);
    yfmat = reshape(yfmat_,size(yflowmap{1},1)*size(yflowmap{1},2),[]);
    [gx,nouse]= gradient(xfmat);
    [gy,nouse]= gradient(yfmat);
    
    
    % compute streak flow: u_new,v_new
    thex=1:1:size(img1,2);
    they=1:1:size(img1,1);
    u_new = gridfit(xfmat,yfmat,streak.gx,thex,they,'smooth',.3);
    v_new = gridfit(xfmat,yfmat,streak.gy,thex,they,'smooth',.3);
    
    if i==strt  % store the previous streak flow
        prev_u = u_new;
        prev_v = v_new;
    end;
    %
    
    %% Segmentation part  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    if i == strt
        % create the neighborhood matrix (8-neighbors)
        [xx,yy]=meshgrid(1:size(xmesh,2),1:size(xmesh,1));
        a.x = repmat(xx,[1,1,8]);
        a.y = repmat(yy,[1,1,8]);
        clear b
        b.x(:,:,1) = xx-1;b.x(:,:,2) = xx+1; b.x(:,:,3) = xx; b.x(:,:,4) = xx;
        b.x(:,:,5) = xx-1;b.x(:,:,6) = xx-1; b.x(:,:,7) = xx+1; b.x(:,:,8) = xx+1;
        
        b.y(:,:,1) = yy; b.y(:,:,2) = yy; b.y(:,:,3) = yy-1; b.y(:,:,4) = yy+1;
        b.y(:,:,5) = yy-1; b.y(:,:,6) = yy+1; b.y(:,:,7) = yy-1; b.y(:,:,8) = yy+1;
        
        
        bads1 =find(b.y(:)<1);
        bads1 =[bads1;find(b.y(:)>size(xx,1))];
        bads2 =[find(b.x(:)<1)];
        bads2 =[bads2;find(b.x(:)>size(xx,2))];
        
        bads = union(bads1,bads2);
        a.x(bads) = [];    a.y(bads) = [];
        
        b.x(bads) = [];    b.y(bads) = [];
        ind1 = sub2ind(size(xx),a.y(:),a.x(:));
        ind2 = sub2ind(size(xx),b.y(:),b.x(:));
    end;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % distance between streakliens
    sgx = cumsum(gx,2);
    sgy = cumsum(gy,2);
    normalize = 0;
    mapped_angles = map_angles(u_new,v_new,100);
    alpha = [.8 .2 0 ];
    % compute streakline similarity
    [smtx,streak_sim_old,mag_uv_sim,ang_sim] = compute_similarity_mapangs_mat(sgx,sgy,ind1,ind2,size(xx),mapped_angles,u_new,v_new,alpha);
    hedges = smtx2hedges(smtx,size(xx));
    
    % refine hedges
    hedges_ref = refine_hedges(hedges,cleaning_ratio);
    hedges_ref = hedges_ref./max(hedges_ref(:))*255;
    
    % watershed segmentation
    labels = watershed(hedges_ref);
    magnitude=sqrt(u_new.^2+v_new.^2);
    [N,X]  = hist(magnitude(:));
    Thresh = X(2) - X(1);
    labels(magnitude<Thresh) = 0;
    labels = bwlabel(labels);
    
    % remove small segments
    seg_mask = remove_small_segs(labels,u_new,v_new,1,.3);
    
    save(sprintf('%s/hedges_%05d.mat',output_dir,i),'hedges','u_new','v_new','xflowmap','yflowmap');
    
    [new_seg_mask] = colorize_seg_mask(seg_mask,u_new,v_new,true);
    
    
    %% illustration
    figure(1)
    % hedges
    subplot(3,3,5),
    imagesc(hedges),axis image,title('Boundaries between Streaklines')
    set(gca, 'visible', 'off')
    
    % streak flow
    subplot(3,3,1)
    flow(:,:,1) = nan2zeros(u_new);
    flow(:,:,2) = nan2zeros(v_new);
    optical_flow_im = flowToColor(flow);
    imshow(optical_flow_im),title('Streak Flow')    
    imwrite(optical_flow_im,sprintf(['%s/Segmentation/streakflow_' img_outputfileformat],output_dir,i));
    
    % segments
    subplot(3,3,9)
    imshow(new_seg_mask),axis image, title('Motion Segmentation')    
    imwrite(new_seg_mask,sprintf(['%s/Segmentation/' img_outputfileformat],output_dir,i));
        
    % optical flow
    subplot(3,3,4)
    flow(:,:,1) = nan2zeros(px);
    flow(:,:,2) = nan2zeros(py);
    optical_flow_im = flowToColor(flow);
    imshow(optical_flow_im),title('Optical Flow');
    imwrite(optical_flow_im,sprintf(['%s/Segmentation/opticalflow_' img_outputfileformat],output_dir,i));
    
    
    % video frame
    subplot(3,3,3),
    imshow(img1),axis image, title(sprintf('Video Frame %05d',i))
    
    % show streaklines
    subplot(3,3,6),
    jump_st = 10;
    ind_2_show = 1:prod(size(xmesh));
    ind_2_show = reshape(ind_2_show,size(xmesh));
    ind_2_show = ind_2_show(1:jump_st:end,1:jump_st:end);    
    xfmat_toshow = xfmat(ind_2_show,:);
    yfmat_toshow = yfmat(ind_2_show,:);        
    hh2=plot(xfmat_toshow',yfmat_toshow','LineWidth',1);
    hold on,
    plot(xfmat_toshow(:,1)',yfmat_toshow(:,1)','bo','LineWidth',.2,'MarkerSize',2);
    hold off
    title('Streaklines (sub-sampled)')
    axis image
    axis ij               
    
    %  overlay Streak Flow 
    subplot(3,3,7)
    imshow(img2);
    flow(:,:,1) = nan2zeros(u_new);
    flow(:,:,2) = nan2zeros(v_new);
    optical_flow_im = flowToColor(flow);
    optical_flow_im = rgb2hsv(optical_flow_im);
    optical_flow_im(:,:,2) = imadjust(2*optical_flow_im(:,:,2));
    optical_flow_im = hsv2rgb(optical_flow_im);
    axis image
    hold on
    h = image(optical_flow_im);title('Overlay StreakFlow')
    set(h,'AlphaData',1*rgb2gray(optical_flow_im),'XData',[],'YData',[]);
    hold off,
%     set(gca, 'position', [0 0 1 1], 'visible', 'off')
%     set(gcf,'PaperPositionMode','auto')
    
    % alpha channel Streaklines 's
    subplot(3,3,2),
    imshow(img2);
    axis image
    hold on
    h = image(new_seg_mask);title('Overlay Segmentation')
    set(h,'AlphaData',.75*rgb2gray(new_seg_mask),'XData',[],'YData',[]);
    hold off
%     set(gca, 'position', [0 0 1 1], 'visible', 'off')
%     set(gcf,'PaperPositionMode','auto')
    
    
    % instanteneous optical flow
    subplot(3,3,8),
    flow2(:,:,1) = nan2zeros(px);
    flow2(:,:,2) = nan2zeros(py);
    optical_flow_im2 = flowToColor(flow2);
    optical_flow_im2 = rgb2hsv(optical_flow_im2);
    optical_flow_im2(:,:,2) = imadjust(2*optical_flow_im2(:,:,2));
    optical_flow_im2 = hsv2rgb(optical_flow_im2);
    optical_flow_im2 = imresize(optical_flow_im2,size(u_new));
    optical_flow_im2(optical_flow_im2>1) = 1;
    optical_flow_im2(optical_flow_im2<0) = 0;
    imshow(img2);
    axis image
    hold on
    h = image(optical_flow_im2); title('Overlay Optical Flow')
    set(h,'AlphaData',1*rgb2gray(optical_flow_im2),'XData',[],'YData',[]);
    hold off
%     set(gca, 'position', [0 0 1 1], 'visible', 'off')
%     set(gcf,'PaperPositionMode','auto')
    
        %save the image to file

        print(gcf,'-djpeg','-noui',sprintf(['%s/' img_outputfileformat],output_dir,i))

    
    
    %% store the previous streak flow
    prev_u = u_new;
    prev_v = v_new;
    
end;



