clearvars;
close all;

sysdata;
figure;

aT = [2 3 5];
col = 'rmb';
for i=1:length(aT)
    T = aT(i);
    Dpd = c2d ( Cpd, T, 'tustin' );
    [nD,dD] = tfdata ( Dpd, 'v' );
    out = sim('lab7');
    subplot(2,1,1);
    plot(out.phi(:,1),out.phi(:,3),col(i));
    hold on;
    subplot(2,1,2);
    plot(out.delta(:,1),out.delta(:,3),col(i));
    hold on;
    
end

subplot(2,1,1);
%set(gca,'FontSize',16);
plot(out.phi(:,1),out.phi(:,2), 'g');
grid on;
legend('T=2', 'T=3', 'T=5', 'Непрерывная система', 'Location', 'southeast');
title('Курс');
xlabel('Время, сек');
ylabel('\phi, градусы');
h = get(gca, 'Children');
for i=1:4
    set(h(i),'LineWidth',1);
end

subplot(2,1,2);
%set(gca,'FontSize',16);
plot(out.delta(:,1),out.delta(:,2), 'g');
grid on;
legend('T=2', 'T=3', 'T=5', 'Непрерывная система');
title('Угол поворота руля');
xlabel('Время, сек');
ylabel('\delta, градусы');
h = get(gca, 'Children');
for i=1:4
    set(h(i),'LineWidth',1);
end


