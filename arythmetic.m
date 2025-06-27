Function y=int_arithm_encoder(x,q);

% x is input data sequence,

% q is cumulative distribution (model)

% y is binary output sequence

% Constants

K=16;

R4=2^(k-2); R2=R4*2; R34=R2+R4; % half,quarter,etc.

R=2*R2; % Precision

% Initialization

Low=0; % Low

High=R-1; % High

btf=0; % Bits to Follow

y=[ ]; % code sequence

% Encoding

for i=1:length(x);

Rage=High-Low+1;

High=Low+fix(Range*q(x(i)+1)/q(m))-1;

Low=Low+fix(Range*q(x(i)/q(m));

% Normalization

while 1

if High<R2

y=[y 0 ones(1,btf)]; btf=0;

High=High*2+1; Low=Low*2;

else

if Low>=R2

y=[y 1 zeros(1,btf)]; btf=0;

High=Higt*2-R+1; Low=Low*2-R;

else

if Low>=R4 & High<R34

High=2*High-R2+1; Low=2*Low-R2;

else

Break;

End;

End;

End;

end;% while

end; % for

% Completing

If Low<R4

y=[y 0 ones(1,btf+1)];

Else

y=[y 1 xeros(1,btf+1)];

End;

