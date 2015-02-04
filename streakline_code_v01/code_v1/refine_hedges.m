function hedges = refine_hedges(hedges,ratio)

  % hedges(hedges>10) = 10;
    ttmmmpp = mean(hedges(:))+ratio*std(hedges(:));
    hedges(hedges>ttmmmpp) = ttmmmpp;
    
    hedges = full(max(hedges(:))-hedges);
    