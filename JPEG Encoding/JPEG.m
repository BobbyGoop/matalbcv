% Input Image
in_image = imread('Squares (grey)/squares.bmp');
img_size = size(in_image);

% Pre-allocating arrays
dct_Cr = zeros(img_size(1), img_size(2));
dct_Cb = zeros(img_size(1), img_size(2));

quant_Y = zeros(img_size(1), img_size(2));
quant_Cr = zeros(img_size(1), img_size(2));
quant_Cb = zeros(img_size(1), img_size(2));

%   ZIG-ZAG IS ONE-DIMENSIONAL
zz_Y = zeros(1, img_size(1)*img_size(2));
zz_Cr = zeros(1,img_size(1)*img_size(2));
zz_Cb = zeros(1,img_size(1)*img_size(2));

origin_Y = zeros(img_size(1), img_size(2));
origin_Cr = zeros(img_size(1), img_size(2));
origin_Cb = zeros(img_size(1), img_size(2));

% READING CHANNELS;
dims = ndims(in_image);
if dims == 2
    R = in_image; 
    G = zeros(img_size(1),img_size(2));
    B = zeros(img_size(1),img_size(2));
    img_weight = img_size(1)*img_size(2)*3*8;
else
    R = in_image(:, :, 1);
    G = in_image(:, :, 2);
    B = in_image(:, :, 3);
    img_weight = img_size(1)*img_size(2)*3*24;
end

% check for grayscale
for i = 1:img_size(1)
    for j = 1:img_size(2)
    if (R(i,j) == G(i,j)) && (G(i,j) ==  B(i,j))
        grayscale = true;
    else
        grayscale = false;
    end
    end
end

for i = 1:img_size(1)
    for j = 1:img_size(2)
        if grayscale
            origin_Y(i,j) = -128 + double(0.299 * R(i,j) + 0.587 * G(i,j) + 0.114 * B(i,j));
        end
        if not(grayscale)
            origin_Y(i,j)  = 16 + 0.299 * double(R(i,j)) + 0.587 * double(G(i,j)) + 0.114 * double(B(i,j));
            origin_Cr(i,j) = -128 +0.1687 * double(R(i,j)) - 0.3313 * double(G(i,j)) + 0.5 * double(B(i,j));
            origin_Cb(i,j) = 128  + 0.5 * double(R(i,j)) - 0.4187 * double(G(i,j)) - 0.0813*double(B(i,j));
        end
    end
end

block_size = 8;
DCT = dctmtx(block_size);

Q_lum = [3   2   2   3   4   6   8  10; 
         2   2   2   3   4   9  10   9  ;
         2   2   3   4   6   9  11   9 ;
         2   3   4   5   8  14  13  10 ;
         3   4   6   9  11  17  16  12 ;
         4   6   9  10  13  17  18  15 ;
         8  10  12  14  16  19  19  16 ;
         12  15  15  16  18  16  16  16]; 

     
Q_chrom = [3   3   4   8  16  16  16  16;
           3   3   4  11  16  16  16  16;
           4   4   9  16  16  16  16  16;
           8  11  16  16  16  16  16  16;
           16  16  16  16  16  16  16  16; 
           16  16  16  16  16  16  16  16;
           16  16  16  16  16  16  16  16; 
           16  16  16  16  16  16  16  16];  



% DCT
N = 1:64:img_size(1)*img_size(2);
n = 0;
for i = 1:8:img_size(1)
    for j = 1:8:img_size(2)
        n = n + 1;
        
        dct_Y(i:i+7,j:j+7) = dct2(origin_Y(i:i+7,j:j+7));
        dct_Cb(i:i+7,j:j+7) = dct2(origin_Cb(i:i+7,j:j+7));
        dct_Cr(i:i+7,j:j+7) = dct2(origin_Cr(i:i+7,j:j+7));
        
        % quantization
        for k = 0:7
            for l = 0:7
                quant_Y(i+k,j+l) = round(dct_Y(i+k,j+l) / Q_lum(k+1,l+1));
                quant_Cb(i+k,j+l) = round(dct_Cb(i+k,j+l) / Q_chrom(k+1,l+1));
                quant_Cr(i+k,j+l) = round(dct_Cr(i+k,j+l) / Q_chrom(k+1,l+1));
                
            end
        end
        
        % zigzag
        zz_Y(N(n):N(n)+63) = Zigzag(quant_Y(i:i+7,j:j+7));
        zz_Cb(N(n):N(n)+63) = Zigzag(quant_Cb(i:i+7,j:j+7));
        zz_Cr(N(n):N(n)+63) = Zigzag(quant_Cr(i:i+7,j:j+7));        
    end
end

% Rounding coefficients before RLE
% RLE_Y = RLE(zz_Y);
% RLE_Cb = RLE(zz_Cb);
% RLE_Cr = RLE(zz_Cr);
% 
% fprintf('\nЗиг-заг: %.0f, %.0f, %.0f', length(zz_Y),length(zz_Cb), length(zz_Cr))
% fprintf('\nRLE: %.0f, %.0f, %.0f\n\n', length(RLE_Y), length(RLE_Cb), length(RLE_Cr))
% 
% [sym_Y, probs_Y] = Probs(RLE_Y);
% [sym_Cr, probs_Cr] = Probs(RLE_Cr);
% [sym_Cb, probs_Cb] = Probs(RLE_Cb);
% 
% disp('Y matrix encoded')
% code_Y= HE(RLE_Y, sym_Y, probs_Y);
% 
% disp('Cr matrix encoded')
% code_Cr = HE(RLE_Cr, sym_Cr, probs_Cr);
% 
% disp('Cb matrix encoded')
% code_Cb = HE(RLE_Cb, sym_Cb, probs_Cb); 
% 
% fprintf('Image: %.0f bit\n', img_weight)
% fprintf('JPEG: %.0f bit\n', (length(code_Y) + length(code_Cr) + length(code_Cb)))
% 
% inverse = idct2(quant_Y);
% DRAWING
% figure('Name', 'RGB Split')
% zero_channel = cast(zeros(img_size(1),img_size(2)), 'uint8');
% subplot(1, 3, 1), imshow(cat(3, R, zero_channel, zero_channel))
% subplot(1, 3, 2), imshow(cat(3, zero_channel, G, zero_channel))
% subplot(1, 3, 3), imshow(cat(3, zero_channel, zero_channel, B))
% 
% figure('Name', 'YCrCb')
% subplot(1, 3, 1), imshow(cast(origin_Y, 'uint8'))
% subplot(1, 3, 2), imshow(cast(origin_Cb, 'uint8'))
% subplot(1, 3, 3), imshow(cast(origin_Cr, 'uint8'))
% 
% dct_full = dctmtx(img_size(1));
% 
% dctf_Y = dct_full * (double(origin_Y) * dct_full');
% dctf_Cr = dct_full * (double(origin_Cr) * dct_full');
% dctf_Cb = dct_full * (double(origin_Cb) * dct_full');
% 
% figure('Name', 'DCT')
% subplot(1, 3, 1), imshow(cast(dctf_Y, 'uint8'))
% subplot(1, 3, 2), imshow(cast(dctf_Cb, 'uint8'))
% subplot(1, 3, 3), imshow(cast(dctf_Cr, 'uint8'))



