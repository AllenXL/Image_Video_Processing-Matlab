function hedges = smtx2hedges(smtx,size_xx)
    hedges = (reshape(sum(smtx),size_xx));
  