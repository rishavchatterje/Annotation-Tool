function varargout = WordCutter(varargin)
% WORDCUTTER MATLAB code for WordCutter.fig
%      WORDCUTTER, by itself, creates a new WORDCUTTER or raises the existing
%      singleton*.
%
%      H = WORDCUTTER returns the handle to a new WORDCUTTER or the handle to
%      the existing singleton*.
%
%      WORDCUTTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WORDCUTTER.M with the given input arguments.
%
%      WORDCUTTER('Property','Value',...) creates a new WORDCUTTER or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WordCutter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WordCutter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WordCutter

% Last Modified by GUIDE v2.5 06-Feb-2017 14:34:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WordCutter_OpeningFcn, ...
                   'gui_OutputFcn',  @WordCutter_OutputFcn, ...
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

% --- Executes just before WordCutter is made visible.
function WordCutter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WordCutter (see VARARGIN)

% Choose default command line output for WordCutter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Disable the not required components
set(handles.Original ,'Visible','off');
set(handles.cropped ,'Visible','off');
set(handles.ObjectList ,'Enable','off');
set(handles.SaveImage ,'Enable','off');
set(handles.imgFileList ,'Enable','off');
set(handles.CreateAnnotation,'Enable','off');

fid = fopen('ScriptList.txt');
str = [];
i   = 0;
while ~feof(fid)
  i = i+1;
  str{i} = fgetl(fid);
end
set(handles.ObjectList,'String',str);
set(handles.playbttn,'String',char(9658));
global videoSrc;
global Totalframe;
global frameCnt;
global fwdclicked;
global VideoSelected;
global bwdclicked;
frameCnt=0;Totalframe=0;fwdclicked=0;VideoSelected=0; bwdclicked=0;
initialize_gui(hObject, handles, false);

