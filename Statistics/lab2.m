% описание символических переменных
syms x k 

% границы интервала
x1=0; x2=2;

% плотность распределения
f=k*(x+3)*(x+3); 
fprintf('f(x) = %s\n',char(f))

I1=int(f,x,x1,x2); % считаем интеграл
ks=solve(I1-1,k); % решаем уравнение I1 - 1 = 0
fprintf('Множитель k = %s\n',char(ks))

% ПЛОТНОСТЬ РАСПРЕДЕЛЕНИЯ
fs=subs(f,k,ks); % подставили решение
fprintf('\nПлотность распределения:\n')
fprintf('f(x) = %s; %d <= x <= %d',char(fs),x1,x2)
fprintf('\nf(x) = 0 вне этого отрезка.\n')

% ФУНКЦИЯ РАСПРЕДЕЛЕНИЯ
F=int(fs,x,x1,x); 
fprintf('\nФункция распределения:\n')
fprintf(['F(x) = 0 при x < %d;\nF(x) = %s при %d <=x <= %d\n' ...
    'F(x) = 1 при x > %d.\n'],x1,char(F),x1,x2,x2)

tiledlayout(1, 2);
set(gcf,'Position',[100 100 1720 880])
% ОТРИСОВКА ПЛОТНОСТИ РАСПРЕДЕЛЕНИЯ

xp1=x1-0.25*(x2-x1); % границы рисунка
xp2=x2+0.25*(x2-x1);
xp=linspace(xp1,xp2,1000); % абсциссы для графика
fp=subs(fs,x,xp).*(xp>=x1).*(xp<=x2); % ординаты

nexttile;
plot(xp,fp) % рисуем график
%ax1.set(get(gcf,'CurrentAxes'),'FontName','Times New Roman Cyr','FontSize',10) 
title('\bfПлотность распределения') % заголовок
xlabel('\itx') % метка оси OX
ylabel('\itf\rm(\itx\rm)') % метка оси OY


% ОТРИСОВКА ФУНКЦИИ РАСПРЕДЕЛЕНИЯ
Fp=subs(F,x,xp).*(xp>=x1).*(xp<=x2)+ones(size(xp)).*(xp>x2); % ординаты

nexttile
plot(xp,Fp) % рисуем график
ylim([0 1.2]); % границы по вертикали
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman Cyr','FontSize',10)
title('\bfФункция распределения') % заголовок
xlabel('\itx') % метка оси OX
ylabel('\itF\rm(\itx\rm)') % метка оси OY
ylabel('\itf\rm(\itx\rm)') % метка оси OY

% РАССЧЕТЫ
mx=int(x*fs,x,x1,x2); % вычисляем МО
fprintf('\nMx = %s = %8.5f.\n', char(mx), eval(mx))

[fmax,ifmax]=max(fp); % максимальная f(x)
modx=xp(ifmax); % мода распределения
fprintf('Мода = %5.2f.\n',modx);

medx=solve(F-0.5); % ищем медиану F = 1\2 (F - 0.5 = 0)
disp("Возможные значения медианы: ")
disp(double(medx))


fprintf('\nНачальные моменты:\n');
for i=1:4
 alpha=int(x^i*fs,x,x1,x2); % момент i-го порядка
 fprintf('Alpha(%d) = %s = %12.5f\n', i, char(alpha), eval(alpha));
end

fprintf('\nЦентральные моменты:\n');
for i=1:4
 mu=int((x-mx)^i*fs,x,x1,x2); % момент i-го порядка
 fprintf('Mu(%d) = %s = %.5f\n',i,char(mu),eval(mu));
end

Dx=simplify(int((x-mx)^2*fs,x,x1,x2)); % дисперсия
Sx=simplify(Dx^0.5); % СКО
Ax=simplify(int((x-mx)^3*fs,x,x1,x2)/Sx^3); % асимметрия
Ex=simplify(int((x-mx)^4*fs,x,x1,x2)/Dx^2-3); % эксцесс

fprintf('\nДисперсия, СКО, Ассиметрия, Эксцесс\n')
fprintf('Dx= %s = %8.5f;\n',char(Dx),eval(Dx));
fprintf('Sx = %s = %8.5f;\n',char(Sx),eval(Sx));
fprintf('Ax= %s = %8.5f;\n',char(Ax),eval(Ax));
fprintf('Ex = %s= %8.5f.\n',char(Ex),eval(Ex));