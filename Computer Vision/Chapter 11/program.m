function chain_codes
    A = imread("images/noisy_circular_stroke.tif"); %а
    h = fspecial('average', 9);
    g = imfilter(A, h, 'replicate'); %б
    g_bin = imbinarize(g, 0.5); %в
    B = boundaries(g_bin);
    d = cellfun('length', B);
    [max_d, keys] = max(d);
    b = B{1};
    [M, N] = size(g_bin);
    g_bound = bound2im(b, M, N, min(b(:, 1)), min(b(:, 2))); %г
    [s, su] = bsubsamp(b, 50);
    g2 = bound2im(s, M, N, min(s(:, 1)), min(s(:, 2))); %д
    cn = connectpoly(s(:, 1), s(:, 2));
    g2_bound = bound2im(cn, M, N, min(cn(:, 1)), min(cn(:, 2))); %е
    c = fchcode(su); %c.fcc 
    
    figure, [ha, pos] = tight_subplot(1, 2, [0.02, 0.02]);
    axes(ha(1)), imshow(A);
    axes(ha(2)), imshow(g);
    
    figure, [ha, pos] = tight_subplot(1, 2, [0.02, 0.02]);
    axes(ha(1)), imshow(g_bin);
    axes(ha(2)), imshow(g_bound);
    
    figure, [ha, pos] = tight_subplot(1, 2, [0.02, 0.02]);
    axes(ha(1)),imshow(g2);
    axes(ha(2)), imshow(g2_bound);
end

% chain_codes

function mpp_disp
    A = imread("images/mapleleaf.tif"); %a
    b = boundaries(A, 4, 'cw');
    b = b{1};
    [M, N] = size(A);
    xmin = min(b(:, 1));
    ymin = min(b(:, 2));
    bim = bound2im(b, M, N, xmin, ymin); %б
    
    [x2, y2] = minperpoly(A, 2);
    b2 = connectpoly(x2, y2);
    B2 = bound2im(b2, M, N, xmin, ymin); %в
    
    [x3, y3] = minperpoly(A, 3);
    b3 = connectpoly(x3, y3);
    B3 = bound2im(b3, M, N, xmin, ymin); %г
    
    [x4, y4] = minperpoly(A, 4);
    b4 = connectpoly(x4, y4);
    B4 = bound2im(b4, M, N, xmin, ymin); %д
    
    [x8, y8] = minperpoly(A, 8);
    b8 = connectpoly(x8, y8);
    B8 = bound2im(b8, M, N, xmin, ymin); %е
    
    figure, [ha, pos] = tight_subplot(1, 2, [0.02, 0.02]);
    axes(ha(1)), imshow(A);
    axes(ha(2)), imshow(bim);
    figure, [ha, pos] = tight_subplot(1, 2, [0.02, 0.02]);
    axes(ha(1)), imshow(B2);
    axes(ha(2)), imshow(B3);
    figure, [ha, pos] = tight_subplot(1, 2, [0.02, 0.02]);
    axes(ha(1)), imshow(B4);
    axes(ha(2)), imshow(B8);
end

% mpp_disp

function signatures
    A_sq = imread("images/boundary_sq.tif");
    A_tr = imread("images/boundary_triangle.tif");
    b_sq = boundaries(A_sq);
    b_tr = boundaries(A_tr);
    B_sq = b_sq{1};
    B_tr = b_tr{1};
    
    [st_sq, angle_sq, x0_sq, y0_sq] = signature(B_sq);
    [st_tr, angle_tr, x0_tr, y0_tr] = signature(B_tr);
    
    figure, [ha, pos] = tight_subplot(1, 2, [0.02, 0.02]);
    axes(ha(1)), imshow(A_sq);
    axes(ha(2)), imshow(A_tr);
    figure, plot(st_sq), grid on, grid minor;
    figure, plot(st_tr), grid on, grid minor;

end

% signatures

function create_skeleton
    A = imread("images/chromo_original.tif"); %a
    A_d = im2double(A);
    h = fspecial('gaussian', 25, 15); 
    g = imfilter(A_d, h, 'replicate'); %b
    g_bin = imbinarize(g, 1.5*graythresh(g)); %c
    s = bwmorph(g_bin, 'skel', Inf); %d
    s8 = bwmorph(s, 'spur', 8); %e
    s8_8 = s8;
    for i = 1:7
        s8_8 = bwmorph(s8_8, 'spur', 1);
    end
    figure, [ha, pos] = tight_subplot(1, 3, [0.02, 0.02]);
    axes(ha(1)), imshow(A);
    axes(ha(2)), imshow(g);
    axes(ha(3)), imshow(g_bin);

    figure, [ha, pos] = tight_subplot(1, 3, [0.02, 0.02]);
    axes(ha(1)), imshow(s);
    axes(ha(2)), imshow(s8);
    axes(ha(3)),imshow(s8_8);
