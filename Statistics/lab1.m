% ������ ���� ������
% �������� ������ � ���� ��������

% x=[-2 -1 0 1 2 3 4];
% p=[0.1 0.12 0.15 0.22 0.19 0.12 0.1];

% x = [-2 -1 0 1 2 3 4];
% p = [0.1 0.12 0.2 0.25 0.18 0.1 0.05];

% x0 = 0
x = [-1 0 1 2 3 4 5];
p = [0.08 0.1 0.17 0.24 0.18 0.12 0.11];

tiledlayout(1, 2);
set(gcf,'Position',[100 100 1720 880])

% �������������� �������������
p=p/sum(p);
nexttile;
plot(x,p,'k-',x,p,'k.')
ylim([0 0.25])
title('\bf������������� �������������')
xlabel('\itx') 
ylabel('\itP\rm(\itx\rm)')
%xlim([-2.5 4.5])

% ������� �������������
F=cumsum(p); % �������� ������� �������������
x1=[x(1)-0.5 x x(end)+0.5]; % ������� ����� � ������
F1=[0 F 1];
%figure; % ����� ������
nexttile;
stairs(x1,F1,'k-'); % �������
xl=xlim; % ������� �������
yl=ylim;
hold on
plot(x,F1(1:end-2),'k.') % �������� �����
hh=get(gca);
hp=hh.Position; % ��������� ���� �� ������
for i=1:length(F)
xi=x1(2+i:-1:1+i); % ���������� �������
Fi=[F(i) F(i)];
xi=(xi-xl(1))/(xl(2)-xl(1))*hp(3)+hp(1); % �����������
Fi=(Fi-yl(1))/(yl(2)-yl(1))*hp(4)+hp(2); % �������
annotation('arrow',xi,Fi); % ��������� �������
end
hold off
set(get(gcf,'CurrentAxes'),...
'FontName','Times New Roman Cyr','FontSize',10) % �����
title('\bf������� �������������') % ���������
xlabel('\itx') % ����� ��� OX
ylabel('\itF\rm(\itx\rm)') % ����� ��� OY

% ��
mx=sum(x.*p);
fprintf('�������������� �������� Mx=%8.5f.\n',mx);

% ����
[pmax,ipmax]=max(p); % pmax � ����� �����
modx=x(ipmax); % ���� �������������
fprintf('���� =%5.2f.\n',modx);

% ��������� �������
disp('��������� �������:');
for i=1:7
alpha=sum(x.^i.*p); % ������ i-�� �������
fprintf('Alpha(%d)=%12.5f\n',i,alpha);
end

% ����������� �������
disp('����������� �������:');
for i=1:5
mu=sum((x-mx).^i.*p); % ������ i-�� �������
fprintf('Mu(%d)=%12.5f\n',i,mu);
end

% ����������� ���������
Dx=sum((x-mx).^2.*p);
Dx2 = var(x);
fprintf('��������� Dx = %5.5f;\n',Dx);

%����������� ������������������ ����������
Sx=Dx^0.5;
fprintf('������������������ ���������� Sx = %5.5f;\n',Sx);

% ����������� ����������
Ax=sum((x-mx).^3.*p)/Sx^3;
fprintf('���������� Ax = %5.5f;\n',Ax);

% ����������� �������
Ex=sum((x-mx).^4.*p)/Dx^2-3;
fprintf('������� Ex = %5.5f.\n',Ex)