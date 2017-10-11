function Thick_data = thickness_from_vtk_group(filename,n_sub)

%%read thickness data from VTK file
% created by the super duo Kim and Chris
fid = fopen(filename, 'rt');
formatSpec=repmat('%f ',1,n_sub);%read only lines with floating point numbers
tline=fgetl(fid);
while ischar(tline)
    if ~isempty(strfind(tline, 'LOOKUP_TABLE'))
        break;
    end
    tline=fgetl(fid);
end

T = textscan(fid,formatSpec,'TreatAsEmpty','Infinity');
fclose(fid);

for i=1:n_sub
    Thick_data(:,i)=T{1,i};
end

Thick_data=Thick_data';

%Thick_data=T';% use this for debugging, all boxes should contain same
%number of elements. If not maybe you have the wrong number of subjects, or
%NAN or infinity is coming up.

end