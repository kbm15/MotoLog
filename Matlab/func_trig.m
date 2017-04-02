function varargout = func_trig(varargin)
% FUNC_TRIG MATLAB code for func_trig.fig
%      FUNC_TRIG, by itself, creates a new FUNC_TRIG or raises the existing
%      singleton*.
%
%      H = FUNC_TRIG returns the handle to a new FUNC_TRIG or the handle to
%      the existing singleton*.
%
%      FUNC_TRIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FUNC_TRIG.M with the given input arguments.
%
%      FUNC_TRIG('Property','Value',...) creates a new FUNC_TRIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before func_trig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to func_trig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help func_trig

% Last Modified by GUIDE v2.5 23-Jun-2016 14:45:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @func_trig_OpeningFcn, ...
                   'gui_OutputFcn',  @func_trig_OutputFcn, ...
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


% --- Executes just before func_trig is made visible.
function func_trig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to func_trig (see VARARGIN)
handles.ejex=0:pi/360:2*pi; 
y1=sin(2*pi*1*handles.ejex); 
plot(handles.ejex,y1,'LineWidth',2);
grid on; 
axis([0 2*pi -1 1]); 

% Choose default command line output for func_trig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes func_trig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = func_trig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
fun =get(handles.popupmenu1, 'Value' ); 
switch fun 
    case 1 
        y1=sin(2*pi*1*handles.ejex); 
        plot(handles.ejex,y1, 'LineWidth' ,2);
        grid on ;
        axis([0 2*pi -1 1]); 
    case 2 
        y2=cos(2*pi*1*handles.ejex);
        plot(handles.ejex,y2, 'LineWidth' ,2);
        grid on ;
        axis([0 2*pi -1 1]); 
    case 3 
        y3=sin(2*pi*1*handles.ejex)+cos(2*pi*1*handles.ejex); 
         plot(handles.ejex,y3, 'LineWidth' ,2);
         grid on ; 
         axis([0 2*pi min(y3) max(y3) ]); 
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