% UIWAIT makes WordCutter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WordCutter_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load ObjectCountInfo;
handles.ObjectCountInfo = ObjectCountInfo;
handles.ObjCnt= 0;
% Update handles structure
guidata(hObject, handles);

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function density_CreateFcn(hObject, eventdata, handles)
% hObject    handle to density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function density_Callback(hObject, eventdata, handles)
% hObject    handle to density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of density as text
%        str2double(get(hObject,'String')) returns contents of density as a double
density = str2double(get(hObject, 'String'));
if isnan(density)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new density value
handles.metricdata.density = density;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function volume_Callback(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of volume as text
%        str2double(get(hObject,'String')) returns contents of volume as a double
volume = str2double(get(hObject, 'String'));
if isnan(volume)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new volume value
handles.metricdata.volume = volume;
guidata(hObject,handles)

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mass = handles.metricdata.density * handles.metricdata.volume;
set(handles.mass, 'String', mass);

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in open.
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in SelectROI.
function SelectROI_Callback(hObject, eventdata, handles)
% hObject    handle to SelectROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    axes(handles.Original);
    image = handles.image;
%     imshow(image);
    
    set(handles.outputFname,'String','');
    
    % wait for two clicks & get the position info
    recorded = ginput(2);   % the recorded click-info
    pos1x = floor(recorded(1,1));  % 1st position - X coordinate
    pos1y = floor(recorded(1,2));  % 1st position - Y coordinate
    pos2x = floor(recorded(2,1));  % 2nd position - X coordinate
    pos2y = floor(recorded(2,2));  % 2nd position - Y coordinate
    
    % Selected area validity check
if ((pos2x>pos1x) && (pos2y>pos1y))

    selected = zeros(pos2y - pos1y,pos2x - pos1x, 3);
    col = 1;
    row = 1;
    for rowwise = pos1x:pos2x
        for colwise = pos1y:pos2y
            selected(col,row,1) = image(colwise,rowwise,1);
            selected(col,row,2) = image(colwise,rowwise,2);
            selected(col,row,3) = image(colwise,rowwise,3);
            col = col+1;
        end
        row = row + 1;
        col = 1;
    end
    
    axes(handles.cropped);
    imshow(selected);
    
    handles.cropx1 = pos1x;
    handles.cropx2 = pos2x;
    handles.cropy1 = pos1y;
    handles.cropy2 = pos2y;
    guidata(hObject,handles);
    
    %Show the select Co-ordinates
    set(handles.x1,'String',pos1x);
    set(handles.y1,'String',pos1y);
    set(handles.x2,'String',pos2x);
    set(handles.y2,'String',pos2y);
    
    % Enable Ground truth options
    set(handles.ObjectList,'Enable','on');
    set(handles.SaveImage,'Enable','on');
    
    handles.selected = selected;
    set(handles.CreateAnnotation,'Enable','on');
    guidata(hObject,handles);
    clear selected
else
    errordlg(...
        'Try to make the selection from Upper-Left to Lower-Right',...
        'Wrong selection pattern');
end

% --- Executes on selection change in ObjectList.
function ObjectList_Callback(hObject, eventdata, handles)
% hObject    handle to ObjectList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    contents = cellstr(get(hObject,'String'));
    selection = get(hObject,'Value');
    set(handles.FnamePattern,'String',contents{get(hObject,'Value')});
    StartCnt = handles.ObjectCountInfo(selection);
    set(handles.StartCount,'String',num2str(StartCnt)); 
    set(handles.increment,'String',num2str(1)); 
% Hints: contents = cellstr(get(hObject,'String')) returns ObjectList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ObjectList


% --- Executes during object creation, after setting all properties.
function ObjectList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ObjectList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveImage.
function SaveImage_Callback(hObject, eventdata, handles)
% hObject    handle to SaveImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global frameCnt;
handles.ObjCnt= handles.ObjCnt+1;
guidata(hObject,handles);

selected = handles.selected;
ScriptLst = get(handles.ObjectList,'String');
ObjName = ScriptLst(get(handles.ObjectList,'Value'));
ObjNo= get(handles.ObjectList,'Value');
handles.increment.String = num2str(1);
% switch selection
%     case 1
%         ObjName = 'Shark';
%         ObjNo = 1;
%         %set(handles.StartCount,'String',num2str(handles.ObjectCountInfo(1)));   
%         drawnow;
%     case 2
%         ObjName = 'Dolphin';
%         %set(handles.StartCount,'String',num2str(handles.ObjectCountInfo(2))); 
%         ObjNo = 2;
%         drawnow;
%     case 3
%         ObjName = 'Whale'
%         ObjNo = 3;
%         drawnow;
%     case 4
%         ObjName = 'LargeFish';
% %         set(handles.StartCount,'String',num2str(handles.ObjectCountInfo(3))); 
%         ObjNo = 4;
%         drawnow;
%     case 5
%         ObjName = 'DPIBoat'
%         ObjNo = 5;
%         drawnow;
%     case 6
%         ObjName = 'Swimmer';
% %         set(handles.StartCount,'String',num2str(handles.ObjectCountInfo(4))); 
%         ObjNo = 6;
%         drawnow;
%     case 7
%         ObjName = 'Surfer';
% %         set(handles.StartCount,'String',num2str(handles.ObjectCountInfo(5))); 
%         ObjNo = 7;
%         drawnow;
%     case 8
%         ObjName = 'SurfBoard';
% %         set(handles.StartCount,'String',num2str(handles.ObjectCountInfo(6))); 
%         ObjNo = 8;
%         drawnow;
%     case 9
%         ObjName = 'PaddleBoat';
% %         set(handles.StartCount,'String',num2str(handles.ObjectCountInfo(7))); 
%         ObjNo = 9;
%         drawnow;
%     case 10
%         ObjName = 'Other';             
% %         set(handles.StartCount,'String',num2str(handles.ObjectCountInfo(8))); 
%         ObjNo = 10;
%         drawnow;
% end

drawnow;
tmppath = mfilename('fullpath');
tmpdir1 = fileparts(tmppath);

Objfolder = strcat(tmpdir1,'\',ObjName);
[pth,filenameonly] = fileparts(handles.impath);
clear pth;

%Save the Frame --------------------------

frameFileName = sprintf('%s_Frame_%d',handles.VideoName, frameCnt);
frameFilePath = strcat(Objfolder, '\', frameFileName,'.jpg')
imwrite(handles.image, frameFilePath{1});

%-----------------------------------------

fileCount= str2num(handles.StartCount.String)+1;
set(handles.StartCount, 'String', num2str(fileCount));
guidata(hObject,handles);
drawnow;
fName=strcat(handles.FnamePattern.String,'_', num2str(fileCount));
saveto = strcat(frameFileName, '_',fName,'.jpg');

folderselect = strcat(Objfolder,'\',saveto);
set(handles.outputFname,'String',saveto);
if exist(folderselect{:})==0
     imwrite(selected,folderselect{:});
     set(handles.outputFname,'String',saveto);
elseif exist(folderselect{:})==2
     resp = questdlg(strcat('The file already exists !!! Maybe you have selected this before',...
         '. Want to continue anyway (OverWrite)?'),...
         'File Name Conflict','Yes','No','Yes');
     if strcmp(resp,'Yes')
        imwrite(selected,folderselect{:});
        set(handles.outputFname,'String',saveto);
     end
end

% Save the ground truth in a file
% Ground Filename is gt_<imagefile>.txt
    Field1 = 'ObjectName';
    Field2 = 'xmin';
    Field3 = 'ymin';
    Field4 = 'xmax';
    Field5 = 'ymax';
    Field6 = 'ImgHT';
    Field7 = 'ImgWD';
    Field8 = 'ImgDept';
    Field9 = 'XMLFolder';
    Field10 = 'FileName';
    
    [ht wd d]=size(selected); 
    
    handles.ObjectStruct = struct(Field1, ObjName, Field2, handles.cropx1, ...
        Field3, handles.cropy1, Field4, handles.cropx2, Field5, handles.cropy2, Field6, ht, Field7, wd, Field8, d, Field9, Objfolder, Field10, saveto);
    guidata(hObject,handles);
    
%     GTFileName=strcat(Objfolder,'\',fName,'.txt');
%     fp=fopen(GTFileName,'a+');
%     GtString = strcat(ObjName,',',num2str(handles.cropx1),',',...
%         num2str(handles.cropy1),',',num2str(handles.cropx2),',',num2str(handles.cropy2));
%     fprintf(fp,'%s\n',GtString);
%     fclose(fp);    

    % Update the File Count respective Object
%     ObjectCountInfo(ObjNo)=ObjectCountInfo(ObjNo)+1;
    %set(handles.ObjectCountInfo(ObjNo),'double',(handles.ObjectCountInfo(ObjNo)+1));
    handles.ObjectCountInfo(ObjNo) = handles.ObjectCountInfo(ObjNo) + 1;
    ObjCnt = handles.ObjectCountInfo(ObjNo);
%     set(handles.StartCount,'String',num2str(ObjCnt));
    %handles.StartCount = num2str(ObjCnt);
    ObjectCountInfo = handles.ObjectCountInfo;
    guidata(hObject,handles);
    drawnow;
    save ('ObjectCountInfo.mat', 'ObjectCountInfo');

% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmppath = mfilename('fullpath');
tmpdir1 = fileparts(tmppath);
folder_name = uigetdir(tmpdir1, 'Select the Image Folder');
folderLst = strsplit(folder_name,'\');
[row col]=size(folderLst);
handles.folderName = folderLst{col};
set(handles.FnamePattern,'String',handles.folderName);
if ischar(folder_name)
    set(handles.filePath,'String',folder_name);
end
% Add more extensions for AVI, WMV
FilenameList=dir(strcat(folder_name,'\*.mp4'));
[N l]=size(FilenameList);
hObject=handles.imgFileList;
guidata(hObject,handles);
set(handles.imgFileList,'String','');
for i=1:N
    oldString=get(handles.imgFileList,'String');
    if isempty(oldString)
        newString=FilenameList(i).name;
    elseif ~iscell(oldString)
        newString={oldString, FilenameList(i).name};
    else 
        newString= {oldString{:} FilenameList(i).name}
    end
    set(hObject,'String', newString);
        
end
set(handles.imgFileList,'Enable','on');


function filePath_Callback(hObject, eventdata, handles)
% hObject    handle to filePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filePath as text
%        str2double(get(hObject,'String')) returns contents of filePath as a double


% --- Executes during object creation, after setting all properties.
function filePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function FnamePattern_Callback(hObject, eventdata, handles)
% hObject    handle to FnamePattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FnamePattern as text
%        str2double(get(hObject,'String')) returns contents of FnamePattern as a double


% --- Executes during object creation, after setting all properties.
function FnamePattern_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FnamePattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StartCount_Callback(hObject, eventdata, handles)
% hObject    handle to StartCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartCount as text
%        str2double(get(hObject,'String')) returns contents of StartCount as a double


% --- Executes during object creation, after setting all properties.
function StartCount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in imgFileList.
function imgFileList_Callback(hObject, eventdata, handles)
% hObject    handle to imgFileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global videoSrc;
    global Totalframe;
    global frameCnt;
    global VideoSelected;
     set(handles.playbttn,'String',char(9658));
    impath = get(handles.filePath,'String');
    contents = cellstr(get(hObject,'String'));
    imgName=strcat(impath,'\',contents{get(hObject,'Value')});
    
    %Show loading image
    axes(handles.Original);
    loadingIm=imread('loading1.jpg');
    imshow(loadingIm);
    drawnow;
    
    % show image on imshow
    axes(handles.Original);
    videoInfo = VideoReader(imgName);   

    videoSrc = vision.VideoFileReader(imgName);

    Totalframe = videoInfo.NumberOfFrames+1;
    frameCnt=1;
    set(handles.frameSlider, 'Max', Totalframe);
    set(handles.frameSlider, 'Min', 1);
    set(handles.frameSlider, 'Value', 1);
    image = step(videoSrc);
    [ht wd dp] = size(image);
    Field1='width';
    Field2='height';
    Field3='depth';
    handles.imageSize = struct(Field1,wd, Field2, ht ,Field3, dp);
    handles.fileName = contents{get(hObject,'Value')};
    
    %Make the Image visiable and the ROI Select active
    set(handles.Original,'Visible','on');
    set(handles.SelectROI,'Enable','on');
    set(handles.SelectROI,'Visible','on');
    VideoSelected=1;
    imshow(image);
    
    handles.image = image;
    handles.impath = impath;
    handles.ObjCnt = 0;
    c = strsplit(imgName, '\');
    vidName = strsplit(c{length(c)},'.');
    handles.VideoName = vidName{1};
    guidata(hObject,handles);


% Hints: contents = cellstr(get(hObject,'String')) returns imgFileList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imgFileList


% --- Executes during object creation, after setting all properties.
function imgFileList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgFileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function increment_Callback(hObject, eventdata, handles)
% hObject    handle to increment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of increment as text
%        str2double(get(hObject,'String')) returns contents of increment as a double


% --- Executes during object creation, after setting all properties.
function increment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to increment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CreateAnnotation.
function CreateAnnotation_Callback(hObject, eventdata, handles)
% hObject    handle to CreateAnnotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CreateXMLannotation(handles.ObjectStruct);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function frameSlider_Callback(hObject, eventdata, handles)
% hObject    handle to frameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
 global frameCnt;
 global videoSrc;
reqFrame = get(hObject,'Value');

if reqFrame > frameCnt
   while (frameCnt<reqFrame)
       image = step(videoSrc);
       frameCnt=frameCnt+1;
   end
   imshow(image);
   handles.image = image;
else
    reset(videoSrc);
    frameCnt=1;
    while (frameCnt<reqFrame)
       image = step(videoSrc);
       frameCnt=frameCnt+1;
    end
   imshow(image);
   handles.image = image;
end
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function frameSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in backBttn.
function backBttn_Callback(hObject, eventdata, handles)
% hObject    handle to backBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global videoSrc;
global bwdclicked;
global frameCnt;
global VideoSelected;

    if VideoSelected == 0
        errordlg('No Video selected! Please select a video from the list.', 'No Video Error');
        
    else
        try 
        if bwdclicked ==1
            bwdclicked = 0;
        else
            bwdclicked = 1;
        end
        skipCnt=1;
        
        reset(videoSrc);
        reqFrame = frameCnt-10;
        frameCnt=1;
        while (frameCnt<reqFrame)
           image = step(videoSrc);
           frameCnt=frameCnt+1;
        end
       imshow(image);
       handles.image = image;
       showFrameOnAxis(handles.Original, image);      
                
   catch ME
        % Re-throw error message if it is not related to invalid handle
           if ~strcmp(ME.identifier, 'MATLAB:class:InvalidHandle')
               rethrow(ME);
           end
        end
    end
    guidata(hObject,handles);



% --- Executes on button press in playbttn.
function playbttn_Callback(hObject, eventdata, handles)
% hObject    handle to playbttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global videoSrc;
 global frameCnt;
 global VideoSelected;

    if VideoSelected == 0
        errordlg('No Video selected! Please select a video from the list.', 'No Video Error');
        
    else
        try 
        if strcmp(hObject.String,char(9658))
             if isDone(videoSrc)
                  reset(videoSrc);
             end
        end
        
        if (strcmp(hObject.String,char(9658)) || strcmp(hObject.String,char(79)))
            hObject.String=char(8214);
        else
             hObject.String=char(79);
        end
        
        while strcmp(hObject.String,char(8214)) && ~isDone(videoSrc)
            [frame] = getFrame(videoSrc);
            showFrameOnAxis(handles.Original, frame);  
            handles.image = frame;
            frameCnt=frameCnt+1;
        end
        
        if isDone(videoSrc)
               hObject.String=char(9658);
        end
    catch ME
        % Re-throw error message if it is not related to invalid handle
           if ~strcmp(ME.identifier, 'MATLAB:class:InvalidHandle')
               rethrow(ME);
           end
        end
    end
    guidata(hObject,handles);



% --- Executes on button press in fwdBttn.
function fwdBttn_Callback(hObject, eventdata, handles)
% hObject    handle to fwdBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function [frame] = getFrame(videoSrc)
        % Read input video frame
        frame = step(videoSrc); 

function [frame] = getFrameback(videoSrc)
        % Read input video frame
        frame = step(videoSrc, -1); 

% --- Executes on button press in fwdbttn.
function fwdbttn_Callback(hObject, eventdata, handles)
% hObject    handle to fwdbttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global videoSrc;
global fwdclicked;
global frameCnt;
global VideoSelected;

    if VideoSelected == 0
        errordlg('No Video selected! Please select a video from the list.', 'No Video Error');
        
    else
        try 
        if fwdclicked ==1
            fwdclicked = 0;
        else
            fwdclicked = 1;
        end
        skipCnt=1;
        while ~isDone(videoSrc) && fwdclicked ==1
            [frame] = getFrame(videoSrc);
            skipCnt=skipCnt+1;
            handles.image = frame;
            frameCnt=frameCnt+1;
            if(skipCnt<20)
                continue;
            else
                skipCnt=1;
            end
            showFrameOnAxis(handles.Original, frame);      
        end
        
   catch ME
        % Re-throw error message if it is not related to invalid handle
           if ~strcmp(ME.identifier, 'MATLAB:class:InvalidHandle')
               rethrow(ME);
           end
        end
    end
    guidata(hObject,handles);
