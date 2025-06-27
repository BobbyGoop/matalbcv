clearvars; % очистить память

m = zeros(1, 16);
for i=1:16
    sf=sprintf('data/data (%d).txt', i) ; % имя файла данных
    x=load(sf); % вводим ИД

    x=sort(x(:)); % переформатировали столбец и рассортировали
    m(i) = min(x);
end
m = m(:);
