f = imread('Fig1123(a)(Original_Padded_to_568_by_568).tif');
fp = padarray(f, [84 84], 'both');
fhs = f(1:2:end, 1:2:end);
fhsp = padarray(fhs, [184, 184], 'both');
fm = fliplr(f);
fmp = padarray(fm, [84 84], 'both');
fr2 = imrotate(f, 2, 'bilinear');
fr45 = imrotate(f, 45, 'bilinear');
phiorig = abs(log(invmoments(f)));
phihalf = abs(log(invmoments(fhs)));
phimirror = abs(log(invmoments(fm)));
phirot2 = abs(log(invmoments(fr2)));
phirot45 = abs(log(invmoments(fr45)));

subplot(2,3,1), imshow(f), title('Исходное изображение');
subplot(2,3,2), imshow(fhsp), title('Уменьшенное в 2 раза');
subplot(2,3,3), imshow(fmp), title('Отзеркаленное изображение');
subplot(2,3,4), imshow(fr2), title('Повернутое на 2 градуса');
subplot(2,3,5), imshow(fr45), title('Повернутое на 45 градуса');