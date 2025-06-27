clearvars;
close all;
sf='data/data (15).txt'; % имя файла данных

xy=load(sf); % вводим ИД - 2 столбца
x=xy(:,1); % аргументы
y=xy(:,2); % функции
if ~all(abs(diff(diff([0;x])))<1e-10)
     error('Условие (14.50) не выполняется!')
end
n=length(x); % количество точек
fprintf('Количество экспериментальных точек n=%d.\n',n);
q=0.01; % уровень значимости
kmax=10; % максимальный номер гармоники
T=max(x); % период
X=ones(n,1)/n^0.5; % 1-й столбец матрицы базисных функций
for k=1:kmax % добавляем ортонормированные столбцы
 X=[X [cos(2*pi*k*x/T) sin(2*pi*k*x/T)]*(2/n)^0.5];
end
k=[0 reshape(repmat([1:kmax],2,1),2*kmax,1)'];
[b,bint]=regress(y,X,q); % регрессионная модель
disp('Доверительные интервалы для параметров модели');
fprintf('на уровне значимости q=%5.2f\n',q)
disp('гарм НиГр ВеГр');
fprintf('%2.0f %12.7f %12.7f\n',[k;bint']);
np=find(prod(bint,2)>0); % учитываем базисные функции
fprintf('Учитываем гармоники:');
fprintf(' %d',unique(k(np)));
fprintf('.\n');
mmax=max(k(np)); % максимальная гармоника
a0=b(1)/(n/4)^0.5; % a0
ak=b(2:2:2*mmax)'/(n/2)^0.5; % a(k)
bk=b(3:2:2*mmax+1)'/(n/2)^0.5; % b(k)
fprintf('Тригонометрический полином %d-й степени:\n',mmax)
fprintf('y(x)=%f12',a0/2); % средний уровень
w=[1:mmax;ones(1,mmax)*T]; % вспомогательный массив
fprintf(['%+f12*cos(2*pi*%d*x/%d)%+f12'...
 '*sin(2*pi*%d*x/%d)'],[ak;w;bk;w]);
fprintf('\n');
yt=a0*ones(size(x))/2; % теоретические значения
for k=1:mmax
 yt=y;
end
figure
plot(x,y,'.k',[0;x],[yt(end);yt],'-k')
set(get(gcf,'CurrentAxes'),...
 'FontName','Times New Roman Cyr','FontSize',10)
title('\bfТригонометрическая аппроксимация')
xlabel('\itx') % метка оси OX
ylabel('\ity') % метка оси OY