end

% create_skeleton

function fourier_deskriptor
    A = imread("images/chromo_binary.tif");
    b = boundaries(A);
    b = b{1};
    [M, N] = size(A);
    bim = bound2im(b, M, N);
    z = frdescp(b);
    z546   = ifrdescp(z, 546);
    z546im = bound2im(z546, M, N);
    z110   = ifrdescp(z, 110);
    z110im = bound2im(z110, M, N);
    z56   = ifrdescp(z, 56);
    z56im = bound2im(z56, M, N);
    z28   = ifrdescp(z, 28);
    z28im = bound2im(z28, M, N);
    z14   = ifrdescp(z, 14);
    z14im = bound2im(z14, M, N);
    z8   = ifrdescp(z, 8);
    z8im = bound2im(z8, M, N);
    
    figure(1);
    subplot(1,2,1), imshow(A), title('Исходное изображение');
    subplot(1,2,2), imshow(bim), title('Граница');
    
    text_position = [10, 10]; 
    figure, [ha, pos] = tight_subplot(2, 3, [0.02, 0.02]);
    axes(ha(1)), imshow(z546im), text(15, 15, sprintf('546'), 'Color',[1 1 1],'FontSize',10);
    axes(ha(2)), imshow(z110im), text(15, 15, sprintf('110'), 'Color',[1 1 1],'FontSize',10);
    axes(ha(3)), imshow(z56im), text(15, 15, sprintf('56'), 'Color',[1 1 1],'FontSize',10);
    axes(ha(4)), imshow(z28im), text(15, 15, sprintf('28'), 'Color',[1 1 1],'FontSize',10);
    axes(ha(5)), imshow(z14im), text(15, 15, sprintf('14'), 'Color',[1 1 1],'FontSize',10);
    axes(ha(6)), imshow(z8im), text(15, 15, sprintf('8'), 'Color',[1 1 1],'FontSize',10);
end

% fourier_deskriptor

function region_props_test
    A = imread("boundary_triangle.tif");
    B = logical(A);
    D = regionprops(B, 'area', 'BoundingBox');
    w = [D.Area];
    NR = length(w);
    V = cat(1, D.BoundingBox);
    figure(1);
    imshow(A);
    hold on;
        for i = 1:NR
        rectangle('Position', V(i,:), 'EdgeColor', 'g', 'LineWidth', 2, 'LineStyle','--');
        end
    hold off;
end

% region_props_test

function textures
    A_s = imread("images/superconductor-with-window.tif");
    A_c = imread("images/cholesterol-with-window.tif");
    A_m = imread("images/microporcessor-with-window.tif");
    
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
    
    figure;
    subplot(2,2,1), imshow(A_s);
    subplot(2,2,2), imshow(region_of_interest_s);
    subplot(2,2,3:4), imhist(region_of_interest_s);
    
    figure;
    subplot(2,2,1), imshow(A_c);
    subplot(2,2,2), imshow(region_of_interest_c);
    subplot(2,2,3:4), imhist(region_of_interest_c);
    
    figure;
    subplot(2,2,1), imshow(A_m);
    subplot(2,2,2), imshow(region_of_interest_m);
    subplot(2,2,3:4), imhist(region_of_interest_m);
    
    texture = ["гладкая"; "шероховатая"; "периодическая"];
    tTable = table(texture, [t_s(1); t_c(1); t_m(1)], [t_s(2); t_c(2); t_m(2)], ...
        [t_s(3); t_c(3); t_m(3)], [t_s(4); t_c(4); t_m(4)], [t_s(5); t_c(5); t_m(5)],[t_s(6); t_c(6); ...
        t_m(6)], ...
        'VariableNames', {'Текстура', 'Средняя яркость', 'Средняя контрастность', ...
        'R', 'Третий момент', 'Однородность', 'Энтропия'});
    disp(tTable);
    
    
    A_r = imread("images/random_matches.tif");
    A_o = imread("images/ordered_matches.tif");
    
    [srad_r, sang_r, S_r] = specxture(A_r);
    [srad_o, sang_o, S_o] = specxture(A_o);
    
    figure;
    subplot(3,2,1), imshow(A_r);
    subplot(3,2,2), imshow(S_r);
    subplot(3,2,3:4), plot(srad_r), xlabel('r'), ylabel('S(r)'), grid on, grid minor;
    subplot(3,2,5:6), plot(sang_r), xlabel('O'), ylabel('S(O)'), grid on, grid minor;
    
    figure;
    subplot(3,2,1), imshow(A_o);
    subplot(3,2,2), imshow(S_o);
    subplot(3,2,3:4), plot(srad_o), xlabel('r'), ylabel('S(r)'), grid on, grid minor;
    subplot(3,2,5:6), plot(sang_o), xlabel('O'), ylabel('S(O)'), grid on, grid minor;
