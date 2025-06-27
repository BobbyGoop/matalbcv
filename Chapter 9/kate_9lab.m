function basic_operations()
   first_image = imread("images\utk.tif");
   second_image = imread("images\gt.tif");
   tiledlayout(2,3, 'TileSpacing', 'tight' , 'Padding', 'tight');

   nexttile, imshow(first_image), title('a)');
   nexttile, imshow(second_image), title('б)');
   nexttile, imshow(~first_image), title('в)');
   nexttile, imshow(first_image & second_image), title('г)');
   nexttile, imshow(first_image | second_image), title('д)');
   nexttile, imshow(first_image & ~second_image), title('е)');
end

function morph_operations()
    % img_array = imread("images/book-text.tif");
    img_array = imread("images/aerial.tif");
    tiledlayout(2,2, 'TileSpacing', 'tight' , 'Padding', 'tight');
    nexttile, imshow(img_array), title('Исходное изображение');

    se = strel('diamond', 1);
    image_dilated = imdilate(img_array, se);
    nexttile, imshow(image_dilated), title('Операция дилатации');
    
    se = strel('disk', 2);
    image_eroded = imerode(img_array, se);
    nexttile, imshow(image_eroded), title('Операция эрозии');
    
    morph_gradient = imsubtract(image_dilated, image_eroded);
    nexttile, imshow(morph_gradient), title('Морфологический градиент');
end

function morph_combined()
    img_array = imread("images/noisy-fingerprint.tif");
    tiledlayout(1,3, 'TileSpacing', 'none' , 'Padding', 'tight');
    
    nexttile, imshow(img_array), title("Исходное изображение")
    se = strel('square', 3);
    fo = imopen(img_array, se);
    
    nexttile, imshow(fo), title("Операция размыкания");
    fc = imclose(fo, se);
    nexttile, imshow(fc),  title("Операция замыкания после операции размыкания");
end

function filtered_img = alternative_filtration(image_data)
    tiledlayout(2,1, 'TileSpacing', 'tight' , 'Padding', 'tight');
    if nargin == 0
        filtered_img = imread("images/dowels.tiff");
    else
        filtered_img = image_data;
    end
    nexttile, imshow(filtered_img), title("Исходное изображение");
    for k = 2:5
        B = strel('disk', k);
        filtered_img = imclose(imopen(filtered_img, B), B);
    end
    nexttile, imshow(filtered_img), title("Результат фильтрации");
end

function tophat_filtration()
    tiledlayout(1,3, 'TileSpacing', 'none' , 'Padding', 'tight');
    img_array = imread("images/rice.tif");
    nexttile, imshow(img_array), title('Исходное изображение');
    B = strel('disk', 10);
    img_tophat = imtophat(img_array, B);
    nexttile, imshow(img_tophat), title('Применение top-hat');
    nexttile, imshow(imbinarize(img_tophat, graythresh(img_tophat))), title('Результат после пороговой фильтрации');
end

function count_granules()
    % data = alternative_filtration(imread("images/dowels.tif"));
    data = imread("images/dowels.tif");
    subp_open = zeros(1, 36);
    for k = 0:35
        B = strel("disk", k);
        data_open = imopen(data, B);
        subp_open(k+1) = sum(data_open(:));
    end
    figure, sgtitle("Графики зависимости площади поверхности фигур от радиуса структурообразующего элемента");
    subplot(2, 1, 1), plot(0:35, subp_open), xlabel('k'), ylabel('Площадь поверхности'), grid on, grid minor;
    subplot(2, 1, 2), plot(-diff(subp_open)), xlabel('k'), ylabel('Сокращение площади поверхности'), grid on, grid minor;
end

function hit_miss_filter()
    tiledlayout(1,2, 'TileSpacing', 'none' , 'Padding', 'tight');
    img_array = imread("images/small-squares.tif")
    nexttile, imshow(img_array), title("Исходное изображение");
    B1 = strel([0 0 0; 0 1 1; 0 1 0]);
    B2 = strel([1 1 1; 1 0 0; 1 0 0]);
    nexttile, imshow(bwhitmiss(img_array, B1, B2)), title("Результат фильтрации");
end

function convey_game()
    function out = conwaylaws(nhood)
        num_neighbors = sum(nhood(:)) - nhood(2, 2);
        if nhood(2, 2) == 1
            if num_neighbors == 1
                out = 0;
            elseif num_neighbors >= 4
                out = 0;
            else
                out = 1;
            end
        else
            if num_neighbors == 3
                out = 1;
            else 
                out = 0;
            end
        end
    end
    tiledlayout(1,3, 'TileSpacing', 'Tight' , 'Padding', 'tight');
    lut = makelut(@conwaylaws, 3);
    
    data = imread("images/smile.bmp");
    nexttile, imshow(data), title('GEN 1');
    
    gen2 = bwlookup(data, lut);
    nexttile, imshow(gen2), title('GEN 2');
    
    gen3 = bwlookup(gen2, lut);
    nexttile, imshow(gen3), title('GEN 3');
end

function morph_thin_test()
    tiledlayout(2,2, 'TileSpacing', 'Tight' , 'Padding', 'tight');
    img_array = imread("images/noisy-fingerprint.tif");
    nexttile, imshow(img_array), title("Исходное изображение");
    nexttile, imshow(bwmorph(img_array, 'thin', 1)), title("Утончение 1 раз");
    nexttile, imshow(bwmorph(img_array, 'thin', 2)), title("Утончение 2 раза");
    nexttile, imshow(bwmorph(img_array, 'thin', inf)), title("Утончение до стабилизации");
