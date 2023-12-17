classdef circ
    properties
        mot_dir
    end
    methods
        %Constructor
        function obj=circ(mot_dir)
            if nargin > 0
                obj.mot_dir = mot_dir;
            else
                % Set default values or empty arrays
                obj.mot_dir = [];
            end
        end
        %Function 1: Motion Difference 
        function mot_diff = get_mot_diff(obj, stim_dir)
            % convert to radians
            rad_mot_dir = rad2deg(obj.mot_dir);
            rad_stim_dir = rad2deg(stim_dir);
            % chatGPT taught me this dope-ass function
            % this computes the pairwise difference of two lists
            mot_diff = abs(bsxfun(@minus,rad_mot_dir', rad_stim_dir'));
            % remember that we care about the absolute value 
        end

        %Function 2: Motion Basis Set
        %get the difference matrix between channel and stimulus and 
        %compute the basis set
        %f(t) = (cos(pi(t-t0)))^7
        function mo_basis_set=get_mo_basis_set(obj,stim_dir)
            mot_diff = get_mot_diff(obj, stim_dir);
            mo_basis_set = (cos(mot_diff.* pi).^7)';
        end

        %Function 3: Motion plot
        function get_mo_plot(obj, mo_chan_resp)
            mo_data = [obj.mot_dir', mean(mo_chan_resp, 1)'];
            figure
            plot(mo_data(:,1),mo_data(:,2),"-o");
            % Add labels and title
            xlabel('X-axis');
            ylabel('Y-axis');
            title('Motion Reconstruction');
        end

    end
end

