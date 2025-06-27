% ПЕРВАЯ ЛАБА ЖУКОВА
% ИЗМЕНЯТЬ ДАННЫЕ В ЭТИХ СТРОЧКАХ

% x=[-2 -1 0 1 2 3 4];
% p=[0.1 0.12 0.15 0.22 0.19 0.12 0.1];

% x = [-2 -1 0 1 2 3 4];
% p = [0.1 0.12 0.2 0.25 0.18 0.1 0.05];

% x0 = 0
x = [-1 0 1 2 3 4 5];
p = [0.08 0.1 0.17 0.24 0.18 0.12 0.11];

tiledlayout(1, 2);
set(gcf,'Position',[100 100 1720 880])

% Многгоугольник распределения
p=p/sum(p);
nexttile;
plot(x,p,'k-',x,p,'k.')
ylim([0 0.25])
title('\bfМногоугольник распределения')
xlabel('\itx') 
ylabel('\itP\rm(\itx\rm)')
%xlim([-2.5 4.5])

% Функция распределения
F=cumsum(p); % значения функции распределения
x1=[x(1)-0.5 x x(end)+0.5]; % добавки слева и справа
F1=[0 F 1];
%figure; % новая фигура
nexttile;
stairs(x1,F1,'k-'); % ломаная
xl=xlim; % границы рисунка
yl=ylim;
hold on
plot(x,F1(1:end-2),'k.') % добавили точки
hh=get(gca);
hp=hh.Position; % положение осей на фигуре
for i=1:length(F)
xi=x1(2+i:-1:1+i); % координаты стрелок
Fi=[F(i) F(i)];
xi=(xi-xl(1))/(xl(2)-xl(1))*hp(3)+hp(1); % нормализуем
Fi=(Fi-yl(1))/(yl(2)-yl(1))*hp(4)+hp(2); % стрелки
annotation('arrow',xi,Fi); % добавляем стрелки
end
hold off
set(get(gcf,'CurrentAxes'),...
'FontName','Times New Roman Cyr','FontSize',10) % шрифт
title('\bfФункция распределения') % заголовок
xlabel('\itx') % метка оси OX
ylabel('\itF\rm(\itx\rm)') % метка оси OY

% МО
mx=sum(x.*p);
fprintf('Математическое ожидание Mx=%8.5f.\n',mx);

% Мода
[pmax,ipmax]=max(p); % pmax и номер точки
modx=x(ipmax); % мода распределения
fprintf('Мода =%5.2f.\n',modx);

% Начальные моменты
disp('Начальные моменты:');
for i=1:7
alpha=sum(x.^i.*p); % момент i-го порядка
fprintf('Alpha(%d)=%12.5f\n',i,alpha);
end

% Центральные моменты
disp('Центральные моменты:');
for i=1:5
mu=sum((x-mx).^i.*p); % момент i-го порядка
fprintf('Mu(%d)=%12.5f\n',i,mu);
end

% высчитываем дисперсию
Dx=sum((x-mx).^2.*p);
Dx2 = var(x);
fprintf('Дисперсия Dx = %5.5f;\n',Dx);

%высчитываем среднеквадратичное отклонение
Sx=Dx^0.5;
fprintf('Среднеквадратичное отклонение Sx = %5.5f;\n',Sx);

% высчитываем асимметрию
Ax=sum((x-mx).^3.*p)/Sx^3;
fprintf('Асимметрия Ax = %5.5f;\n',Ax);

% высчитываем эксцесс
Ex=sum((x-mx).^4.*p)/Dx^2-3;
fprintf('Эксцесс Ex = %5.5f.\n',Ex)