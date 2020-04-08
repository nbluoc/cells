%%Measuring surface of ROIS
%%Counting number of cells (red - blue - green)
%%Written by Emmanouela Foinikianaki
waitfor(msgbox({'Type the number of your photos'}, 'Number of photos'));
prompt = 'Number of photos';
n = input(prompt);
disp('Measuring surface of Regions Of Interest')
%% calibration factor
waitfor(msgbox({'You have to enter the calibration factor which depends on microscope magnification'}, 'Calibration Factor'));
waitfor(msgbox({'Calculation of calibration factor: known distance / distance in pixels'}, 'Measuring your calibration factor'))
prompt = 'Known distance? (um)';
x = input(prompt);
prompt = 'Distance in pixels?';
y = input(prompt);
calibration=x/y;
disp('your calibration factor is:');

%% surface of ROIS
for i=1:n
% num of photos 
 i_str=num2str(i);
filename='photo';
format='.png';
k=[filename,i_str,format];


I=imread(k);        % read image from graphics file
I2 = rgb2gray(I);   % convert rgb to gray scale
[counts , y] = imhist(I2);   
junk = counts(256,1);   % find the total area of white pixels
%%%%%

calibrationFactor = calibration;
disp(calibrationFactor); % convert pixels into um with scale bar
junkum = junk * calibrationFactor ^ 2; %convert junk area into um^2
total = size(I,1)*size(I,2);  % All pixel of image
totalum= total * calibrationFactor ^ 2; %convert total area into um^2
Area(i) = totalum - junkum ;

% 
% filename = 'area.xlsx';
% A(i) = Area(i);
% xlswrite(filename,A(i))
end
disp('Calculating number of cells')
% waitfor(msgbox({'You have to enter the colour of your cells (red - blue - green only)', 'For red : r', 'For blue : b', 'For green : g'}, 'Colour of cells'))
% prompt = 'Colour of cells?';
% c = input(prompt);
waitfor(msgbox({'You have to set your brightness/contrast level', 'You should try the level before making your analysis.', 'Default number of level is 20-25', '(For PFC : 25)', '(For HPC : 20)', '(For motor : 30)', '(For interneurons : 20)'}, 'Brightness/contrast level'));
prompt = 'Brightness/contrast level?';
z = input(prompt);
%% number of cells
for i=1:n
% num of photos 
%     if i==10
% % for k=1:1
%     disp('CHANGE')
% end
    i_str=num2str(i);
filename='photo';
format='.png';
k=[filename,i_str,format];
greenCELL = imread(k);
%display image with scaled colors
imagesc(greenCELL);
r = greenCELL(:, :, 1);
g = greenCELL(:, :, 2);
b = greenCELL(:, :, 3);
% waitfor(msgbox({'You have to enter the colour of your cells (red - blue - green only)', 'For red : r', 'For blue : b', 'For green : g'}, 'Colour of cells'))
% prompt = 'Colour of cells?';
% c = input(prompt);
justRed = b;
bw = justRed >z;
imagesc(bw);
colormap(gray);
cell1 = bwareaopen(bw, 8);
imagesc(cell1);
s  = regionprops(cell1, {'centroid','area'});

[L, num_cells(i)] = bwlabel(cell1,8);
num_cells(i);
end

h = msgbox({'Operation completed' 'The results can be displayed in Matlab workspace matrices ("Area" & "num_cells"). You can check and copy them into an excel sheet by double clicking on them.'}, 'Show results');
disp('!!! Operation completed !!!');


