% Sample motion directions in degrees
% I'll figure out what to do later

% load data
load('sub004_bspri_final_map_V1_surf_trialData.mat')
% load("sub022_motMap_pilot01_test_TO1TO2_surf_trialData.mat")

mot_dir = [0, 60, 120, 180, 240, 300];

% use make_hex to make channel centers
filt_scale = 1.1; 
scale_factor = 6.5;
[chan_x,chan_y]=make_hex(7);
chan_x = chan_x*scale_factor;  
chan_y = chan_y*scale_factor;
size_constant=7.8434;

% Create a meshgrid for the x and y coordinates
x = linspace(-8, 8, 41);
y = linspace(-8, 8, 41);

% Calling functions

% general grid_instance
grid = grids(x, y);

% coordinate list (sanity check)
coor_list=grid.get_coor_list;

% stimulus mask 
stim_masks=grid.get_stim_masks(stim_pos_all, p_all.size);

% basis function (7.8434 is from the value calculated in bspri script)
basis_set=grid.get_basis_set([chan_x, chan_y],size_constant);
%Run this code to visualize basis_set (should correspond to a chan center)
%change the column value to see a specific channel
% visuallize basis functions 
%for i=1:1
    %grid.get_space_plot(basis_set(:,i))
%end

% compute X
X=stim_masks' * basis_set;

% normalize
X=X/max(X(:));

% compute weights W (Note: didn't do any pre-processing of the data
% as in bspri, only collapsed down to a 2D matrix by taking the 
% average across TR--refine later?)


% Try: by TR
% Initialize a matrix with the correct dimension
% Filter out the std = 0 cases
%B_1=mean(dt_allz,3);
B_1=dt_allz(:,:,1);
mystd = std(B_1,[],1); 
keep_2 = logical(mystd);
B_1=B_1(:, keep_2);
W=pinv(X)*B_1;

% load testing data 
load('sub004_bspri_final_bspri_V1_surf_trialData.mat')
% load("sub022_motMap_pilot02_test_TO1TO2_surf_trialData.mat")

% select all non-zero columns
%B_2=mean(dt_allz,3);
B_2=dt_allz(:,:,1);
mystd = std(B_2,[],1); 
keep_2 = logical(mystd);
B_2=B_2(:, keep_2);

% compute estimated channel response 

chan_resp= B_2*pinv(W);

% Alignment 
% Raw Reconstruction:
recons_raw = basis_set * chan_resp'; 

% Aligned Reconstruction:
recons_aligned=grid.get_aligned_recon([chan_x, chan_y], size_constant, stim_pos_all, chan_resp);

grid.get_space_plot(mean(recons_raw,2));
grid.get_space_plot(mean(recons_aligned,2));

% Plot
% for i=6:10
    
    
    %grid.get_space_plot(recons_raw(:,i))
    %grid.get_space_plot(recons_aligned(:,i))
    
%end






