function varargout = Generate(varargin)
% GENERATE MATLAB code for Generate.fig
%      GENERATE, by itself, creates a new GENERATE or raises the existing
%      singleton*.
%
%      H = GENERATE returns the handle to a new GENERATE or the handle to
%      the existing singleton*.
%
%      GENERATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENERATE.M with the given input arguments.
%
%      GENERATE('Property','Value',...) creates a new GENERATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Generate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Generate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Generate

% Last Modified by GUIDE v2.5 10-Oct-2018 22:04:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Generate_OpeningFcn, ...
                   'gui_OutputFcn',  @Generate_OutputFcn, ...
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


% --- Executes just before Generate is made visible.
function Generate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Generate (see VARARGIN)

% Choose default command line output for Generate
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Generate wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Generate_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
columns = 1024;
rows = 1024;
width = 300; %% cosing function part width
outputImage = ones(rows,columns)*255;

maskWidth = 30;

hf = str2num(char(get(handles.edit2,'String')));
vf = str2num(char(get(handles.edit3,'String')));
sf = str2num(char(get(handles.edit4,'String')));
slop = str2num(char(get(handles.edit5,'String')));

%% global variables
handles.columns = columns;
handles.rows = rows;
handles.width = width;
handles.maskWidth = maskWidth;
handles.hf = hf;
handles.vf = vf;
handles.sf = sf;
handles.slop = slop;

guidata(hObject,handles);
%% Define the cosine function frequencies
x = 1 : columns;
period = columns/hf;
y = 0.5 * cos(2*pi*x/period) + 0.5; % for horizontal

p = 1 : rows;
period2 = rows/vf;
q = 0.5 * cos(2*pi*p/period2) + 0.5; % for vertical

s = 1 : columns;
period3 = columns/sf;
t = 0.5 * cos(2*pi*s/period3) + 0.5; % for sloping

tempImage = zeros(width,rows)*255;
for i = 1:width
    tempImage(i,:) = t * 255;
end

%% Generate the image
tempImage = imrotate(tempImage, slop);

for i = 1:width
    outputImage(i,:) = y * 255;
end

for i = 1:width
    outputImage(:,i) = q * 255;
end

for i = width+1:rows
    outputImage(i, width+1:columns) = tempImage(i - width, 1:columns - width);
end

axes(handles.axes1);
imshow(outputImage,[]);
figure, imshow(outputImage,[]);

setappdata(0,'evalue',outputImage);


% --- Executes on button press in FFT.
function pushbutton3_Callback(hObject, eventdata, handles)
outputImage = getappdata(0,'evalue');

M = fft2(outputImage);
M = fftshift(M);

handles.M = M;
guidata(hObject,handles);

Ab = abs(M);
Ab = (Ab - min(min(Ab)))./(max(max(Ab))).*255;

axes(handles.axes2);
imshow(Ab);


% --- Executes on button press in Select image.
function pushbutton4_Callback(hObject, eventdata, handles)
[filename,filepath]=uigetfile({'*.jpg; *.png; *.bmp'},'Select and image');
selectedImage = imread(strcat(filepath, filename));
%Set the value of the text field edit6 to the route of the selected image.
set(handles.edit6, 'String', strcat(filepath, filename));
axes(handles.axes1);
imshow(selectedImage);

setappdata(0,'evalue',selectedImage);


% --- Executes on button press in Remove peaks.
function pushbutton5_Callback(hObject, eventdata, handles)
%% Get variables
columns = handles.columns;
rows = handles.rows;
maskWidth = handles.maskWidth;
M = handles.M;
hf = handles.hf;
vf = handles.vf;
sf = handles.sf;
slop = handles.slop;

%% Remove h peaks
if get(handles.radiobutton1,'value')
    for i = (columns-maskWidth)/2 : (columns-maskWidth)/2+maskWidth
        for j = (rows/2-hf-maskWidth/2) : (rows/2-hf-maskWidth/2)+maskWidth
            M(i,j) = 255;
        end
    end

    for i = (columns-maskWidth)/2 : (columns-maskWidth)/2+maskWidth
        for j = (rows/2+hf-maskWidth/2) : (rows/2+hf-maskWidth/2)+maskWidth
            M(i,j) = 255;
        end
    end
end

%% Remove v peaks
if get(handles.radiobutton2,'value')
    for i = (rows-maskWidth)/2 : (rows-maskWidth)/2+maskWidth
        for j = (columns/2-vf-maskWidth/2) : (columns/2-vf-maskWidth/2)+maskWidth
            M(j,i) = 255;
        end
    end

    for i = (rows-maskWidth)/2 : (rows-maskWidth)/2+maskWidth
        for j = (columns/2+vf-maskWidth/2) : (columns/2+vf-maskWidth/2)+maskWidth
            M(j,i) = 255;
        end
    end
end

%% Remove s peaks
if get(handles.radiobutton3,'value')
    center1y = int32(rows/2 - cosd(slop)*sf);
    center1x = int32(columns/2 + sind(slop)*sf);
    for i = center1y - (maskWidth/2) : center1y + (maskWidth/2)
        for j = center1x - (maskWidth/2) : center1x + (maskWidth/2)
            M(j,i) = 255;
        end
    end

    center2y = int32(rows/2 + cosd(slop)*sf);
    center2x = int32(columns/2 - sind(slop)*sf);
    for i = center2y - (maskWidth/2) : center2y + (maskWidth/2)
        for j = center2x - (maskWidth/2) : center2x + (maskWidth/2)
            M(j,i) = 255;
        end
    end
end

%% Display image
Ab = abs(M);
Abt = (Ab - min(min(Ab)))./(max(max(Ab))).*255;
axes(handles.axes3);
imshow(Abt);

%% Display reconstruct image
F = fftshift(M);
f = ifft2(F);

axes(handles.axes4);
imshow(f,[]);
%% GUI component

%Executes on button press
function radiobutton1_Callback(hObject, eventdata, handles)
function radiobutton2_Callback(hObject, eventdata, handles)
function radiobutton3_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes during object creation, after setting all properties.
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

function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double

function edit6_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
