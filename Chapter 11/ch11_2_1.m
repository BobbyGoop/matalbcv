close all;
clc;
clear;

A = imread("Fig1102(a)(noisy_circular_stroke).tif"); %а
h = fspecial('average', 9);
g = imfilter(A, h, 'replicate'); %б
g_bin = imbinarize(g, 0.5); %в
B = boundaries(g_bin);
d = cellfun('length', B);
[max_d, keys] = max(d);
b = B{1};
[M, N] = size(g_bin);
g_bound = bound2im(b, M, N, min(b(:, 1)), min(b(:, 2))); %г
[s, su] = bsubsamp(b, 50);
g2 = bound2im(s, M, N, min(s(:, 1)), min(s(:, 2))); %д
cn = connectpoly(s(:, 1), s(:, 2));
g2_bound = bound2im(cn, M, N, min(cn(:, 1)), min(cn(:, 2))); %е
c = fchcode(su); %c.fcc 

subplot(2,3,1), imshow(A), title("Исходное изображение");
subplot(2,3,2), imshow(g), title('Сглаженное маской 9х9');
subplot(2,3,3), imshow(g_bin), title('После пороговой обработки');
subplot(2,3,4), imshow(g_bound), title('Граница двоичного изображения');
subplot(2,3,5), imshow(g2), title('Укрупняющая подвыборка границы');
subplot(2,3,6), imshow(g2_bound), title('Соединенные точки');

