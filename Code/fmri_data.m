%% Data Processing

% Attempt: trying to create a class of fMRI data
% making things clean 
classdef fmri_data
    % subj, sess, ROI are cells of strings, which_cox is numerical,
    % trn_tpts is an array
    properties 
        subj % subject 
        sess % session
        ROI % ROI's
        which_vox % which voxels
        trn_tpts % training time points
    end
    methods 

        % constructor function: default is set to sub004, 01, V1, 0.1, 7-10
        function obj = fmri_data(subj, sess, ROI, which_vox, trn_tpts)
            if nargin > 0  
                obj.subj = subj;
                obj.sess = sess;
                obj.ROI = ROI;
                obj.which_vox = which_vox;
                obj.trn_tpts = trn_tpts;
            else 
                obj.subj = {'sub004'};
                obj.sess = {{'bspri_final01_bspri'}}; % Change to motMap when more data come around
                obj.ROI = {'V1'};
                obj.which_vox = 0.1; 
                obj.trn_tpts = 7:10;
            end
        end

        % function 1: loading testing data
        % mostly follows bspri: some modification though 
        % for reference:(variables in bspri --> variables here)
            % ss --> subj_id
            % vv --> ROI_id
            % sess_idx --> sess_id
        function data_tst=load_testing_data(obj,trn_root, tst_dir, subj_id,ROI_id,sess_id,func_suffix)
            data_tst = [];
            fn = sprintf('%s/%s_trialData/%s_%s_%s_%s_trialData.mat', trn_root,tst_dir,obj.subj{subj_id},obj.sess{subj_id}{sess_id},obj.ROI{ROI_id},func_suffix);
            fprintf('loading TESTING data from %s...\n',fn);
            thisdata = load(fn); % 
            thisdata.sess = sess_id*ones(size(thisdata.r_all)); % a list of session
            thisdata.targ_ang_all = -1*thisdata.c_all(:,1); % flip angles
            data_tst = cat_struct(data_tst,thisdata,{'rf','TR','which_TRs'});% still not sure what this really does but if it works it works lol
        end


        % function 2: loading training data 
        % mostly follows function 1 and bspri, with additional input of
        % trn_sess
        function data_trn=load_training_data(obj,trn_root, trn_dir, subj_id,ROI_id,sess_id,func_suffix, trn_sess)
            tmp_fn_trn = dir(sprintf( '%s/%s_trialData/%s_%s*_%s_%s_trialData.mat', trn_root,trn_dir,obj.subj{subj_id},trn_sess,obj.ROI{ROI_id},func_suffix) );
            data_trn = [];
            fn_trn = cell(length(tmp_fn_trn),1); 
            for ff = 1:length(tmp_fn_trn)
                fn_trn{ff} = sprintf('%s/%s',tmp_fn_trn(ff).folder,tmp_fn_trn(ff).name);
                fprintf('loading TRAINING data from %s...\n',fn_trn{ff});
                thisdata = load(fn_trn{ff});
                thisdata.sess = sess_id*ones(size(thisdata.r_all)); % a list of session
                data_trn = cat_struct(data_trn,thisdata,{'rf','TR','which_TRs'});
            end 
        end
        
        % function 3: get these voxes:
        % the voxels needed for training/testing data 
        % Just the big chunk of data selection in the original bspri
        function these_vox = get_these_voxels(obj, training_data, trn_tpts, use_loc, func_thresh)
            trndata = mean(training_data.dt_allz(:,:,ismember(training_data.which_TRs,trn_tpts)),3);
            % Compute Standard Deviation: mystd 
            mystd = std(trndata, [], 1);

            % Copy and paste the filter 
            % Omitted the not supported part for now
            % Will add back to it if necessary
            if obj.which_vox < 1          
                if use_loc == 1 && contains(obj.ROIs{ROI_id},{'hV4','VO1','VO2'}) && contains(obj.subj{subj_id},{'sub003','sub004','sub008','sub010','sub011','sub012'})
                    these_vox = mystd~=0 & ~isnan(mystd) & training_data.rf.ve>=obj.which_vox & data_trn.rf.funcThresh_col>func_thresh; % was >=func_thresh
                elseif use_loc == 1 && contains(obj.ROIs{ROI_id},{'TO1','TO2'}) && contains(obj.subj{subj_id},{'sub003','sub004','sub008','sub010','sub011','sub012'})
                    these_vox = mystd~=0 & ~isnan(mystd) & training_data.rf.ve>=obj.which_vox & data_trn.rf.funcThresh_mot>func_thresh; % was >=func_thresh
                else
                    these_vox = mystd~=0 & ~isnan(mystd) & training_data.rf.ve>=obj.which_vox;
                end
                
                % otherwise, we're using the top N voxels sorted by
                % quadrant-wise F-score, or all voxels, whichever is smaller
            else
                % NOTE: NOT SUPPORTED RIGHT NOW!!!!!
                error('not supported!');        
            end
        end

    end
end
