function detect_point()
    tiledlayout(1,2,'TileSpacing','tight', 'Padding','none');
    image_data = imread('images/test_pattern_with_single_pixel.tif');
    nexttile, imshow(image_data), title('Исходное изображение');
    w = [-1 -1 -1; -1 8 -1; -1 -1 -1]; 
    g = abs(imfilter(double(image_data), w)); 
    T = max(g(:)); 
    g = g >= T; 
    se = strel('disk', 3);  
    g = imdilate(g, se); 
    nexttile, imshow(g), title('Результат работы фильтра');
end

function detect_line()
    function display_lines(mask, plot_name)
        g = abs(imfilter(double(f), mask));
        T = max(g(:)); 
        g = g >= T;
        nexttile, imshow(imdilate(g, strel('disk', 3))), title(plot_name); 
    end
    
    tiledlayout(2,2,'TileSpacing','tight', 'Padding','none');
    f = imread('images/wirebond_mask.tif');   
    nexttile, imshow(f), title("Исходное изображение");
    display_lines([-1 -1 -1; 2 2 2; -1 -1 -1], 'Выделение горизонтальных линий');      
    display_lines([-1 -1 2; -1 2 -1; 2 -1 -1], 'Выделение линий с углом 45^{\circ}');
    % display_lines([-1 2 -1; -1 2 -1; -1 2 -1], 'Выделение вертикальных линий'); 
    display_lines([2 -1 -1; -1 2 -1; -1 -1 2], 'Выделение линий с углом -45^{\circ}');
end

function test_edge_filters()
    image_data = imread('images/building.tif')
    figure, imshow(image_data), title('Исходное изображение')
    figure, tiledlayout(2,3,'TileSpacing','tight', 'Padding','none');
    [sobel_def, t] = edge(image_data, 'sobel');
    nexttile, imshow(sobel_def), title('Детектор Собеля (по умолчанию)'); 
    
    [log_def, t] = edge(image_data, 'log'); 
    nexttile, imshow(log_def), title('Детектор LoG (по умолчанию)'); 

    [canny_def, t] = edge(image_data, 'canny'); 
    nexttile, imshow(canny_def), title('Детектор Канни (по умолчанию)'); 
    
    [sobel_custom, t] = edge(image_data, 'sobel', 0.05);
    nexttile, imshow(sobel_custom), title('Детектор Собеля при {t_s = 0.05}'); 
    
    [log_custom, t] = edge(image_data, 'log', 0.003, 2.25); 
    nexttile, imshow(log_custom), title('Детектор LoG при {t_{log} = 0.003, \sigma = 2.25}'); 

    [canny_custom, t] = edge(image_data, 'canny', [0.04, 0.10], 1.5); 
    nexttile, imshow(canny_custom), title('Детектор Канни при {t_с = [0.04, 0.10], \sigma = 1.5}'); 
end

function hough_filter()
    rotI = imread('images/building.tif');
    tiledlayout(1,3,'TileSpacing','tight', 'Padding','none');
    % Show original image
    nexttile, imshow(rotI), title("Исходное изображение");
    
    BW = edge(rotI,'canny', [0.04, 0.10], 1.5);
    % Show canny outline
    nexttile, imshow(BW), title("Применение детектора Канни, {t_с = [0.04, 0.10], \sigma = 1.5}");

    [H,T,R] = hough(BW);
    P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    x = T(P(:,2)); y = R(P(:,1));
    
    lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
    % Show Hough lines and peaks
    nexttile, imshow(rotI), title("Наложение линий"), hold on
    
    max_len = 0;
    for k = 1:length(lines)
       % Show Hough lines on the image
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    
       % Plot beginnings and ends of lines
       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    
       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end
    plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');

    figure;
    imshow(H,[],'XData',T,'YData',R, 'InitialMagnification','fit'),
    title("Преобразование Хафа с отображением локальных максимумов");        
    xlabel('\theta'), ylabel('\rho');
    axis on, axis normal, hold on;
    plot(x,y,'s','color','white');
end

function step_filter
    figure, tiledlayout(1,2,'TileSpacing','tight', 'Padding','none');
    f = imread('images/scanned-text-grayscale.tif');
    nexttile, imshow(f), title('Исходное изображение');
    T2 = graythresh(f); 
    disp(T2 * 255); 
    g = f >= T2 * 255; 
    nexttile, imshow(~g), title('Пороговая обработка');
end

