function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 23-Jun-2016 15:31:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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

% End initialization code - DO NOT EDIT


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)
plot(handles.axes1,NaN,NaN);
title(handles.axes1,'Mapa','FontSize',14,'FontWeight','bold')
ylabel(handles.axes1,'Sur -> Norte')
xlabel(handles.axes1,'Oeste -> Este')
title(handles.axes2,'Fuerzas G','FontSize',14,'FontWeight','bold')
% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% Guardamos los datos del gps
handles.datasetGPS = read();
if handles.datasetGPS == 0 
    return;
end
% Guardamos el numero de muestras
handles.length = length(handles.datasetGPS(:,1));
% Convertimos a cartesiano
handles.datasetxyz = convert2Cart(handles.datasetGPS);
% Asignamos parametros al slider
set(handles.slider1,'UserData',handles.datasetGPS);
set(handles.slider1,'Max',handles.length);
set(handles.slider1, 'SliderStep', [1/handles.length , 10/handles.length ]);
% Ploteamos en el axes1 la trayectoria
plot(handles.axes1,handles.datasetxyz(:,2),handles.datasetxyz(:,1),'o');
set(handles.axes1,'YDir','reverse'); 
% Ploteamos el grafico de fuerzas g
axes(handles.axes2)
plotg(handles.datasetGPS(1,3)+handles.datasetGPS(1,4)+1i,1);

axes(handles.axes3)
wmmarker(handles.datasetGPS(1,1),handles.datasetGPS(1,2))

% reverse the second axis to get correct mapping


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(hObject,'UserData');
handles.datasetxyz = convert2Cart(data);
axes(handles.axes2)
plotg(data(get(hObject,'Value'),3)+data(get(hObject,'Value'),4)*1i,1);
axes(handles.axes1)
point(handles.datasetxyz(:,2),handles.datasetxyz(:,1),get(hObject,'Value'));
set(handles.axes1,'YDir','reverse'); 

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
