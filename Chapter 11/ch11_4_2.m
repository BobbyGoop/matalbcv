close all;
clear;
clc;

figure(1);
A_s = imread("Fig1119(a)(superconductor-with-window).tif");
A_c = imread("Fig1119(b)(cholesterol-with-window).tif");
A_m = imread("Fig1119(c)(microporcessor-with-window).tif");

white_rectangle_s = A_s == 255;
white_rectangle_c = A_c == 255;
white_rectangle_m = A_m == 255;

stats_s = regionprops(white_rectangle_s, 'BoundingBox');
stats_c = regionprops(white_rectangle_c, 'BoundingBox');
stats_m = regionprops(white_rectangle_m, 'BoundingBox');

rectangle_coords_s = round(stats_s(1).BoundingBox);
rectangle_coords_c = round(stats_c(1).BoundingBox);
rectangle_coords_m = round(stats_m(1).BoundingBox);

border_size = 10;
region_of_interest_s = A_s(rectangle_coords_s(2)+border_size:rectangle_coords_s(2)+ ...
    rectangle_coords_s(4)-border_size-1,rectangle_coords_s(1)+ ...
    border_size:rectangle_coords_s(1)+rectangle_coords_s(3)-border_size-1);
region_of_interest_c = A_c(rectangle_coords_c(2)+border_size:rectangle_coords_c(2)+ ...
    rectangle_coords_c(4)-border_size-1,rectangle_coords_c(1)+ ...
    border_size:rectangle_coords_c(1)+rectangle_coords_c(3)-border_size-1);
region_of_interest_m = A_m(rectangle_coords_m(2)+border_size:rectangle_coords_m(2)+ ...
    rectangle_coords_m(4)-border_size-1,rectangle_coords_m(1)+ ...
    border_size:rectangle_coords_m(1)+rectangle_coords_m(3)-border_size-1);

t_s = statxture(region_of_interest_s);
t_c = statxture(region_of_interest_c);
t_m = statxture(region_of_interest_m);

texture = ["гладкая"; "шероховатая"; "периодическая"];
tTable = table(texture, [t_s(1); t_c(1); t_m(1)], [t_s(2); t_c(2); t_m(2)], ...
    [t_s(3); t_c(3); t_m(3)], [t_s(4); t_c(4); t_m(4)], [t_s(5); t_c(5); t_m(5)],[t_s(6); t_c(6); ...
    t_m(6)], ...
    'VariableNames', {'Текстура', 'Средняя яркость', 'Средняя контрастность', ...
    'R', 'Третий момент', 'Однородность', 'Энтропия'});
disp(tTable);

subplot(3,3,1), imshow(A_s), title('Сверхпроводник');
subplot(3,3,2), imshow(A_c), title('Холестерин');
subplot(3,3,3), imshow(A_m), title('Микропроцессор');

subplot(3,3,4), imshow(region_of_interest_s), title('Область сверхпроводника');
subplot(3,3,5), imshow(region_of_interest_c), title('Область холестерина');
subplot(3,3,6), imshow(region_of_interest_m), title('Область микропроцессора');

subplot(3,3,7), imhist(region_of_interest_s), title('Область сверхпроводника');
subplot(3,3,8), imhist(region_of_interest_c), title('Область холестерина');
subplot(3,3,9), imhist(region_of_interest_m), title('Область микропроцессора');

figure(2);
A_r = imread("Fig1121(a)(random_matches).tif");
A_o = imread("Fig1121(b)(ordered_matches).tif");

[srad_r, sang_r, S_r] = specxture(A_r);
[srad_o, sang_o, S_o] = specxture(A_o);

subplot(4,2,1), imshow(A_r), title('Разбросанные спички');
subplot(4,2,2), imshow(A_o), title('Упорядоченные спички');
subplot(4,2,3), imshow(S_r), title('Спектр разбросанных спичек');
subplot(4,2,4), imshow(S_o), title('Спектр упорядоченных спичек');
subplot(4,2,5), plot(srad_r), title('S(r)');
subplot(4,2,6), plot(srad_o), title('S(r)');
subplot(4,2,7), plot(sang_r), title('S(O)');
subplot(4,2,8), plot(sang_o), title('S(O)');

