function [metric] = Load_and_Combine_vtkmetric( file_left,file_right,n)
%
%A function to combine left and right hemispheres from VTK files
% n = number of subjects in the vtk surface file

%load group thickness
T_group1=thickness_from_vtk_group(file_left,n);
T_group2=thickness_from_vtk_group(file_right,n);
metric = horzcat(T_group2,T_group1); %combine them

end
