close all;
clear;
clc;

A_sq = imread("Fig1111(a)(boundary_sq.tif");
A_tr = imread("Fig1111(b)(boundary_triangle).tif");
b_sq = boundaries(A_sq);
b_tr = boundaries(A_tr);
B_sq = b_sq{1};
B_tr = b_tr{1};

[st_sq, angle_sq, x0_sq, y0_sq] = signature(B_sq);
[st_tr, angle_tr, x0_tr, y0_tr] = signature(B_tr);

subplot(2,2,1), imshow(A_sq), title('Квадрат');
subplot(2,2,2), imshow(A_tr), title('Треугольник');
subplot(2,2,3), plot(st_sq), title('Сигнатура квадрата');
subplot(2,2,4), plot(st_tr), title('Сигнатура треугольника');

