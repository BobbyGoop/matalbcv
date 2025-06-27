% P = tf ( K, [Ts 1 0] )
% R0 = tf ( 1, [TR 0] )

% P = tf ( 0.08, [18 1 0] )
% R0 = tf ( 1, [1 0] )

P = tf ( 0.06, [17.6 1 0] )
R0 = tf ( 1, [1 0] )

R = feedback ( R0, 1 )

G = P * R

% H = tf ( 1, [Toc 1] )

H = tf ( 1, [3 1] )
L = G * H

%bode ( L )
%step(G)
%sisotool(G, H)
% Cpd = 1 + tf ( [18 0], [1 1] )
Cpd = 1 + tf ( [17.6 0], [1 1] )
sisotool(G, H, Cpd)



C = 1
W = C*G / (1 + C*G*H)

Wm = minreal(W)

pole ( Wm )

dcgain ( Wm )

Wu = minreal(C/ (1 + C*G*H))


step ( Wu )