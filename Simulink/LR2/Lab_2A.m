% Вставлять данные по вариантам сюда
% n = [n2 n1 n0]
% d = [1 d2 d1 d0]

n = [1.8 -1.98 -0.4320]
d = [1 1.2 0.7644 0.3556]

f = tf ( n, d )

z = zero(f)
p = pole(f)
k = dcgain(f)
b = bandwidth(f)

f_ss = ss(f)
f_ss.d = 1

k1 = dcgain(f_ss)
b1 = bandwidth(f_ss)
f_zp = zpk(f)

pzmap(f)

[wc,ksi,p] = damp ( f )

%ltview

w = logspace(-1, 2, 100);
r = freqresp ( f, w );
r = r(:);
semilogx ( w, abs(r) )
[u,t] = gensig('square',4);
lsim (f, u, t)