end

function invariant_moments
    f = imread('images/Original_Padded_to_568_by_568.tif');
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
    
    figure, imshow(f);
    figure, [ha, pos] = tight_subplot(2, 2, [0.02, 0.02]);
    axes(ha(1)), imshow(fhsp);
    axes(ha(2)), imshow(fmp);
    axes(ha(3)), imshow(fr2);
    axes(ha(4)), imshow(fr45);
end

% invariant_moments

function main_basis

    A1 = imread("images/WashingtonDC_Band1_512.tif");
    A2 = imread("images/WashingtonDC_Band2_512.tif");
    A3 = imread("images/WashingtonDC_Band3_512.tif");
    A4 = imread("images/WashingtonDC_Band4_512.tif");
    A5 = imread("images/WashingtonDC_Band5_512.tif");
    A6 = imread("images/WashingtonDC_Band6_512.tif");
    
    figure, [ha, pos] = tight_subplot(2, 3, [0.02, 0.02]);
    axes(ha(1)), imshow(A1), title('Видимый синий свет');
    axes(ha(2)), imshow(A2), title('Видимый зеленый свет');
    axes(ha(3)), imshow(A3), title('Видимый красный свет');
    axes(ha(4)), imshow(A4), title({'Близкое инфракрасное', 'излучение'});
    axes(ha(5)),imshow(A5), title({'Среднее инфракрасное', 'излучение'});
    axes(ha(6)),imshow(A6), title({'Тепловое инфракрасное', 'излучение'});
    
   
    S = cat(3, A1, A2, A3, A4, A5, A6);
    [X, R] = imstack2vectors(S);
    P = princomp(X, 6);
    g1 = P.Y(:, 1);
    g1 = reshape(g1, 512, 512);
    g2 = P.Y(:, 2);
    g2 = reshape(g2, 512, 512);
    g3 = P.Y(:, 3);
    g3 = reshape(g3, 512, 512);
    g4 = P.Y(:, 4);
    g4 = reshape(g4, 512, 512);
    g5 = P.Y(:, 5);
    g5 = reshape(g5, 512, 512);
    g6 = P.Y(:, 6);
    g6 = reshape(g6, 512, 512);

    figure, [ha, pos] = tight_subplot(2, 3, [0.02, 0.02]);
    axes(ha(1)), imshow(g1, []), title({'Главная компонента видимого', 'синего света'});
    axes(ha(2)), imshow(g2, []), title({'Главная компонента видимого', 'зеленого света'});
    axes(ha(3)), imshow(g3, []), title({'Главная компонента красного', 'синего света'});
    axes(ha(4)), imshow(g4, []), title({'Главная компонента близкого', 'инфракрасного излучения'});
    axes(ha(5)), imshow(g5, []), title({'Главная компонента среднего', 'инфракрасного излучения'});
    axes(ha(6)), imshow(g6, []), title({'Главная компонента теплового', 'инфракрасного излучения'});
    
    d = diag(P.Cy);
    P = princomp(X, 2);
    h1 = P.X(:, 1);
    h1 = reshape(h1, 512, 512);
    h2 = P.X(:, 2);
    h2 = reshape(h2, 512, 512);
    h3 = P.X(:, 3);
    h3 = reshape(h3, 512, 512);
    h4 = P.X(:, 4);
    h4 = reshape(h4, 512, 512);
    h5 = P.X(:, 5);
    h5 = reshape(h5, 512, 512);
    h6 = P.X(:, 6);
    h6 = reshape(h6, 512, 512);
    
    figure, [ha, pos] = tight_subplot(2, 3, [0.02, 0.02]);
    axes(ha(1)), imshow(h1, []);
    axes(ha(2)), imshow(h2, []);
    axes(ha(3)), imshow(h3, []);
    axes(ha(4)), imshow(h4, []);
    axes(ha(5)), imshow(h5, []);
    axes(ha(6)), imshow(h6, []);
    
    D1 = double(A1) - double(h1);
    D1 = gscale(D1);
    D2 = double(A2) - double(h2);
    D2 = gscale(D2);
    D3 = double(A3) - double(h3);
    D3 = gscale(D3);
    D4 = double(A4) - double(h4);
    D4 = gscale(D4);
    D5 = double(A5) - double(h5);
    D5 = gscale(D5);
    D6 = double(A6) - double(h6);
    D6 = gscale(D6);
    
    figure, [ha, pos] = tight_subplot(2, 3, [0.02, 0.02]);
    axes(ha(1)), imshow(D1, []);
    axes(ha(2)), imshow(D2, []);
    axes(ha(3)), imshow(D3, []);
    axes(ha(4)), imshow(D4, []);
    axes(ha(5)), imshow(D5, []);
    axes(ha(6)), imshow(D6, []);
end
main_basis