close all;


% ПД регулятор без возмущения
figure;
subplot(2, 1, 1);
plot(out.phi(:,1),out.phi(:,2), 'red');
title('Курс');
xlabel('Время, сек');
ylabel('\phi, градусы');

subplot(2, 1, 2);
plot(out.delta(:,1),out.delta(:,2), 'red');
title('Угол поворота руля');
xlabel('Время, сек');
ylabel('\delta, градусы');

% ПД регулятор с возмущением
figure;
subplot(2, 1, 1);
plot(out2.phi(:,1), out2.phi(:,2), 'red');   
title('Курс c учетом возмущения');
xlabel('Время, сек');
ylabel('\phi, градусы');
legend('ПД-регулятор');
       
subplot(2, 1, 2);
plot(out2.delta (:,1), out2.delta(:,2), 'red');
title('Угол поворота руля');
xlabel('Время, сек');
ylabel('\delta, градусы');
legend('ПД-регулятор');

% ПИД регулятор VS ПД (с возмущением)
figure;
subplot(2, 1, 1);
plot(out2.phi(:,1), out2.phi(:,2), 'magenta', out3.phi(:,1), out3.phi(:,2), 'red');   
title('Курс c учетом возмущения');
xlabel('Время, сек');
ylabel('\phi, градусы');
legend('ПД-регулятор', 'ПИД-регулятор',  'Location','southeast');
       
subplot(2, 1, 2);
plot(out2.delta (:,1), out2.delta(:,2),'magenta',  out3.delta (:,1), out3.delta(:,2), 'red');
title('Угол поворота руля');
xlabel('Время, сек');
ylabel('\delta, градусы');
legend('ПД-регулятор', 'ПИД-регулятор',  'Location','northeast');


P = tf ( 0.08, [18 1 0] );       
R = tf ( 1, [1 1] );
G = P*R;
H = tf ( 1, [5 1] );
Cpd = 0.8*(1 + tf ( [18 1], [1 1] )+tf ( [0 1], [200 0] ));
W = Cpd*G / (1 + Cpd*G*H);
[gm,phim] = margin(W);
gm = 20*log10(gm);






