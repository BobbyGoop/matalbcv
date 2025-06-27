figure; % открыть рис. 1

subplot(2,1,1);
set(gca,'FontSize',16);

plot(out.phi(:,1),out.phi(:,2),'magenta');
hold on;
plot(out.phi(:,1),out.phi(:,3),'red');
hold off;

legend('Линейная система', 'Нелинейная система', 'location', 'best')            
title('Курс: поворот на 90 градусов');
xlabel('Время, сек');
ylabel('\phi, градусы');
h = get(gca, 'Children')
set(h(1),'LineWidth',1)
set(h(2),'LineWidth',1)

subplot(2,1,2);
set(gca,'FontSize',16);

plot(out.delta(:,1),out.delta(:,2),'magenta');
hold on;
plot(out.delta(:,1),out.delta(:,3),'red');
hold off;

legend('Линейная система', 'Нелинейная система','location', 'best')
                
title('Угол поворота руля');
xlabel('Время, сек');
ylabel('\delta, градусы');
h = get(gca, 'Children')
set(h(1),'LineWidth',1)
set(h(2),'LineWidth',1)


