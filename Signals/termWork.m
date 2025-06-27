clc; 
clear;
close all;

%% Начальные условия, инициализация  
q = 8;
start = -30;
enD = 30;
SNR = start : 0.01 : enD;
% SNR = [30];
% Pyx = pyxAM(q, SNR);

% figure(1)
% for i = 1:8
%     plot(i, Pyx(1, i), 'b')
% end
disp(length(SNR))

chCapacity = zeros(1, length(SNR));
cnt = 1;
for i = SNR
    Pyx = pyxAM(q, i);
%     figure()
%     h = bar3(Pyx);
%     shading interp
%     for k = 1:length(h)
%          zdata = get(h(k),'Zdata');
%          set(h(k),'Cdata',zdata)
%          set(h,'EdgeColor','k')
%     end
%     title(['���������� ����������� ��� SNR = ', num2str(i), '��']);
%     zlabel('P(k|i)');
%     ylabel('k-� ������');
%     xlabel('i-� ������');
    chCapacity(cnt) = channelCapacity(Pyx, q);
    cnt = cnt + 1;
end

figure()
plot(SNR, chCapacity, 'blue-', 'MarkerSize', 10);
title(['Пропускная способность канала']);
ylabel('C');
xlabel('SNR(дБ)');
grid on

%% Алгоритм оптимизации и вычисления пропускной способности
function C = channelCapacity(Pyx, q)
    eps = 1; % Пороговое значение для выхода из цикла
    iterations = 0;
%     ������ ������������� - �����������
    qX = ones(1, q).*(1 / q);
    C0 = -inf;
    while true
        Qxy = zeros(q, q);
%         ��������� ������� Q
        for i = 1 : q
            for j = 1 : q
                Qxy(i, j) = (Pyx(j, i) * qX(i)) / (sumOfProbabilities(Pyx(j, :), qX, q));
            end
        end
        
%         ��������� n+1 �������������
        for i = 1 : q
            summ = 0;
            for j = 1 : q
                summ = summ + exp(sumToApproximate(Pyx(j, :), Qxy(j, :), q));
            end
            qX(i) = exp(sumToApproximate(Pyx(i, :), Qxy(i, :), q)) / summ;
        end

        left_sum = 0;
        for i = 1 : q
            l = log(qX(i));
            if (l == -inf || l == inf)
                l = 0;
            end
             left_sum =  left_sum + (-1) * qX(i)*l;
        end
        
        right_sum = 0;
        for k = 1 : q
            for i = 1 : q
                l = log(Qxy(i, k));
                if (l == -inf || l == inf)
                    l = 0;
                end
                if qX(i) > 0 && Qxy(i, k) > 0
                    right_sum = right_sum + (Pyx(k, i) * qX(i) * l);
                end
            end
        end
        C = abs(left_sum + right_sum);
        if (abs(C0 - C) / C < eps)
            disp(iterations)
            break;
        end
        C0 = C;
        iterations = iterations + 1;
    end
    C = C / log(2);
end


%% Графики, значение пропускной способности

%% Вспомогательные функции 

function sum = sumOfProbabilities(Py, qX, n)
    sum = 0;
    for x = 1 : n 
        sum = sum + (Py(x) * qX(x));
    end
end

function sum = sumToApproximate(Px, Qx, n) 
    sum = 0;
    for y = 1 : n 
        l = log(Qx(y));
        if (l == -inf)
            l = 0;
        end
        sum = sum + (Px(y) * l);
    end
end

%% Вычисление переходных вероятностей для АМ
function Pyx = pyxAM(q, SNRdB)
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
end

% function q_value = Q(x)
%     q_value = 0.5 * erfc(x / sqrt(2));
% end