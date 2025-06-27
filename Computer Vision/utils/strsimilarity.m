function R = strsimilarity(a, b)
if ~ischar(a) | ~ischar(b)
   error('Inputs must be character strings.')
end
I = find(a == ' ');
J = find(b == ' ');
LI = length(I); LJ = length(J);
if LI ~= 0 & LJ ~= 0
   error('Only one of the strings can contain blanks.')
end
a = a(:); b = b(:);
La = length(a); Lb = length(b);
if LI == 0 & LJ == 0
   if La > Lb
      b = [b; blanks(La - Lb)'];
   else 
      a = [a; blanks(Lb - La)'];
   end
elseif isempty(I)
   Lb = length(b) - length(J);
   b = [b; blanks(La - Lb - LJ)'];
else
   La = length(a) - length(I);
   a = [a; blanks(Lb - La - LI)'];
end
I = find(a == b);
alpha = length(I);
den = max(La, Lb) - alpha;
if den == 0 
   R = Inf;
else 
   R = alpha/den; 
end
