function lab5graph ( phi, delta )
figure(1); % открыть рис. 1
subplot(2,1,1);

set(gca,'FontSize',16);
plot(phi(:,1),phi(:,2),'red');
grid on;
title('Переходные процессы при изменении курса');
xlabel('Время, сек');
ylabel('\phi, градусы');
h = get(gca, 'Children');

subplot(2,1,2);

set(gca,'FontSize',16);
plot(delta(:,1),delta(:,2),'red');
grid on;
xlabel('Время, сек');
ylabel('\delta, градусы');
h = get(gca, 'Children');



