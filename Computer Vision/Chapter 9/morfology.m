function morph_basic(img_array)
    figure;
    se = strel('diamond', 1);
    image_dilated = imdilate(img_array, se);
    imshow(image_dilated);
    
    figure;
    se = strel('disk', 1);
    image_eroded = imerode(img_array, se);
    imshow(image_eroded);
    
    morph_gradient = imsubtract(image_dilated, image_eroded);
    figure;
    imshow(morph_gradient);
end

function morph_combined(img_array)
    figure;
    se = strel('disk', 2);
    fo = imopen(image_logo, se);
    imshow(fo);
    figure;
    fc = imclose(fo, se);
    imshow(fc);
end

function filtered_img = alternative_filtration(img_array)
    filtered_img = img_array;
    for k = 2:5
        B = strel('disk', k);
        filtered_img = imclose(imopen(filtered_img, B), B);
    end
    figure;
    imshow(filtered_img);
end

function tophat_filtration(img_array)
    B = strel('disk', 10);
    img_tophat = imtophat(img_array, B);
    figure, imshow(img_tophat);
    figure, imshow(imbinarize(img_tophat, graythresh(img_tophat)));
end

function success_failure_filter(img_array)
    B1 = strel([0 0 0; 0 1 1; 0 1 0]);
    B2 = strel([1 1 1; 1 0 0; 1 0 0]);
    figure, imshow(bwhitmiss(img_array, B1, B2));
end

function morph_thin_test(img_array)
    figure, imshow(bwmorph(img_array, 'thin', 1));
    figure, imshow(bwmorph(img_array, 'thin', 2));
    figure, imshow(bwmorph(img_array, 'thin', inf));
end

function find_mass_center(img_array)
    [L, n] = bwlabel(img_array);
    hold on;
    for k = 1:n
        [r, c] = find(L == k);
        rbar = mean(r);
        cbar = mean(c);
        plot(cbar, rbar, 'Marker', 'o', 'MarkerEdgeColor', 'k','MarkerFaceColor', 'k', 'MarkerSize', 10) 
        plot(cbar, rbar, 'Marker', '*', 'MarkerEdgeColor', 'w') 
    end
end

function image_reconstruction(marker, mask)
    figure, imshow(imreconstruct(marker, mask));
end

function open_with_reconst(im_array)
    image_eroded = imerode(im_array, ones(51, 1));
    image_opened = imopen(im_array, ones(51, 1));
    image_reconst = imreconstruct(image_eroded, im_array);

    figure, imshow(image_eroded);
    figure, imshow(image_opened);
    figure, imshow(image_reconst);
end

function dowels_reconstruct(f)
    se = strel('disk' , 15); 
    fe = imerode(f, se); 
    fobr = imreconstruct (fe, f);
    figure, imshow(fobr);
    fobrc = imcomplement (fobr) ; 
    fobrce = imerode(fobrc, se) ; 
    fobrcbr = imcomplement(imreconstruct(fobrce, fobrc));
    figure, imshow(fobrcbr);
end

function calculator_reconstruct(im_array)
    calc_obr = imreconstruct(imerode(im_array, ones(1, 71)), im_array);
    calc_thr = imsubtract(im_array, calc_obr);
    
    g_obr = imreconstruct(imerode(calc_thr, ones(1, 11)), calc_thr);
    g_obrd = imdilate(g_obr, ones(1, 21));
    im_final = imreconstruct(min(g_obrd, calc_thr), calc_thr);
    figure, imshow(im_final);
end

function basic_operations()
   first_image = imread("images\utk.tif");
   second_image = imread("images\gt.tif");
   
   figure, imshow(first_image);
   figure, imshow(second_image);
   figure, imshow(~first_image);
   figure, imshow(first_image & second_image);
   figure, imshow(first_image | second_image);
   figure, imshow(first_image & ~second_image);
end

function count_granules(data)
    subp_open = zeros(1, 36);
    for k = 0:35
        B = strel("disk", k);
        data_open = imopen(data, B);
        subp_open(k+1) = sum(data_open(:));
    end
    subplot(2, 1, 1), plot(0:35, subp_open), xlabel('k'), ylabel('Площадь поверхности');
    subplot(2, 1, 2), plot(-diff(subp_open)), xlabel('k'), ylabel('сокращение площади поверхности');
end

image_logo = imread("images/dowels.tiff");
count_granules(alternative_filtration(image_logo));

% count_granules(image_logo);

% image_logo = im2gray(image_logo);
% figure, imshow(image_logo);
% calculator_reconstruct(image_logo);


% figure, imshow(imfill(image_logo, 'holes'));
% figure, imshow(imclearborder(image_logo, 26));
% figure, imshow(image_logo);
% open_with_reconst(image_logo);
% find_mass_center(image_logo);