end

function bones_calculator()
    function state = is_endpoint(nhood)
        state = nhood(2, 2) & (sum(nhood(:))) == 2;
    end

    function g = endpoints(f)
        persistent lut
        if isempty(lut)
            lut = makelut(@is_endpoint, 3);
        end
        g = bwlookup(f, lut);
    end
    tiledlayout(1,3, 'TileSpacing', 'Tight' , 'Padding', 'tight');
    img_data = imread("images/bone.tif");
    nexttile, imshow(img_data), title('Исходное изображение');
    
    img_skeleton = bwmorph(img_data, 'skeleton', Inf);
    nexttile, imshow(img_skeleton), title('Остов от bwmorph');
    
    for k = 1:5
        img_skeleton = img_skeleton &~ endpoints(img_skeleton);
    end
    nexttile, imshow(img_skeleton), title('Удаление лишних точек');
end

function find_mass_center()
    tiledlayout(1,2, 'TileSpacing', 'Tight' , 'Padding', 'tight');
    img_array = imread("images/ten-objects.tif")
    nexttile, imshow(img_array), title("Исходное изображение");
    
    [L, n] = bwlabel(img_array);
    nexttile, imshow(img_array), title("Центры масс");
    hold on;
    for k = 1:n
        [r, c] = find(L == k);
        rbar = mean(r);
        cbar = mean(c);
        plot(cbar, rbar, 'Marker', 'o', 'MarkerEdgeColor', 'k','MarkerFaceColor', 'k', 'MarkerSize', 10) 
        plot(cbar, rbar, 'Marker', '*', 'MarkerEdgeColor', 'w') 
    end
end

function morph_reconstruct()
    tiledlayout(1,3, 'TileSpacing', 'Tight' , 'Padding', 'tight');
    marker = imread("images/recon-marker.tif");
    mask = imread("images/recon-mask.tif");
    nexttile, imshow(marker), title("Маркер");
    nexttile, imshow(mask), title("Маска");
    nexttile, imshow(imreconstruct(marker, mask)), title("Результат");
end

function open_with_reconst()
    image_array = imread("images/book-text.tif");
    image_eroded = imerode(image_array, ones(51, 1));
    image_opened = imopen(image_array, ones(51, 1));
    image_reconst = imreconstruct(image_eroded, image_array);
    tiledlayout(2,2, 'TileSpacing', 'Tight' , 'Padding', 'tight');
    nexttile, imshow(image_array), title('Исходное изображение')
    nexttile, imshow(image_eroded), title('Эрозия по вертикальной черте');
    nexttile, imshow(image_opened), title('Размыкание по вертикальной черте');
    nexttile, imshow(image_reconst), title('Реконструкция разымканием по вертикальной черте');
end

function fill_emptinesses()
    image_data = imread("images/book-text.tif");
    tiledlayout(2,1, 'TileSpacing', 'Tight' , 'Padding', 'tight');
    nexttile, imshow(image_data), title("Исходное изображение");
    nexttile, imshow(imfill(image_data, 'holes')), title("Эффект заполнения отверстий");
end

function clear_borders()
    image_data = imbinarize(im2gray(imread("images/stones.png")));
    tiledlayout(1,2, 'TileSpacing', 'Tight' , 'Padding', 'tight');
    nexttile, imshow(image_data), title("Исходное изображение");
    nexttile, imshow(imclearborder(image_data, 26)), title("Удаление объектов на границах");
end

function dowels_reconstruct()
    tiledlayout(1,3, 'TileSpacing', 'Tight' , 'Padding', 'tight');
    f = imread("images/dowels.tif");
    nexttile, imshow(f), title("Исходное изображение");
    
    se = strel('disk' , 15); 
    fe = imerode(f, se); 
    fobr = imreconstruct (fe, f);
    nexttile, imshow(fobr), title("Размыкание реконструкцией");

    fobrc = imcomplement (fobr); 
    fobrce = imerode(fobrc, se); 
    fobrcbr = imcomplement(imreconstruct(fobrce, fobrc));
    nexttile, imshow(fobrcbr), title("Замыкание реконструкцией размыкания реконструкции");
end

function calculator_reconstruct()
    tiledlayout(1,2, 'TileSpacing', 'Tight' , 'Padding', 'tight');
    img_array = imread("images/calculator.tif");
    nexttile, imshow(img_array ), title("Исходное изображение");

    calc_obr = imreconstruct(imerode(img_array , ones(1, 71)), img_array );
    calc_thr = imsubtract(img_array , calc_obr);
    
    g_obr = imreconstruct(imerode(calc_thr, ones(1, 11)), calc_thr);
    g_obrd = imdilate(g_obr, ones(1, 21));
    img_final = imreconstruct(min(g_obrd, calc_thr), calc_thr);
    nexttile, imshow(img_final), title("Итоговый результат");
end

basic_operations
morph_operations
morph_combined
alternative_filtration
tophat_filtration
count_granules
hit_miss_filter
convey_game
morph_thin_test
bones_calculator
find_mass_center
morph_reconstruct
open_with_reconst
fill_emptinesses
clear_borders
dowels_reconstruct
calculator_reconstruct