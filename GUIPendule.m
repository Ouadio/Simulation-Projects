function varargout = GUIPendule(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIPendule_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIPendule_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
stop=0;
function GUIPendule_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = GUIPendule_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function Teta0_Callback(hObject, eventdata, handles)

function Teta0_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit3_Callback(hObject, eventdata, handles)
function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Plot_Callback(hObject, eventdata, handles)

g=9.81;
teta0 = str2double(get(handles.Teta0,'String'));
phi0 = str2double(get(handles.Phi0,'String'));
teta0P = str2double(get(handles.Teta0P,'String'));
phi0P = str2double(get(handles.Phi0P,'String'));

m = str2double(get(handles.m,'String'));
L1 = str2double(get(handles.L1,'String'));
L2 = str2double(get(handles.L2,'String'));
Tmax = str2double(get(handles.Tmax,'String'));

phi0P2 = str2double(get(handles.phi0P2,'String'));
teta0P2 = str2double(get(handles.teta0P2,'String'));

pendule2 = get(handles.Pendule2,'Value');
Traj = get(handles.Trajectoire,'Value');

global stop;       %Variable globale servant à arrêter l'animation une foix différente de 0
stop = 0;

options = odeset('RelTol',1e-8);

[t,teta] = ode45('doublePend',[0:0.04:Tmax], [teta0 teta0P phi0 phi0P], options);   %Résolution de l'équation différentielle

y=zeros(3,1);              
z=zeros(3,1);
yold=zeros(3,1);
zold=zeros(3,1);

if pendule2==1
    [t2,teta2] = ode45('doublePend',[0:0.04:Tmax], [teta0 teta0P2 phi0 phi0P2], options); %Résolution de l'équation différentielle pendule 2
    y2=zeros(3,1);
    z2=zeros(3,1);
    y2old=zeros(3,1);
    z2old=zeros(3,1);
end

%Concervation d'energie mecanique, on calcule Em t=0
Em=(1/2)*(m*L1^2)*( 2*teta0P^2) + (1/2)*(m*L2)*(L1*phi0P^2 + 2*L1*teta0P*phi0P*cos(teta0-phi0)  )-m*g*(2*L1*cos(teta0)+L2*cos(phi0));

bords=L1+L2+3;     %pour mettre le plot à l'echelle
i=1;
cla();

%Parametres d'affichage
grid on; box on; 
axis([-bords; bords; -bords; bords ]); 
xlabel('m'); ylabel('m');

if pendule2==0
if Traj==0
  while i<max(size(t)) & stop==0
  cla();
  tic  
  Ep=-m*g*(2*L1*cos(teta(i,1))+L2*cos(teta(i,3)));      %Energie Cinetique
  Ec=Em-Ep;                                                                 %Energie Mecanique
  
  y(2)=L1*sin(teta(i,1));               z(2)=-L1*cos(teta(i,1));            %Calcul des positions du premier bout
  y(3)=y(2)+L2*sin(teta(i,3));        z(3)=z(2)-L2*cos(teta(i,3));      %Calcul des positions du deuxième bout
  
  line( [y(1) y(2)],[z(1) z(2)],'Color','r','LineWidth',2);         %Premièr segment 
  line([y(2) y(3)],[z(2) z(3)],'Color','b','LineWidth',2);         %Deuxième segment
  line( y(2),z(2),'Color','r','Marker','.','Markersize',40);      %Bout du premier segment (masse)
  line(y(3),z(3),'Color','b','Marker','.','Markersize',40);      %Bout du deuxième segment (masse)
  drawnow(); 
  
  set(handles.Ec,'String',Ec);                     %Affichage Energie Cinetique
  set(handles.Ep,'String',Ep);                    %Affichage Energie Potentielle
  set(handles.Em,'String',Em);                  %Affichage Energie Mécanique
  tt=i*0.04;                                                 %Temps écoulé
  set(handles.Time1,'String',floor(tt));       %Affichage du temps écoulé
  set(handles.Time2,'String',tt-floor(tt));   %Affichage du temps écoulé
  while toc<0.04 
  end
  i=i+1;
  end
end

  %Cas de trajectoire à dessiner
if Traj==1
  while i<max(size(t)) & stop==0
  tic  
  y(2)=L1*sin(teta(i,1));               z(2)=-L1*cos(teta(i,1));            %Calcul des positions du premier bout
  y(3)=y(2)+L2*sin(teta(i,3));        z(3)=z(2)-L2*cos(teta(i,3));      %Calcul des positions du deuxième bout
  
  Ep=-m*g*(2*L1*cos(teta(i,1))+L2*cos(teta(i,3)));      %Energie Cinetique
  Ec=Em-Ep;                                                                 %Energie Mecanique
  
  line( handles.axes1 ,y(3),z(3),'Color','b','Marker','.','Markersize',10);    %Bout du deuxième segment
  drawnow(); 
  set(handles.Ec,'String',Ec);                     %Affichage Energie Cinetique
  set(handles.Ep,'String',Ep);                    %Affichage Energie Potentielle
  set(handles.Em,'String',Em);                  %Affichage Energie Mécanique
  
  tt=i*0.04;
  set(handles.Time1,'String',floor(tt));
  set(handles.Time2,'String',tt-floor(tt));

  while toc<0.04
  end
  i=i+1;
   end
end   
end
%%%%%%%%%%%%%%%%% 2 Pendules %%%%%%%%%%%%%%%%%%%%
if pendule2==1
    if Traj==0
  while i<max(size(t)) & stop==0
  cla();
  tic  
  
  y(2)=L1*sin(teta(i,1));
  z(2)=-L1*cos(teta(i,1));
  y(3)=y(2)+L2*sin(teta(i,3));
  z(3)=z(2)-L2*cos(teta(i,3));
  
  y2(2)=L1*sin(teta2(i,1));
  z2(2)=-L1*cos(teta2(i,1));
  y2(3)=y2(2)+L2*sin(teta2(i,3));
  z2(3)=z2(2)-L2*cos(teta2(i,3));
  
  line( [y(1) y(2)],[z(1) z(2)],'Color','b','LineWidth',2);        %Premièr segment 
  line([y(2) y(3)],[z(2) z(3)],'Color','b','LineWidth',2);       %Deuxième segment
  line( y(2),z(2),'Color','b','Marker','.','Markersize',40);     %Bout du premier segment (masse)
  line(y(3),z(3),'Color','b','Marker','.','Markersize',40);    %Bout du deuxième segment
  
  line( [y2(1) y2(2)],[z2(1) z2(2)],'Color','r','LineWidth',2);        %Premièr segment 
  line([y2(2) y2(3)],[z2(2) z2(3)],'Color','r','LineWidth',2);       %Deuxième segment
  line( y2(2),z2(2),'Color','r','Marker','.','Markersize',40);     %Bout du premier segment (masse)
  line(y2(3),z2(3),'Color','r','Marker','.','Markersize',40);    %Bout du deuxième segment  
  drawnow(); 

  tt=i*0.04;
  set(handles.Time1,'String',floor(tt));
  set(handles.Time2,'String',tt-floor(tt));

  while toc<0.04 
  end
  i=i+1;
  end
    end

  %Cas de trajectoire à dessiner 
if Traj==1
  while i<max(size(t)) & stop==0
  tic  
  
  y(2)=L1*sin(teta(i,1));
  z(2)=-L1*cos(teta(i,1));
  y(3)=y(2)+L2*sin(teta(i,3));
  z(3)=z(2)-L2*cos(teta(i,3));
  
  y2(2)=L1*sin(teta2(i,1));
  z2(2)=-L1*cos(teta2(i,1));
  y2(3)=y2(2)+L2*sin(teta2(i,3));
  z2(3)=z2(2)-L2*cos(teta2(i,3));
  
  line( handles.axes1 ,y(3),z(3),'Color','b','Marker','.','Markersize',15);    %Bout du deuxième segment
  line( handles.axes1 ,y2(3),z2(3),'Color','r','Marker','.','Markersize',15);    %Bout du deuxième segment
  drawnow(); 
  
  tt=i*0.04;
  set(handles.Time1,'String',floor(tt));
  set(handles.Time2,'String',tt-floor(tt));

  while toc<0.04
  end
  i=i+1;
   end
end   
    
end

function Teta0P_Callback(hObject, eventdata, handles)

function Teta0P_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Phi0_Callback(hObject, eventdata, handles)

function Phi0_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Phi0P_Callback(hObject, eventdata, handles)

function Phi0P_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function L1_Callback(hObject, eventdata, handles)

function L1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit13_Callback(hObject, eventdata, handles)

function edit13_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function E_Callback(hObject, eventdata, handles)

function E_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function m_Callback(hObject, eventdata, handles)
function m_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Tmax_Callback(hObject, eventdata, handles)

function Tmax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Trajectoire_Callback(hObject, eventdata, handles)

get(hObject,'Value');

function arreter_Callback(hObject, eventdata, handles)

global stop;
stop=1;

function L2_Callback(hObject, eventdata, handles)

function L2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Quitter_Callback(hObject, eventdata, handles)

close()

function Ec_Callback(hObject, eventdata, handles)

function Ec_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Ep_Callback(hObject, eventdata, handles)

function Ep_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Em_Callback(hObject, eventdata, handles)

function Em_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Time1_Callback(hObject, eventdata, handles)

function Time1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Time2_Callback(hObject, eventdata, handles)

function Time2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function teta0P2_Callback(hObject, eventdata, handles)

function teta0P2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function phi0P2_Callback(hObject, eventdata, handles)

function phi0P2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pendule2_Callback(hObject, eventdata, handles)
