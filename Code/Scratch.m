%Scratch File 
%All the scratches/testings are here to make the SpaceMap file cleaner

% stimulus mask 

stim_masks=grid.get_stim_masks(stim_pos_all, p_all.size);
%Run this code to visualize stim masks (please don't run all 252)
% for i=2:2
    %grid.get_space_plot(double(stim_masks(:,i)));
%end

basis_set=grid.get_basis_set([chan_x, chan_y],size_constant);
%r_basis_set=grid.get_basis_set([chan_x,chan_y],size_constant,atan2(stim_pos_all(1,2),stim_pos_all(1,1)));

for i = 1:length(chan_x)
    grid.get_space_plot(basis_set(:,i))
    %grid.get_space_plot(r_basis_set(:,i))
end



%grid.get_space_plot(basis_set*chan_resp(2,:)')
%grid.get_space_plot(r_basis_set*chan_resp(2,:)')

%Goal: Rotate the aligned reconstruction

%Raw Reconstruction Trial 1
%grid.get_space_plot(recons_raw(:,1))

%Find out the angle of this trial
%angle = c_all(1,1); % 290

%This looks kinda weird: Why is it at the 170 deg position? 
