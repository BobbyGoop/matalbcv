clc;
clear;
close all;
%% ��������� �������, �������������
q = 8;
start = -20;
enD = 40;
SNR = start : enD;
chCapacity = zeros(1, abs(start) + abs(enD) + 1);


for i = SNR
    cnt = 1;
    Pyx = pyxAM(q, i);
%     if (mod(i, 5) == 0)
%         figure()
%         bar3(Pyx);
%         title(['���������� ����������� ', '��� SNR = ',num2str(i), '��']);
%         zlabel('P(k|i)');
%         ylabel('k-�� ������');
%         xlabel('i-�� ������');
%     end
    chCapacity(cnt) = channelCapacity(Pyx, q);
    cnt = cnt + 1;
end

figure()
plot(SNR, chCapacity, 'blue-', 'MarkerSize', 10);
title(['���������� ����������� ������']);
ylabel('C');
xlabel('SNR(��)');
grid on



%% �������� ����������� � ���������� ���������� �����������
function C = channelCapacity(Pyx, q)
qX = ones(1, q).*(1 / q); % ������������� ������������ �� X
C0 = -inf;
eps = 0.01; % ��������� �������� ��� ������ �� �����
for x = 1 : q
    Qxy = zeros(q, q);
    
    while true
        for x3 = 1 : q
            for y = 1 : q
                Qxy(x3, y) = (Pyx(y, x3) * qX(x3)) / (sumOfProbabilities(Pyx(y, :), qX, q)); 
            end
        end
        for x1 = 1 : q
            summ = 0;
            for x_ = 1 : q
                summ = summ + exp(sumToApproximate(Pyx(x_, :), Qxy(x_, :), q));
            end
            qX(x1) = exp(sumToApproximate(Pyx(x1, :), Qxy(x1, :), q)) / summ;
        end
        summa = 0;
        for k = 1 : q
            for i = 1 : q
                l = log(Qxy(i, k) / qX(i));
                if (l == -inf || l == inf)
                    l = 0;
                end
                if qX(i) > 0 && Qxy(i, k) > 0
                    summa = summa + (Pyx(k, i) * qX(i)* l);
                end
            end
        end
        C = abs(summa);
        if (norm(C0 - C) / C < eps)
            break;
        end
        C0 = C;
    end
end
C = C / log(2);
end
%% ��������������� �������
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

%% ���������� ���������� ������������ ��� ��
function Pyx = pyxAM(q, SNRdB)
    Pyx = zeros (q, q);
    gamma = 10.^(SNRdB/10);
    delta = 2 * sqrt(6 * gamma/(q * q - 1));
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