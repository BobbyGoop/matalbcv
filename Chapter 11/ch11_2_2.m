close all;
clear;
clc

A = imread("Fig1107(a)(mapleleaf).tif"); %a
b = boundaries(A, 4, 'cw');
b = b{1};
[M, N] = size(A);
xmin = min(b(:, 1));
ymin = min(b(:, 2));
bim = bound2im(b, M, N, xmin, ymin); %б

[x2, y2] = minperpoly(A, 2);
b2 = connectpoly(x2, y2);
B2 = bound2im(b2, M, N, xmin, ymin); %в

[x3, y3] = minperpoly(A, 3);
b3 = connectpoly(x3, y3);
B3 = bound2im(b3, M, N, xmin, ymin); %г

[x4, y4] = minperpoly(A, 4);
b4 = connectpoly(x4, y4);
B4 = bound2im(b4, M, N, xmin, ymin); %д

[x8, y8] = minperpoly(A, 8);
b8 = connectpoly(x8, y8);
B8 = bound2im(b8, M, N, xmin, ymin); %е

subplot(2,3,1), imshow(A), title('Исходное изображение');
subplot(2,3,2), imshow(bim), title('4-связная граница');
subplot(2,3,3), imshow(B2), title('МРР по ячейкам сторон в 2 пиксела');
subplot(2,3,4), imshow(B3), title('МРР по ячейкам сторон в 3 пиксела');
subplot(2,3,5), imshow(B4), title('МРР по ячейкам сторон в 4 пиксела');
subplot(2,3,6), imshow(B8), title('МРР по ячейкам сторон в 8 пиксела');
