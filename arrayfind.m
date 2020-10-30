clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;
brightness=0.10;
threshold=0.07;    %threshold
opengl hardware
addpath 'C:\Users\Shamanth\Documents\MATLAB\pictures\dataset'
[imgfile ,pathname] = uigetfile({'*.jpg';'*.bmp';'*.jpeg';},'Select image');
img=imread(imgfile);
imshow(img);
%img = bsxfun(@times, img, cast(BWnoteacher, 'like', img));
%imshow(img);
%L = superpixels(img,500);
%title('draw foreground', 'FontSize', fontSize);
%fore = drawpolyline('Color','green');
%title('draw background', 'FontSize', fontSize);
%bak=drawpolyline('Color','red');
%roiPointsbak = bak.Position;
%roibak = poly2mask(roiPointsbak(:,1),roiPointsbak(:,2),size(L,1),size(L,2));
%roiPointsfore = fore.Position;
%roifore = poly2mask(roiPointsfore(:,1),roiPointsfore(:,2),size(L,1),size(L,2));
%BW = grabcut(img,L,roifore);
%figure
%imshow(BW)
%segmentation
[J,rect]=imcrop(img);
img=lazy_snapping_f(img,rect);
%segmentation end
X=rgb2gray(img);
grayImage = X;
% Get the dimensions of the image.  
% numberOfColorBands should be = 1.
[rows, columns, numberOfColorBands] = size(grayImage);
if numberOfColorBands > 1
	% It's not really gray scale like we expected - it's color.
	% Convert it to gray scale by taking only the green channel.
	grayImage = grayImage(:, :, 2); % Take green channel.
end
% Display the original gray scale image.

imshow(grayImage);
title('Original Grayscale Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Give a name to the title bar.
set(gcf, 'Name', 'Original image after process', 'NumberTitle', 'Off') 

[gMag, gDir] = imgradient(grayImage, 'Sobel');
imgre=mat2gray(gMag);
imshow(imgre);
[y, x] = find(imgre < threshold);
imshow(imgre);
imtool(imgre);
m = size(y,1);
imgre=imgre+brightness;
%I_eq = adapthisteq(imgre);
imshow(imgre)

% for 3 channels

for c = 1:m
   img(y(c),x(c),1)=0;
   img(y(c),x(c),2)=0;
   img(y(c),x(c),3)=0;
end
img=img+brightness;
imshow(img)



function maskedImage=lazy_snapping_f(RGB,rect)
xmin=rect(1);ymin=rect(2);width=rect(3);height=rect(4);
%figure,imshow(RGB);
[x,y]=size(RGB);
L=superpixels(RGB,500);
%f = drawrectangle(gca,'Position',[0.25*width+xmin 0.25*height+ymin 0.60*width 0.60*height],'Color','g');
f = drawrectangle(gca, 'Color','g');
foreground=createMask(f,RGB);
b1 = drawrectangle(gca,'Position',[0 0 x ymin],'Color','r');
b2 = drawrectangle(gca,'Position',[xmin+width ymin x-xmin+width height],'Color','r');
b3 = drawrectangle(gca,'Position',[0 ymin xmin height],'Color','r');
b4 = drawrectangle(gca,'Position',[0 ymin+height x y-ymin+height],'Color','r');
background = createMask(b1,RGB) + createMask(b2,RGB) + createMask(b3,RGB) + createMask(b4,RGB);
BW = lazysnapping(RGB,L,foreground,background);
figure,imshow(labeloverlay(RGB,BW,'Colormap',[0 1 0]))
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
imshow(maskedImage)
end
