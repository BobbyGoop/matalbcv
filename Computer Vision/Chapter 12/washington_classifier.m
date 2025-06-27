figure, [ha, pos] = tight_subplot(2, 2, [0.08, 0.02]);
f1 = imread("images/WashingtonDC_Band1_512.tif");
axes(ha(1)), imshow(f1), title('Изображение синей компоненты');
f2 = imread("images/WashingtonDC_Band2_512.tif");
axes(ha(2)), imshow(f2), title('Изображение зеленой компоненты');
f3 = imread("images/WashingtonDC_Band3_512.tif");
axes(ha(3)), imshow(f3), title('Изображение красной компоненты');
f4 = imread("images/WashingtonDC_Band4_512.tif");
axes(ha(4)), imshow(f4), title('Изображение ИК компоненты');

figure;
B1 = roipoly(f1);
B2 = roipoly(f2);
B3 = roipoly(f3);

stack = cat(3, f1, f2, f3, f4);
[X1, R1] = imstack2vectors(stack, B1);
[X2, R2] = imstack2vectors(stack, B2);
[X3, R3] = imstack2vectors(stack, B3);

T1 = X1(1:2:end,:);
T2 = X2(1:2:end,:);
T3 = X3(1:2:end,:); 

[C1, m1] = covmatrix(T1);
[C2, m2] = covmatrix(T2);
[C3, m3] = covmatrix(T3);

CA = cat(3, C1, C2, C3);
MA = cat(2, m1, m2, m3);

dT1 = bayesgauss(T1, CA, MA);
dT2 = bayesgauss(T2, CA, MA);
dT3 = bayesgauss(T3, CA, MA);

% Number of t raining patterns class_k_to_class 1 , k = 1, 2, 3.
class1_to_1 = numel(find(dT1==1));
class1_to_2 = numel(find(dT1==2));
class1_to_3 = numel(find(dT1==3));
% Number of t raining patterns class_k_to_class2 , k
class2_to_1 = numel(find (dT2==1));
class2_to_2 = numel(find (dT2==2));
class2_to_3 = numel(find (dT2==3));
% Number of training patterns class_k_to_class3 , k
class3_to_1 = numel(find(dT3==1));
class3_to_2 = numel(find(dT3==2));
class3_to_3 = numel(find(dT3==3)); 

I1 = X1(2:2:end,:); 
I2 = X2(2:2:end,:); 
I3 = X3(2:2:end,:); 

% B1 region
image1 = false(size(f1));
d1 = bayesgauss(X1,CA,MA);
idx1 = find(d1 == 1);
image1(R1(idx1)) = 1;

% B2 region
image2 = false(size(f2));
d2 = bayesgauss(X2,CA,MA);
idx2 = find(d2 == 2);
image2(R2(idx2)) = 1;

% B3 region
image3 = false(size(f3));
d3 = bayesgauss(X3,CA,MA);
idx3 = find(d3 == 3);
image3(R3(idx3)) = 1;

figure, [ha, pos] = tight_subplot(1, 2, [0.02, 0.04]);
composite_image = image1 | image2 | image3 ; % Fig . 13. 2(f)
axes(ha(1)), imshow(B1 | B2 | B3), title('Итоговая маска');
axes(ha(2)), imshow(composite_image), title('Итоговый отклик');

figure, [ha, pos] = tight_subplot(1, 3, [0.02, 0.04]);
B = ones (size(f1)); % This B selects all patterns
X = imstack2vectors (stack, B);
dAll = bayesgauss(X, CA, MA) ; % Classify all patterns
image_class1 = reshape(dAll == 1, 512, 512);
image_class2 = reshape(dAll == 2, 512, 512);
image_class3 = reshape(dAll == 3, 512, 512);
axes(ha(1)), imshow(image_class1 ) % Fig 13.2(g) 
axes(ha(2)), imshow(image_class2) % Fig 13.2(h) 
axes(ha(3)), imshow(image_class3) % Fig 13.2(i ) 