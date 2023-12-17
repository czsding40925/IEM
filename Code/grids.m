%make a gridclass
classdef grids
    properties
        x %list of x coordinates
        y %list of y coordinates
        %channel_centers % channel centers
    end
    methods
        % Constructor
        function obj = grids(x, y)
            if nargin > 0
                obj.x = x;
                obj.y = y;
            else
                % Set default values or empty arrays
                obj.x = [];
                obj.y = [];
            end
        end

        % Function 1 - 5: spatial IEM 

        % Function 1: output a list of all locations
        function coor_list = get_coor_list(obj)
            [X, Y]=meshgrid(obj.x,obj.y);
            X_col = reshape(X, [], 1);
            Y_col = reshape(Y, [], 1);
            coor_list=[X_col, Y_col];
        end
        
        % function 2: general distance matrix
        % since we will be using the stimulus positions and channel 
        % centers to generate stimulus masks/basis functions respectively
        % we will build a function that outputs a p*n matrix of distances
        % p: pixel count/gridsize n: number of channels/stims

        function distance_matrix=get_distance_matrix(obj,ref_coor_list)

            %get the list of coordinates
            coor_list=get_coor_list(obj);

            %get dimension 
            num_coor_list=size(coor_list,1);
            num_ref_coor_list=size(ref_coor_list,1);

            %initiate empty an empty matrix
            distance_matrix=zeros(num_coor_list,num_ref_coor_list);

            %make matrix
            for i=1:num_coor_list
                for j=1:num_ref_coor_list
                    distance_matrix(i,j)=sqrt(sum((coor_list(i,:)-ref_coor_list(j,:)).^2));
                end
            end
        end

        % function 3: stimulus masks: input a list of stimulus and 
        % output binary vectors to indicate location 
        function stim_masks=get_stim_masks(obj, stimuli, r)

            % get distance matrix
            distance_matrix=get_distance_matrix(obj,stimuli);

            % create binary masks
            stim_masks=distance_matrix<=r;
        end

        %function 4: make basis function 
        %input a distance matrix and output the cosine function to each
        %value f(r)=(0.5+0.5cos(rpi/s))^7

        function basis_set=get_basis_set(obj,chan_centers,size_constant)
           % get distance matrix
           distance_matrix=get_distance_matrix(obj,chan_centers);
           % output the basis function
           % Define function
           func = @(x) (0.5+0.5*cos(pi*x/size_constant)).^7;
           basis_set= distance_matrix;
           %Plug the values less than the size constant into the function
           basis_set(basis_set<=size_constant) = func(basis_set(basis_set<=size_constant));
           %Zero otherwise
           basis_set(basis_set>size_constant) = 0;
        end
        

        %Function 5: Alignment
        %Rotate CHANNEL CENTER FIRST THEN DO STUFF 
        %Input: 
            %obj
            %channel centers 
            %size_constant
            %stim_centers (stim_poss_all)
            %chan_resp (computed channel response)

        function aligned_recon = get_aligned_recon(obj, chan_centers, ...
                size_constant, stim_centers, chan_resp)
            % compute basis set
            basis_set = get_basis_set(obj,chan_centers, size_constant);
            % initialize a matrix that matches the size of raw
            % reconstruction
            aligned_recon = zeros(size(basis_set*chan_resp'));
            % Loop through all stimulus position
            for i=1:size(stim_centers(:,1))
                % Find the angle 
                theta = atan(stim_centers(i,2)/stim_centers(i,1));
                % Get the rotated channel_centeres
                r_chan_centers = chan_centers * [cos(theta) sin(theta); 
                                                -sin(theta) cos(theta)]; 
                r_chan_centers(:,2)=-r_chan_centers(:,2);
                % Use r_chan_centers to build the new basis set. 
                r_basis_set = get_basis_set(obj, r_chan_centers, size_constant);
                % Fill the i-th column of the aligned_recon matrix with
                % the rotated basis set * i-th row of chan_resp
                % transposed
                aligned_recon(:,i) = r_basis_set * chan_resp(i,:)';
            end
        end

        %Function 6: Plotting
        function get_space_plot(obj, recons_aligned)
            % get coor_list
            % coor_list = get_coor_list(obj);
            % get the mean of the aligned reconstruction
            recons_mean = mean(recons_aligned, 2);
            [X, Y] = meshgrid(obj.x, obj.y);
            % reshape data 
            data_reshaped = reshape(recons_mean, [length(obj.x), length(obj.y)]);
            % plot
            figure 
            surf(X,Y,data_reshaped,'EdgeColor', 'none');
            view(2)
            axis xy;
            % Additional Touch
            
            colorbar; % Show the color scale
            
            % Add labels and title
            xlabel('X-position');
            ylabel('Y-position');
            title('Spacial Reconstruction');
        end

        
    end
end