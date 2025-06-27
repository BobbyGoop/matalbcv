clearvars;
sysdata;
aphi = 1:1:110;
aSi = zeros(1, 110);
aTpp = zeros(1, 110);
for phiZad=aphi
    out = sim ('lab5');
    [si,Tpp] = overshoot ( out.phi(:,1), out.phi(:,2) );
    aSi(phiZad) = si;
    aTpp(phiZad) = Tpp;
end

figure(1); % открыть рис. 1
subplot(2,1,1);
set(gca,'FontSize',16);
plot(aphi,aSi,'red','LineWidth',1.2);
grid on;
title('Изменение перерегулирования');
xlabel('\phi, град');
ylabel('\sigma, %');

subplot(2,1,2);
set(gca,'FontSize',16);
plot(aphi,aTpp,'red','LineWidth',1.2);
grid on;
title('Изменение времени переходного процесса');
xlabel('\phi, градусы');
ylabel('Tpp, сек');