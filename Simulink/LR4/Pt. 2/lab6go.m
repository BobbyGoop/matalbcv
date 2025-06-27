sysdata;
Kaw = 1;
out = sim ('lab6' );

figure;
subplot(2,1,1);
set(gca,'FontSize',16);
plot(out.phi(:,1),out.phi(:,2),'red');
hold on;
plot(out.phi(:,1),out.phi(:,3),'magenta');
hold off;
hold on;
plot(out.phi(:,1),out.phi(:,4),'blue');
hold off;
grid on;
legend('Линейная система','Система с компенсацией', 'Нелинейная система', 'Location', 'b')          
title('Курс: поворот на 90 градусов');
xlabel('Время, сек');
ylabel('\phi, градусы');
h = get(gca, 'Children');
set(h(1),'LineWidth',1.2);
set(h(2),'LineWidth',1.2);
set(h(3),'LineWidth',1.2);

subplot(2,1,2);
set(gca,'FontSize',16);
plot(out.delta(:,1),out.delta(:,2),'red');
hold on;
plot(out.delta(:,1),out.delta(:,3),'magenta');
hold off;
hold on;
plot(out.delta(:,1),out.delta(:,4),'blue');
hold off;
grid on;
minimum = min(out.delta);
legend('Линейная система','Система с компенсацией', 'Нелинейная система');  
                
            
title('Угол поворота руля');
xlabel('Время, сек');
ylabel('\delta, градусы');
h = get(gca, 'Children');
set(h(1),'LineWidth',1.2);
set(h(2),'LineWidth',1.2);
set(h(3),'LineWidth',1.2);