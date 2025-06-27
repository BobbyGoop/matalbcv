% �������� ������������� ����������
syms x k 

% ������� ���������
x1=0; x2=2;

% ��������� �������������
f=k*(x+3)*(x+3); 
fprintf('f(x) = %s\n',char(f))

I1=int(f,x,x1,x2); % ������� ��������
ks=solve(I1-1,k); % ������ ��������� I1 - 1 = 0
fprintf('��������� k = %s\n',char(ks))

% ��������� �������������
fs=subs(f,k,ks); % ���������� �������
fprintf('\n��������� �������������:\n')
fprintf('f(x) = %s; %d <= x <= %d',char(fs),x1,x2)
fprintf('\nf(x) = 0 ��� ����� �������.\n')

% ������� �������������
F=int(fs,x,x1,x); 
fprintf('\n������� �������������:\n')
fprintf(['F(x) = 0 ��� x < %d;\nF(x) = %s ��� %d <=x <= %d\n' ...
    'F(x) = 1 ��� x > %d.\n'],x1,char(F),x1,x2,x2)

tiledlayout(1, 2);
set(gcf,'Position',[100 100 1720 880])
% ��������� ��������� �������������

xp1=x1-0.25*(x2-x1); % ������� �������
xp2=x2+0.25*(x2-x1);
xp=linspace(xp1,xp2,1000); % �������� ��� �������
fp=subs(fs,x,xp).*(xp>=x1).*(xp<=x2); % ��������

nexttile;
plot(xp,fp) % ������ ������
%ax1.set(get(gcf,'CurrentAxes'),'FontName','Times New Roman Cyr','FontSize',10) 
title('\bf��������� �������������') % ���������
xlabel('\itx') % ����� ��� OX
ylabel('\itf\rm(\itx\rm)') % ����� ��� OY


% ��������� ������� �������������
Fp=subs(F,x,xp).*(xp>=x1).*(xp<=x2)+ones(size(xp)).*(xp>x2); % ��������

nexttile
plot(xp,Fp) % ������ ������
ylim([0 1.2]); % ������� �� ���������
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman Cyr','FontSize',10)
title('\bf������� �������������') % ���������
xlabel('\itx') % ����� ��� OX
ylabel('\itF\rm(\itx\rm)') % ����� ��� OY
ylabel('\itf\rm(\itx\rm)') % ����� ��� OY

% ��������
mx=int(x*fs,x,x1,x2); % ��������� ��
fprintf('\nMx = %s = %8.5f.\n', char(mx), eval(mx))

[fmax,ifmax]=max(fp); % ������������ f(x)
modx=xp(ifmax); % ���� �������������
fprintf('���� = %5.2f.\n',modx);

medx=solve(F-0.5); % ���� ������� F = 1\2 (F - 0.5 = 0)
disp("��������� �������� �������: ")
disp(double(medx))


fprintf('\n��������� �������:\n');
for i=1:4
 alpha=int(x^i*fs,x,x1,x2); % ������ i-�� �������
 fprintf('Alpha(%d) = %s = %12.5f\n', i, char(alpha), eval(alpha));
end

fprintf('\n����������� �������:\n');
for i=1:4
 mu=int((x-mx)^i*fs,x,x1,x2); % ������ i-�� �������
 fprintf('Mu(%d) = %s = %.5f\n',i,char(mu),eval(mu));
end

Dx=simplify(int((x-mx)^2*fs,x,x1,x2)); % ���������
Sx=simplify(Dx^0.5); % ���
Ax=simplify(int((x-mx)^3*fs,x,x1,x2)/Sx^3); % ����������
Ex=simplify(int((x-mx)^4*fs,x,x1,x2)/Dx^2-3); % �������

fprintf('\n���������, ���, ����������, �������\n')
fprintf('Dx= %s = %8.5f;\n',char(Dx),eval(Dx));
fprintf('Sx = %s = %8.5f;\n',char(Sx),eval(Sx));
fprintf('Ax= %s = %8.5f;\n',char(Ax),eval(Ax));
fprintf('Ex = %s= %8.5f.\n',char(Ex),eval(Ex));