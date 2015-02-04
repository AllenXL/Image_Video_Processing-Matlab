%(C) Du Tran dutran2@uiuc.edu 2008
function du_mkdir(mydir)
if ~exist(mydir,'dir')
    mkdir(mydir);
end
