function [final] = Load_and_Combine_sides_2( file_left, file_right)
%
%A function to combine left and right hemispheres from VTK files

%Formatted so it will look like the strings below
% file_left = '/Users/filename_left.vtk';
% file_right = '/Users/filename_right.vtk';

%Load surfaces
[vertex_left, face_left]= read_vtk(file_left); %load leftside
S_left=struct('tri',face_left','coord',vertex_left);

[vertex_right, face_right]= read_vtk(file_right); %load right side
S_right=struct('tri',face_right','coord',vertex_right);

%move the right side over, S.tri values
S_left2=struct('tri',face_left','coord',vertex_left);
slide_tri = size(vertex_right,2) ;
S_left2.tri = S_left.tri + slide_tri; %this should slide all of the triangles over.

%S.coord
slide_coord = max(S_right.coord,[],2) ;
S_left2.coord(1,:) = S_left.coord(1,:) + slide_coord(1);

%Combine the sides
vertex = horzcat(S_right.coord,S_left2.coord);
face = vertcat(S_right.tri,S_left2.tri);
final=struct('tri',face,'coord',vertex);


% %test it out!
% me1 = nanmean(Thickness,1);
% figure;
%     SurfStatView(me1,final, 'control Mean',grey); %default bakground is white
%      SurfStatColLim([1.2 1.8]), colormap('jet')
end