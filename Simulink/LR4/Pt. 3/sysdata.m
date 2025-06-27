clc;
close all;
% FOR VAR. 9
K = 0.08;
Ts = 18;
Tr = 1;
Toc = 5;

ddMax = 3;
deltaMax = 30;
phiZad = 30;
fConst = 0;
Ti = 200;

Kc = 0.7045;
Kaw = 1;
T = 1;

Cpd = tf(Kc*[Ts+1 1], [1 1]);
Dpd = c2d ( Cpd, T, 'tustin' );
[nD,dD] = tfdata ( Dpd, 'v' );