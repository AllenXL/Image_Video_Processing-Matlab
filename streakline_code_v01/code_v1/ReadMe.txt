The MATLAB code for "A Streakline Representation of Flow in Crowded Scenes", in ECCV 2010.
by Ramin Mehran, ramin@cs.ucf.edu

- The main m-file is streakline_segmentation_v1.m. It computes the strealines and the segmentation and illustrates results in a figure.
- the main file calls an initialization script like do_init_boston.m . For running the code on your own data you need to make a new initialization script like that with different source folder. The program reads frames (images) and not the video files (e.g. .avi)
- There are extra function to compute potentials, detecting lanes in coherent flow, and divergent/convergent regions. I made two functions to illustrate how they work:
find_divergent_flow_fn.m detect the divergent regions in the flow using velocity potential \phi
extract_show_lanes.m detects the lanes in coherent flow using stream function \psi
- Data folder contains the dataset. I added couple of frames from the dataset for testing.
- There are three external toolboxes that I used. I've added that to the code and it's automatically added to path.
- The results are saved in the results folder
