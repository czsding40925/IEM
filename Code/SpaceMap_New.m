%% SpaceMap_New
% Goal: generalize to all subjects, sessions, ROIs, 
% Specify training time points like in the original script 
% Basically all the loops in bspri will find themselves here
% fmri_data should have all the necessary class functions
% For debugging just step in
% Refer to SpaceMap for IEM details. The class used there is called "grids"


% First, some basic analysis parameters

tst_dir = 'motMap'; 
trn_dir = 'motMap'; 
trn_sess = 'bspri_final01_map'; % files to load for training
trn_root =  bspri_loadRoot;  

% input for the fmri_data class
% for more participants, adjust accordingly
subj = {'sub004'}; 
sess = {{'bspri_final01_bspri'}};
ROI = {'V1'};
which_vox = 0.1;
trn_tpts = 7:10;
data=fmri_data(subj,sess,ROI, which_vox, trn_tpts); % must be in this order

% additional parameters
align_to = {'targ_ang_all'}; % for alignment later on (might delete)
func_suffix = 'surf'; %for loading file
task_tpts = -3:16; % task time points 
func_thresh = 1.5;
use_loc = 0; 

% More setup: create our grids for evaluating IEM 

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
% coor_list=grid.get_coor_list;

% Here begins the triple loop

% First loop over subjects 
for subj_id = 1:length(subj)
    % Then loop over ROIs
    for ROI_id = 1:length(ROI)
        % Lastly loop over sessions
        for sess_id = 1:length(sess{subj_id})
            % Load TESTING data 
            testing_data = data.load_testing_data(trn_root, tst_dir,subj_id,ROI_id,sess_id,func_suffix);
            % Load TRAINING data
            training_data = data.load_training_data(trn_root, trn_dir,subj_id,ROI_id,sess_id,func_suffix,trn_sess);
        end

        % Data loaded, find training indices 
        task_idx = find(ismember(testing_data.which_TRs, task_tpts));

        % Initiate some empty cells: 
        % reconstruction cell
        % raw reconstruction (3D matrix)
        % channel responses (also a 3D matrix)
        recons = cell(length(align_to),1);
        recons_raw = nan(size(testing_data.c_all,1),length(grid.x)^2,length(task_tpts)); 
        % Since I didn't use the 
        % bspri approach, I just squared the length of grid.x, should do
        % the same trick
        chan_resp = nan(size(testing_data.c_all,1),length(chan_x),length(task_tpts));
        
        % Refine Training Data 
        % First, get the essential voxels and training indices

        these_vox = data.get_these_voxels(training_data, trn_tpts, use_loc, func_thresh);
        trn_idx = training_data.c_all(:,1)~=1; % This has to do with distractors, not sure if it matters for motMap
        % Refine dataset
        trndata = mean(training_data.dt_allz(:,:,ismember(training_data.which_TRs,trn_tpts)),3);
        trndata = trndata(trn_idx, these_vox);
        % IEM using new strat: 

        % Get stim mask: 
        stim_masks=grid.get_stim_masks(training_data.stim_pos_all(trn_idx,:), training_data.p_all.size);
        
        % Basis function
        basis_set=grid.get_basis_set([chan_x, chan_y],size_constant);

        % Compute & Normalize X 
        X = stim_masks'*basis_set;
        X = X/max(X(:));

        % Compute weights
        W = X\trndata; 

        % Generate Channel Responses 
        % 3-D matrix: trials * channels * task_tpts 

        for i = 1:length(task_idx)
            tstdata = mean(testing_data.dt_allz(:,:,task_idx(i)),3);
            tstdata = tstdata(:,these_vox);
            chan_resp(:,:,i) = (inv(W*W.')*W*tstdata.').';
            clear tstdata
        end

        % Alignment. Ugh. 
        % Roughly follows the bspri script 

        % Basis set already exists:
        for i = 1:length(task_tpts)
            recons_raw(:,:,i) = basis_set * 
        end

    end
end


