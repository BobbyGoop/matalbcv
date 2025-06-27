% ----------------------------------------------
% Statistics and Machine Learning Toolbox NEEDED
% ----------------------------------------------

clearvars; % очистили память

sf='data.txt'; % имя файла

x=load(sf); % вводим ИД

x=x(:); % переформатировали в вектор-столбец

un = unique(x);
n=length(x); % количество данных
xmin=min(x); % минимальное значение
xmax=max(x); % максимальное значение
fprintf('Обрабатываем файл %s\n',sf)
fprintf('Объем выборки n = %d\n',n)
fprintf('xmin = %f\n',xmin)
fprintf('xmax = %f\n',xmax)

Mx=mean(x); % математическое ожидание
fprintf('Выборочное МО Mx = %f\n',Mx)

f=n-1; % число степеней свободы
Dx=var(x); % дисперсия
Sx=std(x); % среднеквадратичное отклонение
fprintf('Число степеней свободы выборки f = %d\n',f)
fprintf('Дисперсия Dx = %f\n',Dx)
fprintf('СКО Sx = %f\n',Sx)

Ax=skewness(x,0); % несмещённая асимметрия
Ex=kurtosis(x,0)-3; % несмещённый эксцесс
Medx=median(x); % медиана
Rx=range(x); % размах выборки
fprintf('Асимметрия Ax = %f\n',Ax)
fprintf('Эксцесс Ex = %f\n',Ex)
fprintf('Медиана Medx = %f\n',Medx)
fprintf('Размах Rx = %.f',Rx)

p=[0.9;0.95;0.99;0.999]; % задаём доверит. вероятности
q=1-p; % уровни значимости
Mxd=[];
for k=1:length(q)
    [hh,pp,ci]=ttest(x,Mx,q(k)); % формула (10.8)
    Mxd=[Mxd [q(k);ci]];
end

disp(newline)
disp('Доверительные интервалы для генерального МО')
fprintf('p = %f : mx ∈ [ %f, %f ]\n',Mxd)

disp(newline)
chi2l=chi2inv(1-q/2,f);
chi2r=chi2inv(q/2,f); % квантили chi2-распр. Пирсона
Dxd=[p,f*Dx./chi2l,f*Dx./chi2r]'; % формула (10.14)
disp('Доверительные интервалы для генеральной дисперсии')
fprintf('p = %f: DX ∈ [ %f , %f ]\n',Dxd)

disp(newline)
Da=6*(n-1)/(n+1)/(n+3); % дисперсия Ax
De=24*n*(n-2)*(n-3)/(n+1)^2/(n+3)/(n+5); % дисперсия Ex
fprintf('Da = %f\nDe = %f\n',Da,De)

disp(newline)
Axd=[p,Ax-(Da./q).^0.5,Ax+(Da./q).^0.5]'; % (10.19)
disp('Доверительные интервалы для генеральной асимметрии')
fprintf('p = %f: ax ∈ [ %f, %f ]\n',Axd)

disp(newline)
Exd=[p,Ex-(De./q).^0.5,Ex+(De./q).^0.5]'; % (10.20)
disp('Доверительные интервалы для генерального эксцесса')
fprintf('p = %f: ex ∈ [ %f, %f ]\n',Exd)