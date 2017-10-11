%%%%%%%%%%%%%%%%
%Sample script to get you started
% Script is to help you load vtk files created using CBS tools for analysis
% in matlab
%%%%%%%%%%%%%%%%

%load half depth surf
half_surf = Load_and_Combine_sides_2('file_name');

%smooth surf
Y = SurfStatSmooth( half_surf.coord, half_surf, 5 );
Ysmooth = struct('tri',half_surf.tri,'coord',Y);

%load data
number_sub = 20; %number of subjects that are included in 1 vtk file
half_signal = Load_and_Combine_vtkmetric('filename_left_side','filename_right_side',number_sub);
smoothed_signal = SurfStatSmooth( half_signal, Y, 10 ); %where 10 could be any number defining kernel size

%load MARS ROIs
mars_roi = Load_and_Combine_vtkmetric('mars_filename_left_side','mars_filename_right_side',1);

%%%%%%%% average over all subjects %%%%%%%%%
subject_mean = nanmean(smoothed_signal,1);

%%%%%%%% average some value over the ROIs %%%%%%%%%%
ROI_values=zeros(number_sub, 141); %   
for k = 1:141  %for each of the labels
    maskROI = mars_roi == k;  %make a matrix of 0,1's where the desired label is
    ROI_values(:,k) = nanmean( smoothed_signal(:, maskROI), 2 ); %%Calculates the ROI values for every subject in the vtk file
end

%%%%%%%%%% map calculated values back onto the ROIs %%%%%%%%%%
roi_vector = []; %a vector that is 1x141 in size. spots 42-100 should be 0 (ROIs don't exist)
for k = 1:141
    ROI_vals(mars_roi==k) = roi_vector(k);
end  

%%%%%%%%%%% visualize %%%%%%%%%%%%
grey = [0.7,0.7,0.7]; %good background colour for images

figure;
    SurfStatViewData(ROI_vals, Ysmooth, 'Title',grey) %inputs: data, surface, title, background colour
    SurfStatColLim([0 0.05]) %colour bar limits
    colormap(jet)

    
    %go to surfstat online documentation for more functionality. 

