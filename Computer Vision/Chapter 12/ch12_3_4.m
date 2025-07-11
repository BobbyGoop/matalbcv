close all;
clear;
clc;
figure(1);
A1 = imread("Fig1202(a)(WashingtonDC_Band1_512).tif");
A2 = imread("Fig1202(b)(WashingtonDC_Band2_512).tif");
A3 = imread("Fig1202(c)(WashingtonDC_Band3_512).tif");
A4 = imread("Fig1202(d)(WashingtonDC_Band4_512).tif");
B1 = roipoly(A1);
B2 = roipoly(A2);
B3 = roipoly(A3);
stack = cat(3, A1, A2, A3, A4);
[X1, R1] = imstack2vectors(stack, B1);
[X2, R2] = imstack2vectors(stack, B2);
[X3, R3] = imstack2vectors(stack, B3);
[C1, m1] = covmatrix(X1.Y);
[C2, m2] = covmatrix(X2.Y);
[C3, m3] = covmatrix(X3.Y);
CA = cat(3, C1, C2, C3);
MA = cat(2, m1, m2, m3);
dY1 = bayesgauss(Y1, CA, MA);
dY2 = bayesgauss(Y2, CA, MA);
dY3 = bayesgauss(Y3, CA, MA);
IY1 = find(dY1 ~= 1);
IY2 = find(dY2 ~= 1);
IY3 = find(dY3 ~= 1);