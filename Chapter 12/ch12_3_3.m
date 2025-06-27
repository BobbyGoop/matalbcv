close all;
clear;
clc;

A = imread("images/Hurricane Andrew).tif");
mask = imread("images/hurricane_mask).tif");
g = dftcorr(A, mask);
gs = gscale(g);
[I, J] = find(g == max(g(:)));

subplot(2,2,1), imshow(A), title('Исходное изображение');
subplot(2,2,2), imshow(mask), title('Маска');
subplot(2,2,3), imshow(gs), title('Корреляция изображения и маски');
subplot(2,2,4), imshow(gs > 254), title('Положение наилучшего совпадения');