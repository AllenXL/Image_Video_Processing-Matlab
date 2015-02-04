function varargout = show2(varargin)
global x;
global y;
global himage;
global first;
%SHOW2 M-file for show2.fig
%      SHOW2, by itself, creates a new SHOW2 or raises the existing
%      singleton*.
%
%      H = SHOW2 returns the handle to a new SHOW2 or the handle to
%      the existing singleton*.
%
%      SHOW2('Property','Value',...) creates a new SHOW2 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to show2_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SHOW2('CALLBACK') and SHOW2('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SHOW2.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help show2

% Last Modified by GUIDE v2.5 27-Mar-2007 10:50:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @show2_OpeningFcn, ...
                   'gui_OutputFcn',  @show2_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before show2 is made visible.
function show2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
global first;
global particleNum;
global frameNum;
global particleWidth;
global particleHigh;
global weigthError;
% Choose default command line output for show2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes show2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%my add
axes(handles.axes1);
axis([0 384 0 288]);

%initial
particleNum=500;
frameNum=100;
particleWidth=20;
particleHigh=20;
weigthError=0.20;
set(handles.particleNum,'String',num2str(particleNum));
set(handles.frameNum,'String',num2str(frameNum));
set(handles.particleWidth,'String',num2str(particleWidth));
set(handles.particleHigh,'String',num2str(particleHigh));
set(handles.weigthError,'String',num2str(weigthError));
%
% --- Outputs from this function are returned to the command line.
function varargout = show2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% axes(handles.axes1);
% axis([0 726 0 578]);
% point=get(hObject,'CurrentPoint');
% x=point(1,1);
% y=point(1,2);
% cenx=x-5;
% ceny=y-5;
% rectangle('Position',[cenx,ceny,10,10],'FaceColor','r');
% x1=num2str(x);
% y1=num2str(y);
% pp=['x=',x1,'/','y=',y1];
% msgbox(pp,'Information','non-modal');
%axes(handles.axes1);
%rectangle('Position',[x,y,0.1,0.1],'FaceColor','r');
%x=int16(point(1,1)*726)
%y=int16(point(1,2)*578)
%axes(handles.axes1);
%rectangle('Position',[0.05,0.05,0.01,0.01],'FaceColor','r');
%window=get(hObject.axes1,'Position');

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global first;
global pathname;
global filenamelength;
global bFirst;
bFirst=0;
[filename, pathname]=uigetfile('*.bmp', 'Pick an bmp-file');
axes(handles.axes1);
himage=imshow([pathname '\' filename]);
[value name] = strread(filename, '%d.%s')
first=value;
filenamelength=length(filename);
filenamelength=filenamelength-4;
% handle= guihandles;
set(handles.InitPicInfo,'String',[pathname '\' filename]);
% axes(handles.axes1);
% axis([0 726 0 578]);
% rectangle('Position',[x,y,50,50],'FaceColor','r');


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global y;
global himage;
axes(handles.axes1);
% axis([0 726 0 578]);
point=get(handles.axes1,'CurrentPoint');
cenx=point(1,1);
ceny=point(1,2);
cenx=int16(cenx);
ceny=int16(ceny);
x=cenx-3;
y=ceny-3;
rectangle('Position',[x,y,6,6],'FaceColor','r');

set(handles.x1,'String',['     X:    ' num2str(x)]);
set(handles.y1,'String',['    Y:    ' num2str(y)]);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global y;
global first;
global particleNum;
global frameNum;
global particleWidth;
global particleHigh;
global weigthError;
hx=20;hy=20;N=500;n=2;new_sita=0.20;
Estimate=tracker(x,y,particleWidth,particleHigh,particleNum,first,frameNum,weigthError);


function particleNum_Callback(hObject, eventdata, handles)
% hObject    handle to particleNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of particleNum as text
%        str2double(get(hObject,'String')) returns contents of particleNum as a double
global particleNum;
particleNum=str2num(get(hObject,'String'));
% --- Executes during object creation, after setting all properties.
function particleNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to particleNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frameNum_Callback(hObject, eventdata, handles)
% hObject    handle to frameNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameNum as text
%        str2double(get(hObject,'String')) returns contents of frameNum as a double
global frameNum;
frameNum=str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function frameNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function weigth_Callback(hObject, eventdata, handles)
% hObject    handle to weigth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of weigth as text
%        str2double(get(hObject,'String')) returns contents of weigth as a double
global weigthError;
weigthError=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function weigth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weigth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
global particleWidth;
particleWidth=str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function particleHigh_Callback(hObject, eventdata, handles)
% hObject    handle to particleHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of particleHigh as text
%        str2double(get(hObject,'String')) returns contents of particleHigh as a double
global particleHigh;
particleHigh=str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function particleHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to particleHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mycallback(hObject, eventdata, handles)
% r1=int16(rand(1)*500);
% %r2=int16(rand(1)*500);
% r2=100;
% r2=r2+10;
% rectangle('Position',[r1,r2,6,6],'FaceColor','r');
% global first;
% 
% first=first+1;
% name=num2str(first,'%04.4g');
% firstname=[name,'.jpg'];
% I=imread(firstname);
% hh=get(hObject, 'UserData');
% axes(hh.axes1);
% imshow(I);
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global t;
% t=timer('TimerFcn',@mycallback,'Period',0.020,'ExecutionMode','fixedSpacing','TasksToExecute',100,'UserData',handles);
% start(t);


% for i=200:1:250;
% pause(0.025);
% pause on;
% name=num2str(i,'%04.4g');
% firstname=[name,'.jpg'];
% I=imread(firstname);
% % hh=get(hObject, 'UserData');
% % axes(hh.axes1);
% imshow(I);
% drawnow;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global v_count;
global matrix;
global x;
global y;
global first;
global particleNum;
global frameNum;
global particleWidth;
global particleHigh;
global weigthError;

global pathname;
global bExit;
global filenamelength;
bExit=0;
hx=particleWidth;hy=particleHigh;N=particleNum;n=frameNum;new_sita=weigthError;
v_count=512;
matrix=1:1:v_count;   %%%%%maybe it should be changed to global variable

Hx=int16(hx);
Hy=int16(hy);
vx=0;
vy=0;
switch filenamelength
    case 4
         name=num2str(first,'%04.4g');
    case 5
        name=num2str(first,'%05.4g');
end
firstname=[name,'.bmp'];
I=imread([pathname firstname]);

info = imfinfo([pathname firstname]);
image_boundary_x=int16(info.Width);%int16(700); 
image_boundary_y=int16(info.Height);%int16(550);

[Sample_Set,Sample_probability,Estimate,target_histgram]=initial_2(x,y,Hx,Hy,vx,vy,I,N);

for loop=2:1:n;
    if(bExit>0)
        first=loop+first-1;
        break;
    end
    if Estimate(loop-1).prob>=0.05
       k=target_histgram;
       %target_histgram=0.8*k+0.2*Estimate(loop-1).histgram;
       %if(loop<100)
         target_histgram=0.90*k+0.10*Estimate(loop-1).histgram;
%        elseif(loop<200)
%            new_sita=0.25;
%          target_histgram=0.99*k+0.01*Estimate(loop-1).histgram;  
%        elseif(loop<280)
%             new_sita=0.30;
%          target_histgram=0.99*k+0.01*Estimate(loop-1).histgram; 
%        else
%             new_sita=0.30;
%          target_histgram=0.99*k+0.01*Estimate(loop-1).histgram; 
      % end
    switch filenamelength
        case 4
           a=num2str(loop+first-1,'%04.4g');
        case 5
           a=num2str(loop+first-1,'%05.4g');
    end
    %a=num2str(loop+first-1,'%0.4g');
    b=[a,'.jpg'];
    I=imread([pathname '\' b]);
    %I=imread(b);
    set(handles.textCurrentFile,'String',b);
    
   New_Sample_Set=Select(Sample_Set,Sample_probability,loop,I,N);
   [Sample_Set,after_prop]=Propagation(New_Sample_Set,Hx,Hy,vx,vy,image_boundary_x,image_boundary_y,I,N);
   [Sample_probability,Estimate,vx,vy,TargetPic]=Observe_and_Estimate(Sample_Set,Estimate,Hx,Hy,target_histgram,new_sita,loop,after_prop,I,N);
   
    else 
        %a=0;
        msgbox('Ä¿±ê¶ªÊ§!');
        first=loop+first-1;
        return;
    end
  set(handles.x2,'String',['     X:    ' num2str(int16(Estimate(loop).x))]);
  set(handles.y2,'String',['    Y:    ' num2str(int16(Estimate(loop).y))]);
  imshow(TargetPic);
  drawnow;
end
msgbox('¸ú×Ù½áÊø!');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stop(t);
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t bExit;
bExit=1;
delete(t);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global v_count;
global matrix;
global x;
global y;
global first;
global particleNum;
global frameNum;
global particleWidth;
global particleHigh;
global weigthError;

global pathname;
global bExit;
global filenamelength;
global bFirst;
global loop;
global N n new_sita Hx Hy vx vy  image_boundary_x image_boundary_y Sample_Set Sample_probability Estimate target_histgram;
if(bFirst==0)
    bExit=0;
    bFirst=1
    hx=particleWidth;hy=particleHigh;N=particleNum;n=frameNum;new_sita=weigthError;
    v_count=512;
    matrix=1:1:v_count;   %%%%%maybe it should be changed to global variable





    Hx=int16(hx);
    Hy=int16(hy);
    vx=0;
    vy=0;
    switch filenamelength
        case 4
             name=num2str(first,'%04.4g');
        case 5
            name=num2str(first,'%05.4g');
    end
    firstname=[name,'.bmp'];
    I=imread([pathname '\' firstname]);

    info = imfinfo([pathname '\' firstname]);
    image_boundary_x=int16(info.Width);%int16(700); 
    image_boundary_y=int16(info.Height);%int16(550);

    [Sample_Set,Sample_probability,Estimate,target_histgram]=initial_2(x,y,Hx,Hy,vx,vy,I,N);
    loop=2;
end

%for loop=2:1:n;
loop
    if(bExit>0)
        first=loop+first-1;
        %break;
    end
    if Estimate(loop-1).prob>=0.2%0.05
       k=target_histgram;
       %target_histgram=0.8*k+0.2*Estimate(loop-1).histgram;
       %if(loop<100)
         target_histgram=0.90*k+0.10*Estimate(loop-1).histgram;
%        elseif(loop<200)
%            new_sita=0.25;
%          target_histgram=0.99*k+0.01*Estimate(loop-1).histgram;  
%        elseif(loop<280)
%             new_sita=0.30;
%          target_histgram=0.99*k+0.01*Estimate(loop-1).histgram; 
%        else
%             new_sita=0.30;
%          target_histgram=0.99*k+0.01*Estimate(loop-1).histgram; 
      % end
    switch filenamelength
        case 4
           a=num2str(loop+first-1,'%04.4g');
        case 5
           a=num2str(loop+first-1,'%05.4g');
    end
    %a=num2str(loop+first-1,'%0.4g');
    b=[a,'.bmp'];
    I=imread([pathname '\' b]);
    %I=imread(b);
    set(handles.textCurrentFile,'String',b);
    
   New_Sample_Set=Select(Sample_Set,Sample_probability,loop,I,N);
   [Sample_Set,after_prop]=Propagation(New_Sample_Set,Hx,Hy,vx,vy,image_boundary_x,image_boundary_y,I,N);
   [Sample_probability,Estimate,vx,vy,TargetPic]=Observe_and_Estimate(Sample_Set,Estimate,Hx,Hy,target_histgram,new_sita,loop,after_prop,I,N);
   
    else 
        %a=0;
       % msgbox('Ä¿±ê¶ªÊ§!');
       % first=loop+first-1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        k=target_histgram;
        target_histgram=0.99*k+0.01*Estimate(loop-1).histgram;
        switch filenamelength
            case 4
               a=num2str(loop+first-1,'%04.4g');
            case 5
               a=num2str(loop+first-1,'%05.4g');
        end
    %a=num2str(loop+first-1,'%0.4g');
    b=[a,'.bmp'];
    I=imread([pathname '\' b]);
    %I=imread(b);
    set(handles.textCurrentFile,'String',b);
    
   New_Sample_Set=Select(Sample_Set,Sample_probability,loop,I,N);
   [Sample_Set,after_prop]=Propagation(New_Sample_Set,Hx,Hy,vx,vy,image_boundary_x,image_boundary_y,I,N);
   [Sample_probability,Estimate,vx,vy,TargetPic]=Observe_and_Estimate(Sample_Set,Estimate,Hx,Hy,target_histgram,new_sita,loop,after_prop,I,N);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %   return;
    end
  set(handles.x2,'String',['     X:    ' num2str(int16(Estimate(loop).x))]);
  set(handles.y2,'String',['    Y:    ' num2str(int16(Estimate(loop).y))]);
  imshow(TargetPic);
  drawnow;
  loop=loop+1;
%end
%msgbox('¸ú×Ù½áÊø!');

