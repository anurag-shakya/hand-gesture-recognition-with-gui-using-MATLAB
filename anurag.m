function varargout = anurag(varargin)
% ANURAG MATLAB code for anurag.fig
%      ANURAG, by itself, creates a new ANURAG or raises the existing
%      singleton*.
%
%      H = ANURAG returns the handle to a new ANURAG or the handle to
%      the existing singleton*.
%
%      ANURAG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANURAG.M with the given input arguments.
%
%      ANURAG('Property','Value',...) creates a new ANURAG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before anurag_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to anurag_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help anurag

% Last Modified by GUIDE v2.5 22-Sep-2017 17:13:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @anurag_OpeningFcn, ...
                   'gui_OutputFcn',  @anurag_OutputFcn, ...
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


% --- Executes just before anurag is made visible.
function anurag_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to anurag (see VARARGIN)

% Choose default command line output for anurag
handles.output = hObject;
axes(handles.axes1);
imshow('img1.jpeg');
global video ;
video= videoinput('winvideo',1); 
video.ReturnedColorspace = 'rgb';
videoResolution = get(video, 'VideoResolution');
imgWidth  = videoResolution(1);
imgHeight = videoResolution(2);
numBands  = get(video, 'NumberOfBands');
gui = image(zeros(imgHeight, imgWidth, numBands),'parent',handles.axes3);
preview(video, gui);
% Update handles structure
guidata(hObject, handles);

 
  % Train
  % fprintf(ouf, '%0.12f\t%0.12f\t%0.12f\t%0.12f\t%0.12f\t%0.12f\t%0.12f\t%0.12f\t%0.12f\t%0.12f\t%0.12f\t%0.12f\t%0.12f\t%0.12f\t%0.12f\t%0.12f\t%0.12f\t%0.12f\t%d\n', ...
  %   [data, gesture]);

% UIWAIT makes anurag wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = anurag_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Gesture Codes
gestures = containers.Map;
gestures('0') = 'Fist';
gestures('1') = 'One';
gestures('2') = 'Two';
gestures('3') = 'Three';
gestures('4') = 'Four';
gestures('5') = 'Five';
gestures('6') = 'Call Me';
gestures('7') = 'Loser';
gestures('8') = 'Yo Yo honey singh';
gestures('9') = 'Middle Finger';
gestures('10') = 'Thumbs Up';
gestures('11') = 'Thumbs Down';
gestures('12') = 'I Love You';
gestures('13') = 'OK';





 
load('baggedTreesClassifier.mat');
 
while(1)
  %% Segmentation
 global video ;
Irgb   = getsnapshot(video);                                             %returns frame at current instant of time
                                                                           %with three values[h,w,b] ie.,hieght,width of frame and no. of bands associated with object video
  Ihsv   = rgb2hsv(Irgb);
  Iycbcr = rgb2ycbcr(Irgb);
  H  = Ihsv(:, :, 1);                                                      %red intensity
  S  = Ihsv(:, :, 2);                                                      %green
  V  = Ihsv(:, :, 3);                                                      %blue
  cb = Iycbcr(:, :, 2);
  cr = Iycbcr(:, :, 3);
  cond = (H < 0.1 | H > 0.75) & S > 0.1 & S < 0.6 & V > 0.4 & ...
      cb > 90 & cb < 140 & cr > 130;
  cond = bwareaopen(cond, 1000, 8);                                        %bwareaopen() removes white areas with size less than p

  % The location of the hand on the captured RGB image
  fig2 = figure(2);
  set(fig2, 'NumberTitle', 'off', 'Name', 'SnapShot');
  clf
  hold on
  set(gca, 'YDir', 'reverse')
  imagesc(Irgb)                                                            %displays the data in array Irgb as an image that uses the full range of colors in the colormap
  [x,y] = find(cond == 1);
  xmin = min(x) - 30;
  xmax = max(x) + 30;
  ymin = min(y) - 30;
  ymax = max(y) + 30;
  set(plot([ymin ymax ymax ymin ymin], [xmin xmin xmax xmax xmin], ...
      'yellow'), 'LineWidth',1)
  set(text(ymin, xmin - 20, 'Hand'), 'Color', 'yellow')
  hold off
  
  % Segmented image of the hand
  roi = cond(min(x): max(x), min(y): max(y), :);
 
  fig3 = figure(3);
  set(fig3, 'NumberTitle', 'off', 'Name', 'Segmented Image');
 
  imshow(roi, 'InitialMagnification', 'fit')
  
  iptwindowalign(fig2, 'bottom', fig3, 'top');                             %aligning figure windows bottom and top

  %% Geometric Features
  % Area and perimeter
  roiArea = regionprops(roi, 'Area');
  roiPerim = regionprops(roi, 'Perimeter');
  
  % Height and width
  roiSize   = size(roi);
  roiHeight = roiSize(1);
  roiWidth  = roiSize(2);
  
  % Mass center
  check_roiArea = size(roiArea);
  if check_roiArea(1) == 0
      continue
  end
  
  roiCenter = regionprops(roi, 'Centroid');                                %returns dimensions of property ie "centroid" of image "roi"
  roiCenter = getfield(roiCenter, 'Centroid');
  
  % Compactness
  roiArea = getfield(roiArea, 'Area');
  roiPerim = getfield(roiPerim, 'Perimeter');
  
  % Normalized compactness
  roiNormComp = 1 - 4 * pi * roiArea / roiPerim ^ 2;
  
  % Major and minor axes lengths
  roiMajAxis = regionprops(roi, 'MajorAxisLength');
  roiMajAxis = getfield(roiMajAxis, 'MajorAxisLength');
  roiMinAxis = regionprops(roi, 'MinorAxisLength');
  roiMinAxis = getfield(roiMinAxis, 'MinorAxisLength');
  
  % Orientation
  roiOrient = regionprops(roi, 'Orientation');
  roiOrient = getfield(roiOrient, 'Orientation');
  
  % Eccentricity
  roiEccent = regionprops(roi, 'Eccentricity');
  roiEccent = getfield(roiEccent, 'Eccentricity');
  
  % Hu Moments
  hu_moments = HuMoments(roi);
  
  data = table;
  data.Height       = roiHeight;
  data.Width        = roiWidth;
  data.CenterX      = roiCenter(1);
  data.CenterY      = roiCenter(2);
  data.Area         = roiArea;
  data.Perimeter    = roiPerim;
  data.Compactness  = roiNormComp;
  data.MajorAxis    = roiMajAxis;
  data.MinorAxis    = roiMinAxis;
  data.Orientation  = roiOrient;
  data.Eccentricity = roiEccent;
  data.HuMoment1    = hu_moments(1);
  data.HuMoment2    = hu_moments(2);
  data.HuMoment3    = hu_moments(3);
  data.HuMoment4    = hu_moments(4);
  data.HuMoment5    = hu_moments(5);
  data.HuMoment6    = hu_moments(6);
  data.HuMoment7    = hu_moments(7);

  % Classify
  gesture = gestures(int2str(baggedTreesClassifier.predictFcn(data))) ;
  set(handles.outputgest,'String',gesture);
 
end
% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function outputgest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputgest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes during object deletion, before destroying properties.
function axes5_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
