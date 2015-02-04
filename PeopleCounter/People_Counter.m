function varargout = People_Counter(varargin)
% PEOPLE_COUNTER M-file for People_Counter.fig
%      PEOPLE_COUNTER, by itself, creates a new PEOPLE_COUNTER or raises the existing
%      singleton*.
%
%      H = PEOPLE_COUNTER returns the handle to a new PEOPLE_COUNTER or the handle to
%      the existing singleton*.
%
%      PEOPLE_COUNTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK enter PEOPLE_COUNTER.M with the given input arguments.
%
%      PEOPLE_COUNTER('Property','Value',...) creates a new PEOPLE_COUNTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before People_Counter_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to People_Counter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help People_Counter

% Last Modified by GUIDE v2.5 05-Jul-2008 15:03:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn',...
                   @People_Counter_OpeningFcn, ...
                   'gui_OutputFcn',...
                   @People_Counter_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State,...
        varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
%==========================================================================


%==========================================================================
% --- Executes just before People_Counter is made visible.
function People_Counter_OpeningFcn(hObject,...
    eventdata, handles, varargin)
handles.output = hObject;
handles.background=ones(576,720);
axes(handles.display);
imshow(handles.background);
handles.background2=ones(288,690);
axes(handles.nsd_window_plot);
imshow(handles.background2);
handles.threshold=50;
handles.fps='10';
handles.width=720;
handles.height=576;
handles.h_w=180;
handles.w_w=288;
handles.x1_w=20;
handles.x2_w=20;
handles.x3_w=380;
handles.x4_w=380;
handles.y1_w=20;
handles.y2_w=308;
handles.y3_w=20;
handles.y4_w=308;
handles.rect1=[ceil(handles.x1_w/720*handles.width) ceil(handles.y1_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.rect2=[ceil(handles.x2_w/720*handles.width) ceil(handles.y2_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.rect3=[ceil(handles.x3_w/720*handles.width) ceil(handles.y3_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.rect4=[ceil(handles.x4_w/720*handles.width) ceil(handles.y4_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.crop1=[handles.rect1(1) handles.rect1(2) (handles.rect1(3)-1)...
    (handles.rect1(4)-1)];
handles.crop2=[handles.rect2(1) handles.rect2(2) (handles.rect2(3)-1)...
    (handles.rect2(4)-1)];
handles.crop3=[handles.rect3(1) handles.rect3(2) (handles.rect3(3)-1)...
    (handles.rect3(4)-1)];
handles.crop4=[handles.rect4(1) handles.rect4(2) (handles.rect4(3)-1)...
    (handles.rect4(4)-1)];
handles.area=ceil(handles.w_w/720*handles.width)* ceil(handles.h_w/576*handles.height);
handles.position=[handles.rect1; handles.rect2; handles.rect3; handles.rect4];
axes(handles.display);
rectangle('Position',handles.rect1,...
    'edgecolor', 'r');
rectangle('Position',handles.rect2,...
    'edgecolor', 'r');
rectangle('Position',handles.rect3,...
    'edgecolor', 'r');
rectangle('Position',handles.rect4,...
    'edgecolor', 'r');
set(handles.slider_exposure,'Enable','inactive');
set(handles.slider_brightness,'Enable','inactive');
set(handles.slider_saturation,'Enable','inactive');
set(handles.slider_pan,'Enable','inactive');
set(handles.slider_tilt,'Enable','inactive');
set(handles.slider_zoom,'Enable','inactive'); 
% Update handles structure
guidata(hObject, handles);
% --- Outputs from this function are returned to the command line.
function varargout = People_Counter_OutputFcn...
    (hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined enter a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get pushbutton9 command line output from handles structure
varargout{1} = handles.output;
%==========================================================================


%==========================================================================
% --- Executes on button press enter start.
function start_Callback(hObject, eventdata, handles)
if strcmp(get(handles.start,'string'),'Preview')
    set(handles.start,'string','Start');
    set(handles.plot_nsd,'Enable','inactive');
    set(handles.exp_mode,'Enable','on');
    set(handles.nsd_plot,'Value',1);    
    axes(handles.nsd_window_plot);
    imshow(handles.background2);
    try
        axes(handles.display);
        hImage=image(zeros(handles.height,handles.width,3)); 
        handles.vid_ycc=videoinput('winvideo',1,...
            sprintf('I420_%sx%s',num2str(handles.width),...
            num2str(handles.height)));        
        handles.vid_rgb=videoinput('winvideo',1,...
            sprintf('RGB24_%sx%s',num2str(handles.width),...
            num2str(handles.height)));
        src_rgb=getselectedsource(handles.vid_rgb);
        src_rgb.ExposureMode='manual';
        src_rgb.PanMode='manual';
        src_rgb.TiltMode='manual';
        src_rgb.ZoomMode='manual';
        src_rgb.ExposureMode='auto';
        src_rgb.FrameRate=handles.fps;
        set(handles.value_exposure,'String','n/a');
        src_rgb.Brightness=127;
        set(handles.slider_brightness,'Enable','on',...
            'Value',(src_rgb.Brightness));
        set(handles.value_brightness,'String',...
            num2str(src_rgb.Brightness));
        src_rgb.Saturation=32;
        set(handles.slider_saturation,'Enable','on',...
            'Value',(src_rgb.Saturation)); 
        set(handles.value_saturation,'String',...
            num2str(src_rgb.Saturation));
        src_rgb.Pan=0;
        set(handles.slider_pan,'Enable','on',...
            'Value',(src_rgb.Pan));
        set(handles.value_pan,'String',...
            num2str(src_rgb.Pan));
        src_rgb.Tilt=0;
        set(handles.slider_tilt,'Enable','on',...
            'Value',(src_rgb.Tilt));
        set(handles.value_tilt,'String',...
            num2str(src_rgb.Tilt));
        src_rgb.Zoom=50;
        set(handles.slider_zoom,'Enable','on',...
            'Value',(src_rgb.Zoom));
        set(handles.value_zoom,'String',...
            num2str(src_rgb.Zoom/50));
        preview(handles.vid_rgb,hImage);
        rectangle('Position',handles.rect1,...
                    'edgecolor', 'r');
        rectangle('Position',handles.rect2,...
                    'edgecolor', 'r');
        rectangle('Position',handles.rect3,...
                    'edgecolor', 'r');
        rectangle('Position',handles.rect4,...
                    'edgecolor', 'r');
    catch
        set(handles.start,'string','Preview');
        axes(handles.display);
        imshow(ones(handles.height, handles.width));        
        rectangle('Position',handles.rect1,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect2,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect3,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect4,...
            'edgecolor', 'r');
        errordlg('ERROR! Unable to access Logitech Pro 5000',...
            'Attention','modal');
    end
elseif strcmp(get(handles.start,'string'),'Start')
    set(handles.start,'string','Stop');
    set(handles.slider_exposure,'Enable','inactive');
    set(handles.exp_mode,'Enable','inactive');
    set(handles.slider_brightness,'Enable','inactive');
    set(handles.slider_saturation,'Enable','inactive');
    set(handles.slider_pan,'Enable','inactive');
    set(handles.slider_tilt,'Enable','inactive');
    set(handles.slider_zoom,'Enable','inactive'); 
    set(handles.frame_rate,'Enable','inactive');
    set(handles.slider_win_height,'enable','inactive');
    set(handles.slider_win_width,'enable','inactive');
    set(handles.slider_win_pan,'enable','inactive');
    set(handles.slider_win_tilt,'enable','inactive');
    set(handles.win_position,'enable','inactive');
    try
        src_rgb=getselectedsource(handles.vid_rgb); 
        exp_val=src_rgb.Exposure;
        bright_val=src_rgb.Brightness;
        sat_val=src_rgb.Saturation;
        pan_val=src_rgb.Pan;
        tilt_val=src_rgb.Tilt;
        zoom_val=src_rgb.Zoom;
        fr_val=src_rgb.FrameRate;
        stoppreview(handles.vid_rgb);
        delete(handles.vid_rgb);        
        src_ycc=getselectedsource(handles.vid_ycc);
        if get(handles.exp_mode,'Value')==0
            src_ycc.ExposureMode='manual';            
            src_ycc.Exposure=exp_val;
        elseif get(handles.exp_mode,'Value')==1
            src_ycc.ExposureMode='auto';
        end
        set(handles.vid_ycc,'LoggingMode','memory');
        set(handles.vid_ycc,'TriggerRepeat',Inf);
        set(handles.vid_ycc,'FramesPerTrigger',1);
        triggerconfig(handles.vid_ycc, 'Manual');
        src_ycc.PanMode='manual';
        src_ycc.TiltMode='manual';
        src_ycc.ZoomMode='manual';
        src_ycc.FrameRate=fr_val;        
        src_ycc.Brightness=bright_val;        
        src_ycc.Saturation=sat_val;        
        src_ycc.Pan=pan_val;        
        src_ycc.Tilt=tilt_val;        
        src_ycc.Zoom=zoom_val;
        start(handles.vid_ycc);
        trigger(handles.vid_ycc);
        data=getdata(handles.vid_ycc,1);
        load nsd_plot;
        load record;
        nsd_a=[];
        nsd_b=[];
        nsd_c=[];
        nsd_d=[];
        frame=[];
        absis=[];       
        people_in=0;
        people_out=0;
        total_people=0;
        stat_a=0;
        stat_b=0;
        stat_c=0;
        stat_d=0;  
        event_frame_a=0;
        event_frame_b=0;
        event_frame_c=0;
        event_frame_d=0;
        detect_frame_a=0;
        detect_frame_b=0;
        detect_frame_c=0;
        detect_frame_d=0;
        frame_tail=floor(str2num(handles.fps)/2);
        frame_out=floor(1.5*str2num(handles.fps));
        set(handles.enter,'String',num2str(people_in));
        set(handles.exit,'String',num2str(people_in));
        set(handles.total_traffic,'String',num2str(total_people));
        while strcmp(get(handles.start,'string'),'Stop')
%         tic
            trigger(handles.vid_ycc);
            prev_data=data;
            current_frame=handles.vid_ycc.FramesAcquired;
            frame=[frame current_frame];
            if strcmp(get(handles.start,'string'),'Preview')
            else
                data=getdata(handles.vid_ycc,1);
                axes(handles.display);
                imshow(data(:,:,1));
                rectangle('Position',handles.rect1,...
                    'edgecolor', 'r');
                rectangle('Position',handles.rect2,...
                    'edgecolor', 'r');
                rectangle('Position',handles.rect3,...
                    'edgecolor', 'r');
                rectangle('Position',handles.rect4,...
                    'edgecolor', 'r');
                diff=imabsdiff(data,prev_data);
                diff_a=sum(sum(imcrop(diff(:,:,1),handles.crop1)))/handles.area;
                diff_b=sum(sum(imcrop(diff(:,:,1),handles.crop2)))/handles.area;
                diff_c=sum(sum(imcrop(diff(:,:,1),handles.crop3)))/handles.area;
                diff_d=sum(sum(imcrop(diff(:,:,1),handles.crop4)))/handles.area;
                nsd_a=[nsd_a diff_a];
                nsd_b=[nsd_b diff_b];
                nsd_c=[nsd_c diff_c];
                nsd_d=[nsd_d diff_d];
                if current_frame>=20
                    choice=get(handles.nsd_plot,'Value');
                    axes(handles.nsd_window_plot); 
                    absis=[current_frame-19:current_frame];
                    threshold=round(get(handles.slider_threeshold,'Value'));
                    thresh_line=threshold*ones(1,20);
                    if choice==1
                        try
                            plot(absis,nsd_a(current_frame-19:current_frame),...
                                absis,nsd_b(current_frame-19:current_frame),...
                                absis,nsd_c(current_frame-19:current_frame),...
                                absis,nsd_d(current_frame-19:current_frame),...
                                absis,thresh_line);
                            set(gca,'YLim',[0 150],...
                                'XLim', [(current_frame-19) current_frame],...
                                'XTick', [(current_frame-19) (current_frame-13)...
                                (current_frame-7) current_frame]);
                        end
                    elseif choice==2
                        try
                            plot(absis,nsd_a(current_frame-19:current_frame),absis,thresh_line);
                            set(gca,'YLim',[0 150],...
                                'XLim', [(current_frame-19) current_frame],...
                                'XTick', [(current_frame-19) (current_frame-13)...
                                (current_frame-7) current_frame]);
                        end
                    elseif choice==3
                        try
                            plot(absis,nsd_b(current_frame-19:current_frame),absis,thresh_line);
                            set(gca,'YLim',[0 150],...
                                'XLim', [(current_frame-19) current_frame],...
                                'XTick', [(current_frame-19) (current_frame-13)...
                                (current_frame-7) current_frame]);
                        end
                    elseif choice==4
                        try
                            plot(absis,nsd_c(current_frame-19:current_frame),absis,thresh_line);
                            set(gca,'YLim',[0 150],...
                                'XLim', [(current_frame-19) current_frame],...
                                'XTick', [(current_frame-19) (current_frame-13)...
                                (current_frame-7) current_frame]);
                        end
                    elseif choice==5
                        try
                            plot(absis,nsd_d(current_frame-19:current_frame),absis,thresh_line);
                            set(gca,'YLim',[0 150],...
                                'XLim', [(current_frame-19) current_frame],...
                                'XTick', [(current_frame-19) (current_frame-13)...
                                (current_frame-7) current_frame]);
                        end
                    elseif choice==6                        
                    end
                    if diff_a>=threshold && stat_a==0 && stat_b==0
                        set(handles.in_left,'Backgroundcolor',[1 0 0]);
                        stat_a=2;
                        stat_b=1;
                        detect_frame_a=current_frame;
                    elseif stat_a==2 && detect_frame_a+frame_out==current_frame
                        set(handles.in_left,'Backgroundcolor',[1 1 1]);
                        detect_frame_a=0;
                        event_frame_a=0;
                        stat_a=0;
                        stat_b=0;
                    elseif diff_a>=threshold && stat_a==1 && event_frame_a==0
                        event_frame_a=current_frame;                    
                    elseif diff_a<threshold && stat_a==1 && event_frame_a~=0
                        people_out=people_out+1;
                        total_people=people_in+people_out;
                        set(handles.exit,'String',num2str(people_out));
                        set(handles.total_traffic,'String',num2str(total_people));
                        set(handles.ext_left,'Backgroundcolor',[1 1 1]);
                        detect_frame_a=0;
                        event_frame_a=0;
                        stat_a=0;
                        stat_b=0;                    
                    end
                    if diff_b>=threshold && stat_b==0 && stat_a==0
                        set(handles.ext_left,'Backgroundcolor', [1 0 0]);
                        stat_b=2;
                        stat_a=1;
                        detect_frame_b=current_frame;
                    elseif stat_b==2 && detect_frame_b+frame_out==current_frame
                        set(handles.ext_left,'Backgroundcolor',[1 1 1]);
                        detect_frame_b=0;
                        event_frame_b=0;
                        stat_a=0;
                        stat_b=0;
                    elseif diff_b>=threshold && stat_b==1 && event_frame_b==0
                        event_frame_b=current_frame;                    
                    elseif diff_b<threshold && stat_b==1 && event_frame_b~=0
                        people_in=people_in+1;
                        total_people=people_in+people_out;
                        set(handles.enter,'String',num2str(people_in));
                        set(handles.total_traffic,'String',num2str(total_people));
                        set(handles.in_left,'Backgroundcolor',[1 1 1]);
                        detect_frame_b=0;
                        event_frame_b=0;
                        stat_a=0;
                        stat_b=0;
                    end
                    if diff_c>=threshold && stat_c==0 && stat_d==0
                        set(handles.in_right,'Backgroundcolor',[1 0 0]);
                        stat_c=2;
                        stat_d=1;
                        detect_frame_c=current_frame;
                    elseif stat_c==2 && detect_frame_c+frame_out==current_frame
                        set(handles.in_right,'Backgroundcolor',[1 1 1]);
                        detect_frame_c=0;
                        event_frame_c=0;
                        stat_c=0;
                        stat_d=0;
                    elseif diff_c>=threshold && stat_c==1 && event_frame_c==0
                        event_frame_c=current_frame;
                    elseif diff_c<threshold && stat_c==1 && event_frame_c~=0
                        people_out=people_out+1;
                        total_people=people_in+people_out;
                        set(handles.exit,'String',num2str(people_out));
                        set(handles.total_traffic,'String',num2str(total_people));
                        set(handles.ext_right,'Backgroundcolor',[1 1 1]);
                        detect_frame_c=0;
                        event_frame_c=0;
                        stat_c=0;
                        stat_d=0;
                    end
                    if diff_d>=threshold && stat_d==0 && stat_c==0
                        set(handles.ext_right,'Backgroundcolor', [1 0 0]);
                        stat_d=2;
                        stat_c=1;
                        detect_frame_d=current_frame;
                    elseif stat_d==2 && detect_frame_d+frame_out==current_frame
                        set(handles.ext_right,'Backgroundcolor',[1 1 1]);
                        detect_frame_d=0;
                        event_frame_d=0;
                        stat_c=0;
                        stat_d=0;
                    elseif diff_d>=threshold && stat_d==1 && event_frame_d==0
                        event_frame_d=current_frame;
                    elseif diff_d<threshold && stat_d==1 && event_frame_d~=0
                        people_in=people_in+1;
                        total_people=people_in+people_out;
                        set(handles.enter,'String',num2str(people_in));
                        set(handles.total_traffic,'String',num2str(total_people));
                        set(handles.in_right,'Backgroundcolor',[1 1 1]);
                        detect_frame_d=0;
                        event_frame_d=0;
                        stat_c=0;
                        stat_d=0;                                        
                    end
%                     toc
                end
            end
            save ('nsd_plot', 'frame', 'nsd_a', 'nsd_b', 'nsd_c', 'nsd_d');
            save ('record', 'people_in', 'people_out', 'total_people');
        end        
    end
elseif strcmp(get(handles.start,'string'),'Stop')
    set(handles.start,'string','Preview'); 
    set(handles.plot_nsd,'Enable','on');
    set(handles.frame_rate,'Enable','on');
    set(handles.slider_win_height,'enable','on');
    set(handles.slider_win_width,'enable','on');
    set(handles.slider_win_pan,'enable','on');
    set(handles.slider_win_tilt,'enable','on');
    set(handles.win_position,'enable','on');
    set(handles.in_left,'Backgroundcolor',[1 1 1]);
    set(handles.ext_left,'Backgroundcolor',[1 1 1]);
    set(handles.in_right,'Backgroundcolor',[1 1 1]);
    set(handles.ext_right,'Backgroundcolor',[1 1 1]);
    try
        stop(handles.vid_ycc);
        flushdata(handles.vid_ycc);
        delete(handles.vid_ycc);
    end
    axes(handles.display);
    imshow(ones(handles.height, handles.width));
    axes(handles.nsd_window_plot);
    cla;
    cla;
end
% Update handles structure
guidata(hObject, handles);
%==========================================================================


%==========================================================================
% --- Executes on button press enter close.
function close_Callback(hObject, eventdata, handles)
try
    delete(handles.vid_rgb);
catch
    try
        stop(handles.vid_ycc);
        delete(handles.vid_ycc);
    end        
end
clear all;
close(gcf);
%==========================================================================


%==========================================================================
% --- Executes on slider movement.
function slider_exposure_Callback(hObject, eventdata, handles)
src_rgb=getselectedsource(handles.vid_rgb);
exp_value=round(get(handles.slider_exposure,...
    'Value'));
set(handles.value_exposure,'String',...
    num2str(exp_value));
src_rgb.Exposure=exp_value;
% Update handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function slider_exposure_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%==========================================================================


%==========================================================================
% --- Executes on slider movement.
function slider_brightness_Callback(hObject,...
    eventdata, handles)
src_rgb=getselectedsource(handles.vid_rgb);
bright_value=round(get(handles.slider_brightness,...
    'Value'));
set(handles.value_brightness,'String',...
    num2str(bright_value));
src_rgb.Brightness=bright_value;
% Update handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function slider_brightness_CreateFcn(hObject,...
    eventdata, handles)
if isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%==========================================================================


%==========================================================================
% --- Executes on slider movement.
function slider_saturation_Callback(hObject,...
    eventdata, handles)
src_rgb=getselectedsource(handles.vid_rgb);
saturat_value=round(get(handles.slider_saturation,...
    'Value'));
set(handles.value_saturation,'String',...
    num2str(saturat_value));
src_rgb.Saturation=saturat_value;
% Update handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function slider_saturation_CreateFcn(hObject,...
    eventdata, handles)
if isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%==========================================================================


%==========================================================================
% --- Executes on slider movement.
function slider_pan_Callback(hObject,...
    eventdata, handles)
src_rgb=getselectedsource(handles.vid_rgb);
pan_value=round(get(handles.slider_pan,'Value'));
set(handles.value_pan,'String',num2str(pan_value));
src_rgb.Pan=pan_value;
% Update handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function slider_pan_CreateFcn(hObject,...
    eventdata, handles)
if isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%==========================================================================


%==========================================================================
% --- Executes on slider movement.
function slider_tilt_Callback(hObject,...
    eventdata, handles)
src_rgb=getselectedsource(handles.vid_rgb);
tilt_value=round(get(handles.slider_tilt,'Value'));
set(handles.value_tilt,'String',num2str(tilt_value));
src_rgb.Tilt=tilt_value;
% Update handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function slider_tilt_CreateFcn(hObject,...
    eventdata, handles)
if isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%==========================================================================


%==========================================================================
% --- Executes on slider movement.
function slider_zoom_Callback(hObject,...
    eventdata, handles)
src_rgb=getselectedsource(handles.vid_rgb);
zoom_value=round(get(handles.slider_zoom,'Value'));
set(handles.value_zoom,'String',num2str(zoom_value/50));
src_rgb.Zoom=zoom_value;
% Update handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function slider_zoom_CreateFcn(hObject,...
    eventdata, handles)
if isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%==========================================================================


%==========================================================================
% --- Executes on slider movement.
function slider_threeshold_Callback(hObject, eventdata, handles)
threshold_value=round(get(handles.slider_threeshold,'Value'));
handles.threshold=threshold_value;
set(handles.value_threshold,'String',num2str(handles.threshold));
% Update handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function slider_threeshold_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%==========================================================================


%==========================================================================
% --- Executes on selection change enter frame_rate.
function frame_rate_Callback(hObject, eventdata, handles)
try
    src_rgb=getselectedsource(handles.vid_rgb);
catch
    try
        src_ycc=getselectedsource(handles.vid_ycc);
    end
end
rate=get(handles.frame_rate,'value');
switch rate
    case 1
        handles.fps='5';
        try
            src_rgb.FrameRate=handles.fps;
        catch
            src_ycc.FrameRate=handles.fps;
        end
    case 2
        handles.fps='10';
        try
            src_rgb.FrameRate=handles.fps;
        catch
            src_ycc.FrameRate=handles.fps;
        end
    case 3
        handles.fps='20';
        try
            src_rgb.FrameRate=handles.fps;
        catch
            src_ycc.FrameRate=handles.fps;
        end
    case 4
        handles.fps='30';
        try
            src_rgb.FrameRate=handles.fps;
        catch
            src_ycc.FrameRate=handles.fps;
        end
end
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function frame_rate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================


%==========================================================================
% --- Executes on button press enter plot_nsd.
function plot_nsd_Callback(hObject, eventdata, handles)
load nsd_plot
length=size(frame);
thresh_line=round(get(handles.slider_threeshold,'Value'))*ones(1,length(2));
if get(handles.nsd_plot,'value')== 1 || get(handles.nsd_plot,'value')== 6
    figure('name', 'Plot NSD','NumberTitle','off');
    subplot(3,1,1);plot(frame,nsd_a,frame,nsd_b,frame,nsd_c,frame,nsd_d,...
        frame,thresh_line);
    legend('NSD A', 'NSD B','NSD C', 'NSD D', 'Threshold');
    set(gca,'YLim',[0 150]); xlabel('Frame');ylabel('NSD');
    subplot(3,1,2);plot(frame,nsd_a,frame,nsd_b,frame,thresh_line);
    set(gca,'YLim',[0 150]); xlabel('Frame');ylabel('Window A&B');
    legend('NSD A', 'NSD B', 'Threshold');
    subplot(3,1,3);plot(frame,nsd_c,frame,nsd_d,frame,thresh_line);
    set(gca,'YLim',[0 150]); xlabel('Frame');ylabel('Window C&D');
    legend('NSD C', 'NSD D', 'Threshold');
elseif get(handles.nsd_plot,'value')==2 || get(handles.nsd_plot,'value')==3
    figure('name', 'Plot NSD Window A and B','NumberTitle','off');
    plot(frame,nsd_a, frame,nsd_b, frame,thresh_line);
    legend('NSD A', 'NSD B', 'Threshold');
    set(gca,'YLim',[0 150]); xlabel('Frame');ylabel('NSD');
elseif get(handles.nsd_plot,'value')== 4 || get(handles.nsd_plot,'value')==5
    figure('name', 'Plot NSD Window C and D','NumberTitle','off');
    plot(frame,nsd_c, frame,nsd_d, frame,thresh_line);
    legend('NSD C', 'NSD D', 'Threshold');
    set(gca,'YLim',[0 150]); xlabel('Frame');ylabel('NSD');
end

% figure('name','Plot NSD Window_A (Left Up)','NumberTitle','off'); 
% plot(frame,nsd_a,frame,thresh_line);set(gca,'YLim',[0 150]); 
% xlabel('Frame');ylabel('NSD Window A');legend('NSD A', 'Threshold');
% figure('name','Plot NSD Window_B (Left Bottom)','NumberTitle','off'); 
% plot(frame,nsd_b,frame,thresh_line);set(gca,'YLim',[0 150]); 
% xlabel('Frame');ylabel('NSD Window B');legend('NSD B', 'Threshold');
% figure('name','Plot NSD Window_C (Right Up)','NumberTitle','off'); 
% plot(frame,nsd_c,frame,thresh_line);set(gca,'YLim',[0 150]); 
% xlabel('Frame');ylabel('NSD Window C');legend('NSD C', 'Threshold');
% figure('name','Plot NSD Window_D (Right Bottom)','NumberTitle','off'); 
% plot(frame,nsd_d,frame,thresh_line);set(gca,'YLim',[0 150]); 
% xlabel('Frame');ylabel('NSD Window D');legend('NSD D', 'Threshold');
guidata(hObject,handles);
%==========================================================================


%==========================================================================
% --- Executes on button press enter exp_mode.
function exp_mode_Callback(hObject, eventdata, handles)
src_rgb=getselectedsource(handles.vid_rgb);
expose=get(handles.exp_mode,'value');
switch expose
    case 0
        set(handles.slider_exposure,'Enable','on',...
            'Value',(src_rgb.Exposure));
        set(handles.value_exposure,'String',num2str(src_rgb.Exposure));
        src_rgb.ExposureMode='manual';
    case 1
        set(handles.slider_exposure,'Value',-14,...
            'Enable','inactive');
        set(handles.value_exposure,'String','n/a');
        src_rgb.ExposureMode='auto';
end
guidata(hObject,handles);
%==========================================================================


%==========================================================================
% --- Executes on selection change enter nsd_plot.
function nsd_plot_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function nsd_plot_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================


%==========================================================================
% --- Executes on selection change enter resolution.
function resolution_Callback(hObject, eventdata, handles)
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function resolution_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================


%==========================================================================
function ext_right_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function ext_right_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================


%==========================================================================
function ext_left_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function ext_left_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================


%==========================================================================
function in_left_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function in_left_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================


%==========================================================================
function in_right_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function in_right_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================


%==========================================================================
function enter_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function enter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================


%==========================================================================
function exit_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function exit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================


%==========================================================================
function total_traffic_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function total_traffic_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================


%==========================================================================
% --- Executes on slider movement.
function slider_win_height_Callback(hObject, eventdata, handles)
height_val=round(get(handles.slider_win_height,'value'));
set(handles.win_height,'string',strcat(num2str(height_val), '%'));
handles.h_w=ceil(height_val/100*(180/576*handles.height));
handles.rect1=[ceil(handles.x1_w/720*handles.width) ceil(handles.y1_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.rect2=[ceil(handles.x2_w/720*handles.width) ceil(handles.y2_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.rect3=[ceil(handles.x3_w/720*handles.width) ceil(handles.y3_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.rect4=[ceil(handles.x4_w/720*handles.width) ceil(handles.y4_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.crop1=[handles.rect1(1) handles.rect1(2) (handles.rect1(3)-1)...
    (handles.rect1(4)-1)];
handles.crop2=[handles.rect2(1) handles.rect2(2) (handles.rect2(3)-1)...
    (handles.rect2(4)-1)];
handles.crop3=[handles.rect3(1) handles.rect3(2) (handles.rect3(3)-1)...
    (handles.rect3(4)-1)];
handles.crop4=[handles.rect4(1) handles.rect4(2) (handles.rect4(3)-1)...
    (handles.rect4(4)-1)];
handles.area=ceil(handles.w_w/720*handles.width)* ceil(handles.h_w/576*handles.height);
handles.position=[handles.rect1; handles.rect2; handles.rect3; handles.rect4];
axes(handles.display);
imshow(ones(handles.height, handles.width));
rectangle('Position',handles.rect1,...
    'edgecolor', 'r');
rectangle('Position',handles.rect2,...
    'edgecolor', 'r');
rectangle('Position',handles.rect3,...
    'edgecolor', 'r');
rectangle('Position',handles.rect4,...
    'edgecolor', 'r');
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function slider_win_height_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%==========================================================================


%==========================================================================
% --- Executes on slider movement.
function slider_win_width_Callback(hObject, eventdata, handles)
width_val=round(get(handles.slider_win_width,'value'));
set(handles.win_width,'string',strcat(num2str(width_val), '%'));
handles.w_w=ceil(width_val/100*(288/720*handles.width));
handles.rect1=[ceil(handles.x1_w/720*handles.width) ceil(handles.y1_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.rect2=[ceil(handles.x2_w/720*handles.width) ceil(handles.y2_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.rect3=[ceil(handles.x3_w/720*handles.width) ceil(handles.y3_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.rect4=[ceil(handles.x4_w/720*handles.width) ceil(handles.y4_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.crop1=[handles.rect1(1) handles.rect1(2) (handles.rect1(3)-1)...
    (handles.rect1(4)-1)];
handles.crop2=[handles.rect2(1) handles.rect2(2) (handles.rect2(3)-1)...
    (handles.rect2(4)-1)];
handles.crop3=[handles.rect3(1) handles.rect3(2) (handles.rect3(3)-1)...
    (handles.rect3(4)-1)];
handles.crop4=[handles.rect4(1) handles.rect4(2) (handles.rect4(3)-1)...
    (handles.rect4(4)-1)];
handles.area=ceil(handles.w_w/720*handles.width)* ceil(handles.h_w/576*handles.height);
handles.position=[handles.rect1; handles.rect2; handles.rect3; handles.rect4];
axes(handles.display)
imshow(ones(handles.height, handles.width));
rectangle('Position',handles.rect1,...
    'edgecolor', 'r');
rectangle('Position',handles.rect2,...
    'edgecolor', 'r');
rectangle('Position',handles.rect3,...
    'edgecolor', 'r');
rectangle('Position',handles.rect4,...
    'edgecolor', 'r');
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function slider_win_width_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%==========================================================================


%==========================================================================
% --- Executes on slider movement.
function slider_win_pan_Callback(hObject, eventdata, handles)
win_choice=get(handles.win_to_set,'value');
pan_val=round(get(handles.slider_win_pan,'value'));
set(handles.win_pan,'string', strcat(num2str(pan_val), '%'));
pan_range=handles.width/2-handles.w_w;
switch win_choice
    case 1
        handles.x1_w=ceil(pan_val/100*pan_range);
        handles.x2_w=ceil(pan_val/100*pan_range);
        handles.x3_w=ceil(handles.width/2+pan_val/100*pan_range);
        handles.x4_w=ceil(handles.width/2+pan_val/100*pan_range);       
        handles.rect1=[ceil(handles.x1_w/720*handles.width) ceil(handles.y1_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.rect2=[ceil(handles.x2_w/720*handles.width) ceil(handles.y2_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.rect3=[ceil(handles.x3_w/720*handles.width) ceil(handles.y3_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.rect4=[ceil(handles.x4_w/720*handles.width) ceil(handles.y4_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.crop1=[handles.rect1(1) handles.rect1(2) (handles.rect1(3)-1)...
            (handles.rect1(4)-1)];
        handles.crop2=[handles.rect2(1) handles.rect2(2) (handles.rect2(3)-1)...
            (handles.rect2(4)-1)];
        handles.crop3=[handles.rect3(1) handles.rect3(2) (handles.rect3(3)-1)...
            (handles.rect3(4)-1)];
        handles.crop4=[handles.rect4(1) handles.rect4(2) (handles.rect4(3)-1)...
            (handles.rect4(4)-1)];
        handles.area=ceil(handles.w_w/720*handles.width)* ceil(handles.h_w/576*handles.height);
        handles.position=[handles.rect1; handles.rect2; handles.rect3; handles.rect4];
        axes(handles.display)
        imshow(ones(handles.height, handles.width));
        rectangle('Position',handles.rect1,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect2,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect3,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect4,...
            'edgecolor', 'r');
    case 2
        handles.x1_w=pan_val/100*pan_range;
        handles.x2_w=pan_val/100*pan_range;
        handles.rect1=[ceil(handles.x1_w/720*handles.width) ceil(handles.y1_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.rect2=[ceil(handles.x2_w/720*handles.width) ceil(handles.y2_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.crop1=[handles.rect1(1) handles.rect1(2) (handles.rect1(3)-1)...
            (handles.rect1(4)-1)];
        handles.crop2=[handles.rect2(1) handles.rect2(2) (handles.rect2(3)-1)...
            (handles.rect2(4)-1)];
        handles.area=ceil(handles.w_w/720*handles.width)* ceil(handles.h_w/576*handles.height);
        handles.position=[handles.rect1; handles.rect2; handles.rect3; handles.rect4];
        axes(handles.display)
        imshow(ones(handles.height, handles.width));
        rectangle('Position',handles.rect1,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect2,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect3,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect4,...
            'edgecolor', 'r');
    case 3
        handles.x3_w=handles.width/2+pan_val/100*pan_range;
        handles.x4_w=handles.width/2+pan_val/100*pan_range;
        handles.rect3=[ceil(handles.x3_w/720*handles.width) ceil(handles.y3_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.rect4=[ceil(handles.x4_w/720*handles.width) ceil(handles.y4_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.crop3=[handles.rect3(1) handles.rect3(2) (handles.rect3(3)-1)...
            (handles.rect3(4)-1)];
        handles.crop4=[handles.rect4(1) handles.rect4(2) (handles.rect4(3)-1)...
            (handles.rect4(4)-1)];
        handles.area=ceil(handles.w_w/720*handles.width)* ceil(handles.h_w/576*handles.height);
        handles.position=[handles.rect1; handles.rect2; handles.rect3; handles.rect4];
        axes(handles.display)
        imshow(ones(handles.height, handles.width));
        rectangle('Position',handles.rect1,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect2,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect3,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect4,...
            'edgecolor', 'r');    
end
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function slider_win_pan_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%==========================================================================


%==========================================================================
% --- Executes on slider movement.
function slider_win_tilt_Callback(hObject, eventdata, handles)
win_choice=get(handles.win_to_set,'value');
tilt_val=round(get(handles.slider_win_tilt,'value'));
set(handles.win_tilt,'string', strcat(num2str(tilt_val), '%'));
tilt_range=handles.height/2-handles.h_w;
switch win_choice
    case 1
        handles.y1_w=tilt_val/100*tilt_range;
        handles.y2_w=handles.height/2+tilt_val/100*tilt_range;
        handles.y3_w=tilt_val/100*tilt_range;
        handles.y4_w=handles.height/2+tilt_val/100*tilt_range;        
        handles.rect1=[ceil(handles.x1_w/720*handles.width) ceil(handles.y1_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.rect2=[ceil(handles.x2_w/720*handles.width) ceil(handles.y2_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.rect3=[ceil(handles.x3_w/720*handles.width) ceil(handles.y3_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.rect4=[ceil(handles.x4_w/720*handles.width) ceil(handles.y4_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.crop1=[handles.rect1(1) handles.rect1(2) (handles.rect1(3)-1)...
            (handles.rect1(4)-1)];
        handles.crop2=[handles.rect2(1) handles.rect2(2) (handles.rect2(3)-1)...
            (handles.rect2(4)-1)];
        handles.crop3=[handles.rect3(1) handles.rect3(2) (handles.rect3(3)-1)...
            (handles.rect3(4)-1)];
        handles.crop4=[handles.rect4(1) handles.rect4(2) (handles.rect4(3)-1)...
            (handles.rect4(4)-1)];
        handles.area=ceil(handles.w_w/720*handles.width)* ceil(handles.h_w/576*handles.height);
        handles.position=[handles.rect1; handles.rect2; handles.rect3; handles.rect4];
        axes(handles.display)
        imshow(ones(handles.height, handles.width));
        rectangle('Position',handles.rect1,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect2,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect3,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect4,...
            'edgecolor', 'r');
    case 2
        handles.y1_w=tilt_val/100*tilt_range;
        handles.y2_w=handles.height/2+tilt_val/100*tilt_range;
        handles.rect1=[ceil(handles.x1_w/720*handles.width) ceil(handles.y1_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.rect2=[ceil(handles.x2_w/720*handles.width) ceil(handles.y2_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.crop1=[handles.rect1(1) handles.rect1(2) (handles.rect1(3)-1)...
            (handles.rect1(4)-1)];
        handles.crop2=[handles.rect2(1) handles.rect2(2) (handles.rect2(3)-1)...
            (handles.rect2(4)-1)];
        handles.area=ceil(handles.w_w/720*handles.width)* ceil(handles.h_w/576*handles.height);
        handles.position=[handles.rect1; handles.rect2; handles.rect3; handles.rect4];
        axes(handles.display)
        imshow(ones(handles.height, handles.width));
        rectangle('Position',handles.rect1,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect2,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect3,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect4,...
            'edgecolor', 'r');
    case 3
        handles.y3_w=tilt_val/100*tilt_range;
        handles.y4_w=handles.height/2+tilt_val/100*tilt_range;
        handles.rect3=[ceil(handles.x3_w/720*handles.width) ceil(handles.y3_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.rect4=[ceil(handles.x4_w/720*handles.width) ceil(handles.y4_w/576*handles.height)...
            ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
        handles.crop3=[handles.rect3(1) handles.rect3(2) (handles.rect3(3)-1)...
            (handles.rect3(4)-1)];
        handles.crop4=[handles.rect4(1) handles.rect4(2) (handles.rect4(3)-1)...
            (handles.rect4(4)-1)];
        handles.area=ceil(handles.w_w/720*handles.width)* ceil(handles.h_w/576*handles.height);
        handles.position=[handles.rect1; handles.rect2; handles.rect3; handles.rect4];
        axes(handles.display)
        imshow(ones(handles.height, handles.width));
        rectangle('Position',handles.rect1,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect2,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect3,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect4,...
            'edgecolor', 'r');    
end
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function slider_win_tilt_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%==========================================================================


%==========================================================================
% --- Executes on selection change in win_to_set.
function win_to_set_Callback(hObject, eventdata, handles)
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function win_to_set_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================


%==========================================================================
% --- Executes on button press in win_position.
function win_position_Callback(hObject, eventdata, handles)
set(handles.slider_win_height,'value',100);
set(handles.win_height,'string','100%');
set(handles.slider_win_width,'value',100);
set(handles.win_width,'string','100%');
set(handles.slider_win_pan,'value',50);
set(handles.win_pan,'string','50%');
set(handles.slider_win_tilt,'value',50);
set(handles.win_tilt,'string','50%');
handles.h_w=ceil(180/576*handles.height);
handles.w_w=ceil(288/720*handles.width);
handles.x1_w=ceil((handles.width/2-handles.w_w)/2);
handles.x2_w=ceil((handles.width/2-handles.w_w)/2);
handles.x3_w=ceil(handles.width/2+(handles.width/2-handles.w_w)/2);
handles.x4_w=ceil(handles.width/2+(handles.width/2-handles.w_w)/2);
handles.y1_w=ceil((handles.height/2-handles.h_w)/2);
handles.y2_w=ceil(handles.height/2+(handles.height/2-handles.h_w)/2);
handles.y3_w=ceil((handles.height/2-handles.h_w)/2);
handles.y4_w=ceil(handles.height/2+(handles.height/2-handles.h_w)/2);
handles.rect1=[ceil(handles.x1_w/720*handles.width) ceil(handles.y1_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.rect2=[ceil(handles.x2_w/720*handles.width) ceil(handles.y2_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.rect3=[ceil(handles.x3_w/720*handles.width) ceil(handles.y3_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.rect4=[ceil(handles.x4_w/720*handles.width) ceil(handles.y4_w/576*handles.height)...
    ceil(handles.w_w/720*handles.width) ceil(handles.h_w/576*handles.height)];
handles.crop1=[handles.rect1(1) handles.rect1(2) (handles.rect1(3)-1)...
    (handles.rect1(4)-1)];
handles.crop2=[handles.rect2(1) handles.rect2(2) (handles.rect2(3)-1)...
    (handles.rect2(4)-1)];
handles.crop3=[handles.rect3(1) handles.rect3(2) (handles.rect3(3)-1)...
    (handles.rect3(4)-1)];
handles.crop4=[handles.rect4(1) handles.rect4(2) (handles.rect4(3)-1)...
    (handles.rect4(4)-1)];
handles.area=ceil(handles.w_w/720*handles.width)* ceil(handles.h_w/576*handles.height);
axes(handles.display);
imshow(ones(handles.height, handles.width));
rectangle('Position',handles.rect1,...
    'edgecolor', 'r');
rectangle('Position',handles.rect2,...
    'edgecolor', 'r');
rectangle('Position',handles.rect3,...
    'edgecolor', 'r');
rectangle('Position',handles.rect4,...
    'edgecolor', 'r');
guidata(hObject, handles);
%==========================================================================


%==========================================================================
% --- Executes on button press in read_avi.
function read_avi_Callback(hObject, eventdata, handles)
% try
    if strcmp(get(handles.read_avi,'String'), 'Browse')
        set(handles.start_vid,'Enable', 'Inactive');
        set(handles.avi_filename,'String', 'Reading File...');
        [avi_file avi_path]=uigetfile('*.avi','Select *.avi file');        
        handles.avi_in=aviread(avi_file);
        set(handles.avi_filename,'String', avi_file);
        set(handles.read_avi,'String', 'Load');
    elseif strcmp(get(handles.read_avi,'String'), 'Load')
        string=get(handles.avi_filename,'String');
        set(handles.avi_filename,'String', 'Loading Frames...');       
        for f=1:size(handles.avi_in,2)            
            temp=handles.avi_in(1,f);
            temp=temp.cdata;
            temp=imresize(rgb2gray(temp),[576 720]);
            handles.avi_in(1,f).cdata=temp;
            pause(0.0000001);
            set(handles.num_frame,'String', strcat(num2str(f),' frames'));
            pause(0.0000001);
        end
        axes(handles.display);
        imshow(ones(handles.height, handles.width));
        rectangle('Position',handles.rect1,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect2,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect3,...
            'edgecolor', 'r');
        rectangle('Position',handles.rect4,...
            'edgecolor', 'r');
        set(handles.avi_filename,'String', string);
        set(handles.start_vid,'Enable', 'on');
        set(handles.read_avi,'String', 'Browse');
    end
% end
guidata(hObject, handles);
%==========================================================================


%==========================================================================
% --- Executes on button press in start_vid.
function start_vid_Callback(hObject, eventdata, handles)
% try
    if strcmp(get(handles.start_vid,'String'), 'Start')
       set(handles.start_vid,'String', 'Stop');
       set(handles.slider_win_height,'enable','inactive');
       set(handles.slider_win_width,'enable','inactive');
       set(handles.slider_win_pan,'enable','inactive');
       set(handles.slider_win_tilt,'enable','inactive');
       set(handles.win_position,'enable','inactive');
       data=handles.avi_in(1,1).cdata;
       load nsd_plot;
       load record;
       nsd_a=[];
       nsd_b=[];
       nsd_c=[];
       nsd_d=[];
       frame=[];
       absis=[];       
       people_in=0;
       people_out=0;
       total_people=0;
       stat_a=0;
       stat_b=0;
       stat_c=0;
       stat_d=0;  
       event_frame_a=0;
       event_frame_b=0;
       event_frame_c=0;
       event_frame_d=0;
       detect_frame_a=0;
       detect_frame_b=0;
       detect_frame_c=0;
       detect_frame_d=0;
       frame_out=floor(1.5*str2num(handles.fps));
       set(handles.enter,'String',num2str(people_in));
       set(handles.exit,'String',num2str(people_in));
       set(handles.total_traffic,'String',num2str(total_people));
       for f=1:size(handles.avi_in,2)
           set(handles.proc_frame,'String', strcat(num2str(f),' frames'));
           if strcmp(get(handles.start_vid,'String'),'Stop')
               prev_data=data;
               current_frame=f;
               frame=[frame current_frame];
               data=handles.avi_in(1,f).cdata;
               axes(handles.display);
               imshow(data);
               rectangle('Position',handles.rect1,...
                   'edgecolor', 'r');
               rectangle('Position',handles.rect2,...
                   'edgecolor', 'r');
               rectangle('Position',handles.rect3,...
                   'edgecolor', 'r');
               rectangle('Position',handles.rect4,...
                   'edgecolor', 'r');
               diff=imabsdiff(data,prev_data);
               diff_a=sum(sum(imcrop(diff,handles.crop1)))/handles.area;
               diff_b=sum(sum(imcrop(diff,handles.crop2)))/handles.area;
               diff_c=sum(sum(imcrop(diff,handles.crop3)))/handles.area;
               diff_d=sum(sum(imcrop(diff,handles.crop4)))/handles.area;
               nsd_a=[nsd_a diff_a];
               nsd_b=[nsd_b diff_b];
               nsd_c=[nsd_c diff_c];
               nsd_d=[nsd_d diff_d];
               if current_frame>=20
                   choice=get(handles.nsd_plot,'Value');
                   axes(handles.nsd_window_plot); 
                   absis=[current_frame-19:current_frame];
                   threshold=round(get(handles.slider_threeshold,'Value'));
                   thresh_line=threshold*ones(1,20);
                   if choice==1
                       try
                           plot(absis,nsd_a(current_frame-19:current_frame),...
                               absis,nsd_b(current_frame-19:current_frame),...
                               absis,nsd_c(current_frame-19:current_frame),...
                               absis,nsd_d(current_frame-19:current_frame),...
                               absis,thresh_line);
                           set(gca,'YLim',[0 150],...
                               'XLim', [(current_frame-19) current_frame],...
                               'XTick', [(current_frame-19) (current_frame-13)...
                               (current_frame-7) current_frame]);
                       end
                   elseif choice==2
                       try
                           plot(absis,nsd_a(current_frame-19:current_frame),absis,thresh_line);
                           set(gca,'YLim',[0 150],...
                               'XLim', [(current_frame-19) current_frame],...
                               'XTick', [(current_frame-19) (current_frame-13)...
                               (current_frame-7) current_frame]);
                       end
                   elseif choice==3
                       try
                           plot(absis,nsd_b(current_frame-19:current_frame),absis,thresh_line);
                           set(gca,'YLim',[0 150],...
                               'XLim', [(current_frame-19) current_frame],...
                               'XTick', [(current_frame-19) (current_frame-13)...
                               (current_frame-7) current_frame]);
                       end
                   elseif choice==4
                       try
                           plot(absis,nsd_c(current_frame-19:current_frame),absis,thresh_line);
                           set(gca,'YLim',[0 150],...
                               'XLim', [(current_frame-19) current_frame],...
                               'XTick', [(current_frame-19) (current_frame-13)...
                               (current_frame-7) current_frame]);
                       end
                   elseif choice==5
                       try
                           plot(absis,nsd_d(current_frame-19:current_frame),absis,thresh_line);
                           set(gca,'YLim',[0 150],...
                               'XLim', [(current_frame-19) current_frame],...
                               'XTick', [(current_frame-19) (current_frame-13)...
                               (current_frame-7) current_frame]);
                       end
                   elseif choice==6
                   end
                   if diff_a>=threshold && stat_a==0 && stat_b==0
                       set(handles.in_left,'Backgroundcolor',[1 0 0]);
                       stat_a=2;
                       stat_b=1;
                       detect_frame_a=current_frame;
                   elseif stat_a==2 && detect_frame_a+frame_out==current_frame
                       set(handles.in_left,'Backgroundcolor',[1 1 1]);
                       detect_frame_a=0;
                       event_frame_a=0;
                       stat_a=0;
                       stat_b=0;
                   elseif diff_a>=threshold && stat_a==1 && event_frame_a==0
                       event_frame_a=current_frame;                    
                   elseif diff_a<threshold && stat_a==1 && event_frame_a~=0
                       people_out=people_out+1;
                       total_people=people_in+people_out;
                       set(handles.exit,'String',num2str(people_out));
                       set(handles.total_traffic,'String',num2str(total_people));
                       set(handles.ext_left,'Backgroundcolor',[1 1 1]);
                       detect_frame_a=0;
                       event_frame_a=0;
                       stat_a=0;
                       stat_b=0;                    
                   end
                   if diff_b>=threshold && stat_b==0 && stat_a==0
                       set(handles.ext_left,'Backgroundcolor', [1 0 0]);
                       stat_b=2;
                       stat_a=1;
                       detect_frame_b=current_frame;
                   elseif stat_b==2 && detect_frame_b+frame_out==current_frame
                       set(handles.ext_left,'Backgroundcolor',[1 1 1]);
                       detect_frame_b=0;
                       event_frame_b=0;
                       stat_a=0;
                       stat_b=0;
                       elseif diff_b>=threshold && stat_b==1 && event_frame_b==0
                           event_frame_b=current_frame;                                                   
                   elseif diff_b<threshold && stat_b==1 && event_frame_b~=0
                       people_in=people_in+1;
                       total_people=people_in+people_out;
                       set(handles.enter,'String',num2str(people_in));
                       set(handles.total_traffic,'String',num2str(total_people));
                       set(handles.in_left,'Backgroundcolor',[1 1 1]);
                       detect_frame_b=0;
                       event_frame_b=0;
                       stat_a=0;
                       stat_b=0;
                   end
                   if diff_c>=threshold && stat_c==0 && stat_d==0
                       set(handles.in_right,'Backgroundcolor',[1 0 0]);
                       stat_c=2;
                       stat_d=1;
                       detect_frame_c=current_frame;
                   elseif stat_c==2 && detect_frame_c+frame_out==current_frame
                       set(handles.in_right,'Backgroundcolor',[1 1 1]);
                       detect_frame_c=0;
                       event_frame_c=0;
                       stat_c=0;
                       stat_d=0;
                   elseif diff_c>=threshold && stat_c==1 && event_frame_c==0
                       event_frame_c=current_frame;
                   elseif diff_c<threshold && stat_c==1 && event_frame_c~=0
                       people_out=people_out+1;
                       total_people=people_in+people_out;
                       set(handles.exit,'String',num2str(people_out));
                       set(handles.total_traffic,'String',num2str(total_people));
                       set(handles.ext_right,'Backgroundcolor',[1 1 1]);
                       detect_frame_c=0;
                       event_frame_c=0;
                       stat_c=0;
                       stat_d=0;
                   end
                   if diff_d>=threshold && stat_d==0 && stat_c==0
                       set(handles.ext_right,'Backgroundcolor', [1 0 0]);
                       stat_d=2;
                       stat_c=1;
                       detect_frame_d=current_frame;
                   elseif stat_d==2 && detect_frame_d+frame_out==current_frame
                       set(handles.ext_right,'Backgroundcolor',[1 1 1]);
                       detect_frame_d=0;
                       event_frame_d=0;
                       stat_c=0;
                       stat_d=0;
                   elseif diff_d>=threshold && stat_d==1 && event_frame_d==0
                       event_frame_d=current_frame;
                   elseif diff_d<threshold && stat_d==1 && event_frame_d~=0
                       people_in=people_in+1;
                       total_people=people_in+people_out;
                       set(handles.enter,'String',num2str(people_in));
                       set(handles.total_traffic,'String',num2str(total_people));
                       set(handles.in_right,'Backgroundcolor',[1 1 1]);
                       detect_frame_d=0;
                       event_frame_d=0;
                       stat_c=0;
                       stat_d=0;
                   end
               end
           end
       end       
       save ('nsd_plot', 'frame', 'nsd_a', 'nsd_b', 'nsd_c', 'nsd_d');
       save ('record', 'people_in', 'people_out', 'total_people');
       set(handles.start_vid,'String', 'Start');
       set(handles.slider_win_height,'enable','on');
       set(handles.slider_win_width,'enable','on');
       set(handles.slider_win_pan,'enable','on');
       set(handles.slider_win_tilt,'enable','on');
       set(handles.win_position,'enable','on');
       axes(handles.display);
       imshow(ones(handles.height, handles.width)); 
       axes(handles.display);
       rectangle('Position',handles.rect1,...
           'edgecolor', 'r');
       rectangle('Position',handles.rect2,...
           'edgecolor', 'r');
       rectangle('Position',handles.rect3,...
           'edgecolor', 'r');
       rectangle('Position',handles.rect4,...
           'edgecolor', 'r');
       axes(handles.nsd_window_plot);
       imshow(handles.background2);
    elseif strcmp(get(handles.start_vid,'String'), 'Stop')
        set(handles.start_vid,'String', 'Start');
        set(handles.slider_win_height,'enable','on');
        set(handles.slider_win_width,'enable','on');
        set(handles.slider_win_pan,'enable','on');
        set(handles.slider_win_tilt,'enable','on');
        set(handles.win_position,'enable','on');
        axes(handles.display);
        imshow(ones(handles.height, handles.width)); 
        axes(handles.display);
        rectangle('Position',handles.rect1,...
           'edgecolor', 'r');
       rectangle('Position',handles.rect2,...
           'edgecolor', 'r');
       rectangle('Position',handles.rect3,...
           'edgecolor', 'r');
       rectangle('Position',handles.rect4,...
           'edgecolor', 'r');
        axes(handles.nsd_window_plot);
        imshow(handles.background2);
    end
% end
guidata(hObject, handles);
%==========================================================================


%==========================================================================
function avi_filename_Callback(hObject, eventdata, handles)
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function avi_filename_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================


%==========================================================================
function num_frame_Callback(hObject, eventdata, handles)

guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function num_frame_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================


%==========================================================================
function proc_frame_Callback(hObject, eventdata, handles)

guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function proc_frame_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================

