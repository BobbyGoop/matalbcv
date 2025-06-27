function [sigma,Tpp] = overshoot ( t, y )
yInf = y(end);
diff = (y - yInf) / abs (yInf);
sigma = max(diff) * 100;
i = find(abs(diff) > 0.02);
Tpp = t(max(i)+1);
