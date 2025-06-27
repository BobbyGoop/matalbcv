clear;
clc;
close all;

A = imread("Fig1116(a)(chromo_binary).tif");
b = boundaries(A);
b = b{1};
[M, N] = size(A);
bim = bound2im(b, M, N);
z = frdescp(b);
z546   = ifrdescp(z, 546);
z546im = bound2im(z546, M, N);
z110   = ifrdescp(z, 110);
z110im = bound2im(z110, M, N);
z56   = ifrdescp(z, 56);
z56im = bound2im(z56, M, N);
z28   = ifrdescp(z, 28);
z28im = bound2im(z28, M, N);
z14   = ifrdescp(z, 14);
z14im = bound2im(z14, M, N);
z8   = ifrdescp(z, 8);
z8im = bound2im(z8, M, N);

figure(1);
subplot(1,2,1), imshow(A), title('Исходное изображение');
subplot(1,2,2), imshow(bim), title('Граница');

figure(2);
subplot(2,3,1), imshow(z546im), title('Границы, восстановленные по 546');
subplot(2,3,2), imshow(z110im), title('Границы, восстановленные по 110');
subplot(2,3,3), imshow(z56im), title('Границы, восстановленные по 56');
subplot(2,3,4), imshow(z28im), title('Границы, восстановленные по 28');
subplot(2,3,5), imshow(z14im), title('Границы, восстановленные по 14');
subplot(2,3,6), imshow(z8im), title('Границы, восстановленные по 8');

