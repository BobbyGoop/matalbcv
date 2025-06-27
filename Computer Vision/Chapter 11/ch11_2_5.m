close all;
clear;
clc;

A = imread("Fig1113(a)(chromo_original).tif"); %a
A_d = im2double(A);
h = fspecial('gaussian', 25, 15); 
g = imfilter(A_d, h, 'replicate'); %b
g_bin = imbinarize(g, 1.5*graythresh(g)); %c
s = bwmorph(g_bin, 'skel', Inf); %d
s8 = bwmorph(s, 'spur', 8); %e
s8_8 = s8;
for i = 1:7
    s8_8 = bwmorph(s8_8, 'spur', 1);
end

subplot(2,3,1), imshow(A), title('Исходное изображение');
subplot(2,3,2), imshow(g), title('После сглаживания');
subplot(2,3,3), imshow(g_bin), title('После порогового преобразования');
subplot(2,3,4), imshow(s), title('Остов');
subplot(2,3,5), imshow(s8), title('Остов после восьмикратного удаления отростков');
subplot(2,3,6), imshow(s8_8), title('Еще 7 повторов удаления отростков');

