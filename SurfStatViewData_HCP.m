function [ a, cb, h1 ] = SurfStatViewData_HCP(data_L, surf_L, data_R, surf_R, title, background,cmap)
% View FS average space HCP data.  Should work for any surfaces in the same
% orientation.
% Nick Bock June 2018
% Modified by Christopher Rowley 2021

%Basic viewer for surface data.
% 
% Usage: [ a, cb ] = SurfStatViewData( data, surf [,title [,background]] );
% 
% data        = 1 x v vector of data, v=#vertices
% surf.coord  = 3 x v matrix of coordinates.
% surf.tri    = t x 3 matrix of triangle indices, 1-based, t=#triangles.
% title       = any string, data name by default.
% background  = background colour, any matlab ColorSpec, such as 
%   'white' (default), 'black'=='k', 'r'==[1 0 0], [1 0.4 0.6] (pink) etc.
%   Letter and line colours are inverted if background is dark (mean<0.5).
%
% a  = vector of handles to the axes, left to right, top to bottom. 
% cb = handle to the colorbar.

if nargin<5 
    title=inputname(1);
end
if nargin<6
    background=[0 0 0];
end
if nargin<7
    cmap = spectral;
end


% Redundant, but I am leaving it in to keep something working
% % find cut between hemispheres, assuming they are concatenated
t=size(surf_L.tri,1);
v=size(surf_L.coord,2);
tmax=max(surf_L.tri,[],2);
tmin=min(surf_L.tri,[],2);
% to save time, check that the cut is half way
if min(tmin(t/2+1:t))-max(tmax(1:t/2))==1
    cut=t/2;
    cuv=v/2;
else % check all cuts
    for i=1:t-1
        tmax(i+1)=max(tmax(i+1),tmax(i));
        tmin(t-i)=min(tmin(t-i),tmin(t-i+1));
    end
    cut=min([find((tmin(2:t)-tmax(1:t-1))==1) t]);
    cuv=tmax(cut);
end
% tl=1:cut;
% tr=(cut+1):t;
% vl=1:cuv;
% vr=(cuv+1):v;

clim=[min(data_L),max(data_L)];
if clim(1)==clim(2)
    clim=clim(1)+[-1 0];
end

clf;
%colormap(spectral(256));
colormap(cmap);

h=0.48;
w=0.48;

a(1)=axes('position', [0.01 0.55 h*3/4 w]); %Axes start and height
trisurf(surf_L.tri,surf_L.coord(1,:),surf_L.coord(2,:),surf_L.coord(3,:),...
    double(data_L),'EdgeColor','none', 'AmbientStrength',0.5, 'SpecularStrength', 0.1);
view(-90,0); 
daspect([1 1 1]); axis tight; camlight; axis vis3d off;
%lighting phong; material shiny; shading interp;
%lateral view - left

a(3)=axes('position',[0.01 0.1 h*3/4 w]);
trisurf(surf_R.tri,surf_R.coord(1,:),surf_R.coord(2,:),surf_R.coord(3,:),...
    double(data_R),'EdgeColor','none', 'AmbientStrength',0.5, 'SpecularStrength', 0.1);
view(90,0); 
daspect([1 1 1]); axis tight; camlight; axis vis3d off;
%lighting phong; material shiny; shading interp;
%lateral view - right

a(4)=axes('position',[0.6 0.55 h*3/4 w]); %Axes start and height
trisurf(surf_L.tri,surf_L.coord(1,:),surf_L.coord(2,:),surf_L.coord(3,:),...
    double(data_L),'EdgeColor','none', 'AmbientStrength',0.5, 'SpecularStrength', 0.1);
view(90,0); 
daspect([1 1 1]); axis tight; camlight; axis vis3d off;
%lighting flat; material dull; shading interp;
% Medial view - left


a(6)=axes('position',[0.6 0.1 h*3/4 w]);
trisurf(surf_R.tri,surf_R.coord(1,:),surf_R.coord(2,:),surf_R.coord(3,:),...
    double(data_R),'EdgeColor','none', 'AmbientStrength',0.5, 'SpecularStrength', 0.1);
view(-90,0); 
daspect([1 1 1]); axis tight; camlight; axis vis3d off;
%lighting flat; material dull; shading interp;
% Medial view - right


a(2)=axes('position',[0.18 0.32 w h]); %0.17
trisurf(surf_L.tri,surf_L.coord(1,:),surf_L.coord(2,:),surf_L.coord(3,:),...
    double(data_L),'EdgeColor','none', 'AmbientStrength',0.5, 'SpecularStrength', 0.1);
view(0,90); 
daspect([1 1 1]); axis tight; camlight; axis vis3d off;
%lighting flat; material dull; shading interp;
%dorsal view -left


a(5)=axes('position',[0.32 0.32 w h]);
trisurf(surf_R.tri,surf_R.coord(1,:),surf_R.coord(2,:),surf_R.coord(3,:),...
    double(data_R),'EdgeColor','none', 'AmbientStrength',0.5, 'SpecularStrength', 0.1);
view(0,90); 
daspect([1 1 1]); axis tight; camlight; axis vis3d off;
%lighting flat; material dull; shading interp;
%dorsal view - right


 id0=[0 0 cuv 0 0 cuv 0 0];
 for i=1:length(a)
     set(a(i),'CLim',clim);
     set(a(i),'Tag',['SurfStatView ' num2str(i) ' ' num2str(id0(i))]);
 end

 
 %'Position',[x0 y0 width height])
cb=colorbar('location','South');
set(cb,'position',[0.34 0.15 0.3 0.03]); 
set(cb,'XAxisLocation','bottom');
h1=get(cb,'Title');

% C.R. if background is black, make title white.
if max(background) < 0.3
    titleColour = [1 1 1];
else 
     titleColour = [0 0 0];
end

set(h1,'String',title, 'Color', titleColour,'FontSize',20);

whitebg(gcf,background);
set(gcf,'Color',background,'InvertHardcopy','off');

set(gca, 'FontSize',20,'Color',titleColour) 
dcm_obj=datacursormode(gcf);
set(dcm_obj,'UpdateFcn',@SurfStatDataCursor,'DisplayStyle','window');

set(gcf,'PaperPosition',[0.25 0.25 6 4.5]);

% return
% end
