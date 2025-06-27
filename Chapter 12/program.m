function image_correlaction
    A = imread("images/Hurricane Andrew.tif");
    mask = imread("images/hurricane_mask.tif");
    g = dftcorr(A, mask);
    gs = gscale(g);
    [I, J] = find(g == max(g(:)));
    
    figure, [ha, pos] = tight_subplot(2, 2, [0.02, 0.04]);
    axes(ha(1)), imshow(A), title('Исходное изображение');
    axes(ha(2)), imshow(mask), title('Маска');
    axes(ha(3)), imshow(gs), title('Корреляция между изображениями');
    axes(ha(4)), imshow(imdilate(gs > 254, strel('square', 4))), title('Положение максимума');

end

function bottles
    A1 = imread('bottle_1.tif');
    b1 = boundaries(A1, 4, 'cw');
    b1 = b1{1};
    [M1, N1] = size(A1);
    xmin = min(b1(:, 1));
    ymin = min(b1(:, 2));
    [x1, y1] = minperpoly(A1, 8);
    b1 = connectpoly(x1, y1);
    B1 = bound2im(b1, M1, N1, xmin, ymin);
    [x1, y1] = randvertex(x1, y1, 4);
    angles = polyangles(x1, y1);
    s1 = floor(angles/45) + 1;
    s1 = int2str(s1);
    R1 = strsimilarity(s1, s1);
    
    A2 = imread('bottle_2.tif');
    b2 = boundaries(A2, 4, 'cw');
    b2 = b2{1};
    xmin = min(b2(:, 1));
    ymin = min(b2(:, 2));
    [M2, N2] = size(A2);
    [x2, y2] = minperpoly(A2, 8);
    b2 = connectpoly(x2, y2);
    B2 = bound2im(b2, M2, N2, xmin, ymin);
    [x2, y2] = randvertex(x2, y2, 4);
    angles = polyangles(x2, y2);
    s2 = floor(angles/45) + 1;
    s2 = int2str(s2);
    R2 = strsimilarity(s2, s2);
    
    figure, [ha, pos] = tight_subplot(2, 2, [0.04, 0.04]);
    axes(ha(1)), imshow(A1), title('Объект 1');
    axes(ha(2)), imshow(B1), title('Ломаная минимальной длины');
    axes(ha(3)), imshow(A2), title('Объект 2');
    axes(ha(4)), imshow(B2), title('Ломаная минимальной длины');
    end