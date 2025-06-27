
close all;
sf='data/data (3).txt'; % имя файла данных

x=load(sf); % вводим ИД
x=sort(x(:)); % переформатировали столбец и рассортировали
n=length(x); % количество данных
f=n-1; % число степеней свободы

xmin=x(1); % минимальное значение
xmax=x(n); % максимальное значение

Mx=mean(x); % математическое ожидание
Dx=var(x); % дисперсия
Sx=std(x); % среднеквадратичное отклонение
Ax=skewness(x,0); % несмещенная асимметрия
Ex=kurtosis(x,0)-3; % несмещенный эксцесс
Medx=median(x); % медиана
Rx=range(x); % размах выборки

p=[0.9;0.95;0.99;0.999]; % задаём доверительные вероятности
q=1-p; % уровни значимости

Da=6*(n-1)/(n+1)/(n+3); % дисперсия Ax
De=24*n*(n-2)*(n-3)/(n+1)^2/(n+3)/(n+5); % дисперсия Ex
Axd=[p,Ax-(Da./q).^0.5,Ax+(Da./q).^0.5]'; % формула (10.19)
Exd=[p,Ex-(De./q).^0.5,Ex+(De./q).^0.5]'; % формула (10.20)

fprintf('Простейший тест: q=%2.0f%% - ',q(1)*100);
if prod(Axd(2:3,1)) || prod(Exd(2:3,1)) % простейший критерий
    fprintf('отвергаем основную гипотезу.\n')
else
    fprintf('принимаем основную гипотезу.\n')
end

fprintf('Тест Жарка-Бера: q=%2.0f%% - ',q(1)*100);
if jbtest(x,q(1)) % критерий Жарка-Бера
    fprintf('отвергаем основную гипотезу.\n')
else
    fprintf('принимаем основную гипотезу.\n')
end

k=round(n^0.5); % число интервалов для построения гистограммы
d=(xmax-xmin)/k; % ширина каждого интервала
del=(xmax-xmin)/20; % добавки влево и вправо
xl=xmin-del;
xr=xmax+del; % границы интервала для построения графиков

fprintf('Число интервалов k=%d\n',k)
fprintf('Ширина интервала h=%14.7f\n',d)

figure % создаем новую фигуру
histogram(x,k) % построили гистограмму
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman Cyr','FontSize',10)
title('\bfГистограмма') % заголовок
xlim([xl xr]) % границы по оси OX
xlabel('\itx_{j}') % метка оси x
ylabel('\itn_{j}') % метка оси y

dlist = {  'Extreme Value'; 
           'Exponential'; 
           'Gamma'; 
           'Lognormal';
           'Normal'; 
           'Rayleigh'; 
           'Uniform'; 
           'Weibull'
};

dlistr = { 'гамбеловское'; 
           'экспоненциальное';
           'гамма -'; 
           'логнормальное'; 
           'нормальное'; 
           'рэлеевское';
           'равномерное'; 
           'вейбулловское'
};

dparname={ {'mu' 'sigma'};
           {'mu'};
           {'a' 'b'};
           {'mu' 'sigma'};
           {'mu' 'sigma'};
           {'b'};
           {'a' 'b'};
           {'a' 'b'}
};

ndist=length(dlist); % количество распределений
for idist=1:ndist % подбираем параметры для всех распределений
    phatone=mle(x,'distribution',dlist{idist});
    phat{idist}=phatone; % запомнили
end
disp('Параметры различных распределений по ПМП:')

for idist=1:ndist % печатаем параметры для всех распределений
    fprintf('%s распределение:',dlistr{idist});
    parname=dparname{idist}; % список параметров
    phatone=phat{idist}; % значения параметров
    for ipar=1:length(parname) % печатаем параметры
        fprintf(' %s=%14.10f;',parname{ipar},phatone(ipar));
    end   
    fprintf('\n');
end

[Fi,xi]=ecdf(x); % эмпирическая функция распределения

figure % создаем новую фигуру
ecdfhist(Fi,xi,k) % построили нормированную гистограмму
xpl=linspace(xl,xr,1000); % абсциссы для графиков

