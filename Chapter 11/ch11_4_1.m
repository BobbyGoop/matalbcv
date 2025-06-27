clear;
close all;
clc;

A = imread("Fig1111(b)(boundary_triangle).tif");
B = bwlabel(A);
D = regionprops(B, 'area', 'BoundingBox');
w = [D.Area];
NR = length(w);
V = cat(1, D.BoundingBox);
figure(1);
imshow(A);
hold on;
for i = 1:NR
rectangle('Position', V(i,:), 'EdgeColor', 'r', 'LineWidth', 2);
end
title('Ограничивающий прямоугольник');
hold off;