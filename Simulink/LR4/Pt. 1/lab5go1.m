clearvars;
sysdata;
Ts0 = Ts;
aTs = linspace(0.8, 1.2, 100) * Ts0;
aSi = zeros(1, 100);
aTpp = zeros(1, 100);
k = 1;
for Ts=aTs
    out = sim ( 'lab5_ts0' );
    [si,Tpp] = overshoot ( out.phi(:,1), out.phi(:,2) );
    aSi(k) = si;
    aTpp(k) = Tpp;
    k = k+1;
end

figure(1); % открыть рис. 1
subplot(2,1,1);
set(gca,'FontSize',16);
plot(aTs,aSi,'r','LineWidth',1.2);
grid on;
title('Изменение перерегулирования');
xlabel('Ts, сек');
ylabel('\sigma, %');

subplot(2,1,2);
set(gca,'FontSize',16);
plot(aTs,aTpp,'r','LineWidth',1.2);
grid on;
title('Изменение времени переходного процесса');
xlabel('Ts, сек');
ylabel('Tpp, сек');