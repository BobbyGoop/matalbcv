clearvars;
clc;
sf='data/SBER.txt'; % имя файла ИД
y=importdata(sf); % вводим ИД - 2 столбца

x=linspace(0, 505, 505);
x = x (:);
% x=xy(:,1); % аргументы
% y=xy(:,2); % функции

n=length(x); % количество точек
fprintf('Количество экспериментальных точек n=%d.\n',n);
q=0.01; % уровень значимости
kmax=20; % максимальный показатель степени
k=[0:kmax]; % все степени
X=repmat(x,1,kmax+1).^repmat(k,n,1); % базисные функции
X(:,1)=X(:,1)/norm(X(:,1)); % нормируем 1-й столбец
for ki=2:kmax+1, % ортонормируем столбцы
Sum=0; % накапливаем сумму
for kk=1:ki-1,
Sum=Sum+(X(:,ki)'*X(:,kk))*X(:,kk);
end
X(:,ki)=X(:,ki)-Sum;
X(:,ki)=X(:,ki)/norm(X(:,ki));
end
[b,bint]=regress(y,X,q); % регрессионная модель
disp('Доверительные интервалы для параметров модели');
fprintf('на уровне значимости q=%5.2f\n',q)
disp(' k НиГр ВеГр');
fprintf('%2.0f %12.7f %12.7f\n',[k;bint']);
np=find(prod(bint,2)>0); % учитываем степени
fprintf('Учитываем степени:');
fprintf(' %d',k(np));
fprintf('.\n');
mmax=max(k(np)); % максимальная степень
p=polyfit(x,y,mmax); % коэффициенты полинома
fprintf('Аппроксимирующий полином %d-й степени:\ny(x)=',mmax);
fprintf('%+f12*x^%d',[p;[mmax:-1:0]]);
fprintf('\n');
yt=polyval(p,x); % теоретические значения
figure;
plot(x,y,'k.',x,yt,'k-');
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman Cyr','FontSize',10)
title('\bfАппроксимация степенными полиномами')
xlabel('\itx') % метка оси OX
ylabel('\ity') % метка оси O