hold on % задержка для рисования на одном графике
for idist=1:ndist % рисуем теоретические распределения
    phatone=phat{idist}; % значения параметров
    com=['pdf(''' dlist{idist} ''',xpl']; % команда

    for ipar=1:length(phatone) % добавляем параметры
        com=[com ',' sprintf('%d',phatone(ipar))];
    end

    com=[com ')']; % сформировали команду
    ypl=eval(com); % выполнили команду - вычислили f(x)
    plot(xpl,ypl,'k-') % добавили на график
    [ym,iym]=max(ypl); % максимум на графике
    h=text(xpl(iym),ym,dlist{idist}); % название распределения
    set(h,'FontName','Times New Roman Cyr','FontSize',10)
end
hold off % выключили задержку

set(get(gcf,'CurrentAxes'), 'FontName','Times New Roman Cyr','FontSize',10)
title('\bfЭмпирическая и теоретические\rm \itf\rm(\itx\rm)') % заголовок
xlim([xl xr]) % границы по оси OX
xlabel('\itx') % метка оси x
ylabel('\itf\rm(\itx\rm)') % метка оси y



ndist=length(dlist); % количество распределений
for idist=1:ndist % подбираем параметры для всех распределений
    phatone=mle(x,'distribution',dlist{idist});
    phat{idist}=phatone; % запомнили
end

qq=[]; % критические уровни значимости
for idist=1:ndist % критерий Колмогорова
    phatone=phat{idist}; % значения параметров
    com=['cdf(''' dlist{idist} ''',x']; % команда
    for ipar=1:length(phatone) % добавляем параметры
            com=[com ',' sprintf('%d',phatone(ipar))];
    end
    com=[com ')']; % сформировали команду
    Fx=eval(com); % выполнили команду - вычислили F(x)
    [hkolm,pkolm,kskolm,cvkolm]=kstest(x,[x Fx],0.1,0);
    qq=[qq pkolm]; % критические уровни значимости
end

[maxqq,bdist]=max(qq); % выбрали лучшее распределение

fprintf('Критерий согласия Колмогорова:\n')
fprintf('Лучше всего подходит %s распределение;\n', dlistr{bdist})
fprintf('Критический уровень значимости для него = %8.5f\n', maxqq);


figure % создаем новую фигуру
cdfplot(x); % эмпирическая функция распределения
phatone=phat{bdist}; % параметры наилучшего распределения

com=['cdf(''' dlist{bdist} ''',xpl']; % команда
for ipar=1:length(phatone) % добавляем параметры
    com=[com ',' sprintf('%d',phatone(ipar))];
end
com=[com ')']; % сформировали команду

del=(xmax-xmin)/20; % добавки влево и вправо
xl=xmin-del;
xr=xmax+del; % границы интервала для построения графиков
xpl=linspace(xl,xr,1000); % абсциссы для графиков
Fxpl=eval(com); % вычислили F(x) для наилучшего распределения

hold on;
plot(xpl,Fxpl,'r'); % дорисовали F(x)
hold off;

set(get(gcf,'CurrentAxes'),'FontName','Times New Roman Cyr','FontSize',10)
title(['\bfПодобрано ' dlistr{bdist} ' распределение'])
xlabel('\itx') % метка оси x
ylabel('\itF\rm(\itx\rm)') % метка оси y

% КРИТЕРИЙ ПИРСОНА (НЕ РАБОТАЕТ)
% ab=[]; % статистики и критические значения
% 
% for idist=1:ndist % критерий Пирсона
% 
%     phatone=phat{idist}; % значения параметров
% 
%     %com=['chi2gof(x,' dlist{idist} '']; % команда
% 
%     com=['chi2test(x,n/10,0.1,''' dlist{idist} '''']; % команда
%     
%     for ipar=1:length(phatone) % добавляем параметры
% 
%         com=[com ',' sprintf('%d',phatone(ipar))];
%     end
% 
%     com=[com ', 0)']; % сформировали команду
% 
%     [c,d] = eval(com); % выполнили команду - провели тест Пирсона
% 
%     ab=[ab;[c d]]; % статистики и критические уровни значимости
% end
% 
% [maxdab,bdistp]=max(diff(ab')); % выбрали лучшее распределение
% 
% fprintf(['Критерий согласия Пирсона:\n' ...
% 
% 'Лучше всего подходит %s распределение;\n' ...
% 
% 'chi2-статистика для него = %8.5f;\n'...
% 
% 'а критическое значение = %8.5f.\n'], dlistr{bdistp},ab(bdistp,:));



