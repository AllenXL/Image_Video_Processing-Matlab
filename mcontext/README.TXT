This is a MATLAB code for computing the motion context descriptor which was used in

Du Tran, Alexander Sorokin, Human Activity Recognition with Metric Learning, ECCV08, Marseille, France.
Du Tran, Alexander Sorokin, David Forsyth, Human Activity Recognition with Metric Learning, UIUCDCS-R-2008-2952.

Please cite the work if you find it helpful and email to dutran2 AT uiuc.edu for any question.
The source code can be optimized more for speed up in some points (revised to optimize the matrix computation).


In this zip contains: HierarchicalLK.m, LucasKanade.m, LucasKanadeRefined.m which were written by Sohaib Khan (UCF) for computing the optical flows.

To run this:
1) change the directory to the 'mcontext' dir
2) call do_all

The output features will be stored at 'dir/feature/win_feature.mat'

the following are the contents

mcontext/       	-> all MATLAB files
mcontext/dir    	-> all sample data 
mcontext/dir/frm 	-> 2 sample video sequences (daria_bend and daria_jump from Weizmann dataset)
mcontext/dir/bkg	-> foreground masks of the two above videos (also from Weizmann)
mcontext/dir/box	-> output bounding boxes
mcontext/dir/flow	-> output optical flows
mcontext/dir/feature	-> output features