function segment_grow()
    function [g, NR, SI, TI] = regiongrow(f, S, T)  
        f = double(f);  
        if numel(S) == 1  
            SI = f == S;  
            S1 = S;  
        else  
            SI = bwmorph(S, 'shrink', Inf);  
            J = SI;  
            S1 = f(J);  
        end  
        TI = false(size(f));  
        for K = 1:length(S1)  
            seedvalue = S1(K);  
            S = abs(f - seedvalue) <= T;  
            TI = TI | S;  
        end  
        [g, NR] = bwlabel(imreconstruct(SI,TI));  
    end  
    
    figure, tiledlayout(1,2,'TileSpacing','tight', 'Padding','none');

    f = imread('images/defective_weld.tif');   
    nexttile, imshow(f), title("Исходное изображение");

    [g, NR, SI, TI] = regiongrow(f, 255, 65);  
    
    nexttile, imshow(g), title("Выращивание областей");
end

function split_image()
    figure, tiledlayout(2,3,'TileSpacing','tight', 'Padding','none');
    f = imread('images/cygnusloop_Xray_original.tif');
    nexttile, imshow(f), title("Исходное изображение");
    block_sizes = [32, 16, 8, 4, 2];
    for i=1:5
        g = splitmerge(f, block_sizes(i), @predicate);  
        nexttile, imshow(g), title("Разложение блоками размером "+ block_sizes(i));
    end
    
    function g = splitmerge(f, mindim, fun)  
        Q = 2^nextpow2(max(size(f)));  
        [M, N] = size(f);  
        f = padarray(f, [Q-M, Q-N], 'post');  
        S = qtdecomp(f, @split_test, mindim, fun);  
        Lmax = full(max(S(:)));  
        g = zeros(size(f));  
        MARKER = zeros(size(f));  
        for K = 1:Lmax  
            [vals, r, c] = qtgetblk(f, S, K);  
            if ~isempty(vals)  
                for I = 1:length(r)  
                    xlow = r(I); ylow = c(I);  
                    xhigh = xlow + K - 1; yhigh = ylow + K - 1;  
                    region = f(xlow:xhigh, ylow:yhigh);  
                    flag = feval(fun, region);  
                    if flag  
                        g(xlow:xhigh, ylow:yhigh) = 1;  
                        MARKER(xlow, ylow) = 1;  
                    end  
                end  
            end  
        end  
        g = bwlabel(imreconstruct(MARKER, g));  
        g = g(1:M, 1:N);  
    end  
    function v = split_test(B, mindim, fun)  
        k = size(B, 3);  
        v(1:k) = false;  
        for I = 1:k  
            quardregion = B(:, :, I);  
            if size(quardregion, 1) <= mindim  
                v(I) = false;  
            continue  
            end  
            flag = feval(fun,quardregion);  
            if flag  
                v(I) = true;  
            end  
        end  
    end  
    function flag = predicate(region)  
        sd = std2(region);  
        m = mean2(region);  
        flag = (sd > 10) && (m > 0) && (m < 125);  
    end
end

function watershed_default
    figure, tiledlayout(1,2,'TileSpacing','tight', 'Padding','none');
    f = imread('images/binary-dowel-image.tif');
    nexttile, imshow(f), title("Исходное изображение");
    gc = ~f; 
    D = bwdist(gc); 
    L = watershed(-D); 
    w = L == 0; 
    g2 = gc & ~w; 
    nexttile, imshow(g2), title("Наложение водоразделов");
end

function watershed_gradient
    figure, tiledlayout(1,2,'TileSpacing','tight', 'Padding','none');
    f = imread('images/small-blobs.tif');
    nexttile, imshow(f), title('Исходное изображение');
    h = fspecial('sobel');  
    fd = double(f);  
    g = sqrt(imfilter(fd,h, 'replicate') .^2 + imfilter(fd, h', 'replicate') .^2);  
    
    L = watershed(g);  
    wr = L == 0;  
    nexttile, imshow(wr), title('Наложение водораздела');
end

function watershed_markers
    figure, tiledlayout(1,2,'TileSpacing','tight', 'Padding','none');
    f = imread('images/gel-image.tif');
    nexttile, imshow(f), title('Исходное изображение')
    
    h = fspecial('sobel');  
    fd = double(f);  
    g = sqrt(imfilter(fd,h, 'replicate') .^2 + imfilter(fd, h', 'replicate') .^2);  

    L = watershed(g);  
    wr = L == 0;  
    rm = imregionalmin(g);  
    im = imextendedmin(f, 2);  
    fim = f;  
    fim(im) = 175;  
    Lim = watershed(bwdist(im));  
    em = Lim == 0;  
    g2 = imimposemin(g, im | em);  
    L2 = watershed(g2);  
    f2 = f;  
    f2(L2 == 0) = 255;  
    nexttile, imshow(f2), title('Наложение водораздела');
end

% detect_point
% detect_line
% test_edge_filters
% hough_filter
% step_filter
% segment_grow
% split_image
% watershed_default
% watershed_gradient
watershed_markers