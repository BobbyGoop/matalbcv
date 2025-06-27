clc; 
clear;
close all;

q = 8;
SNR = [0, 10, 20, 30];

for i = SNR
    Pyx = getProbs(q, i);
    figure()
    h = bar3(Pyx);
    shading interp
    for k = 1:length(h)
         zdata = get(h(k),'Zdata');
         set(h(k),'Cdata',zdata)
         set(h,'EdgeColor','k')
    end
    title(['Переходные вероятности при SNR = ', num2str(i), 'дБ']);
    zlabel('P(k|i)');
    ylabel('k-й сигнал');
    xlabel('i-й сигнал');
end

function res = getProbs(q, SNRdB)
    Pyx = zeros (q, q);
    gamma = 10.^(SNRdB/10);

    delta = 2 * sqrt(2 * gamma)/(q - 1);

    for i = 0 : q-1
        for k = 0 : q-1
            if ((k == 0) || (k == q - 1))
                Pyx(k + 1, i + 1) = qfunc((abs(i - k) - 1 / 2) * delta);
            else
                Pyx(k + 1, i + 1) = qfunc((abs(i - k) - 1 / 2) * delta) - qfunc((abs(i - k) + 1 / 2) * delta);
            end
        end
    end
    res = Pyx;
end