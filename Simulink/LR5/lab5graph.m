function lab5graph(phi, delta)
 
subplot(2, 1, 1);
plot(phi(:, 1), phi(:, 2), 'b', 'LineWidth', 1);
grid on;
title('Переходные процессы при изменении курса');
xlabel('Время, сек');
ylabel('\phi, градусы');
 
subplot(2, 1, 2);
plot(delta(:, 1), delta(:, 2), 'b', 'LineWidth', 1);
grid on;
xlabel('Время, сек');
ylabel('\delta, градусы');
