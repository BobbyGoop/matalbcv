clearvars;
close all;
sf='data/data (7).txt'; % имя файла данных
od=load(sf); % вводим ИД
x=od(2:end,1); % уровни фактора x
y=od(1,2:end); % уровни фактора y
z=od(2:end,2:end); % результаты эксперимента
l=length(x);
m=length(y);
fprintf('Количество уровней фактора x: l=%d\n',l);
fprintf('Количество уровней фактора y: m=%d\n',m);
[X,Y]=meshgrid(y,x); % сетка узловых точек
XY=[ones(l*m,1) X(:) Y(:)]; % матрица эксперимента
q=0.05; % уровень значимости
[b,bint]=regress(z(:),XY,q); % линейная модель
disp('Доверительные интервалы для параметров модели');
fprintf('на уровне значимости q=%5.2f\n',q)
disp(' N НиГр ВеГр');
fprintf('%2.0f %12.7f %12.7f\n',[[1:3];bint']);
disp('Линейная модель:')
fprintf('z(x,y)=%f12%+f12*x%+f12*y.\n',b);
zt=b(1)+b(2)*X+b(3)*Y; % теоретические аппликаты
figure;
surf(X,Y,zt); % теоретическая поверхность
hold on
plot3(X,Y,z,'b.'); % экспериментальные точки
hold off
set(get(gcf,'CurrentAxes'),...
 'FontName','Times New Roman Cyr','FontSize',14)
title('\bfЛинейная модель для 2-факторного эксперимента')
xlabel('\itx') % метка оси OX
ylabel('\ity') % метка оси OY
zlabel('\itz') % метка оси OZ
box on % ограничивающий прямоугольник
grid on % сетка
view(-130,25) % выбрали точку просмотра