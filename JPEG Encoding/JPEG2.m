in_image = imread('origin.png');
img_size = size(in_image);
%imshow(in_image);
R = in_image; R(:,:,2)=0; R(:,:,3)=0;
G = in_image; G(:,:,1)=0; G(:,:,3)=0;
B = in_image; B(:,:,1)=0; B(:,:,2)=0;

%figure, imshow(R)
%figure, imshow(G)
%figure, imshow(B)
for i = 1:img_size(1)
    for j = 1:img_size(2)
        Y(i,j) = 0.299 * R(i,j) + 0.578 * G(i,j) + 0.114 * B(i,j);
        Cb(i,j) = 0.1678 * R(i,j) - 0.3313 * G(i,j) + 0.5* B(i,j);
        Cr(i,j) = 0.5 * R(i,j) - 0.4187 * G(i,j) + 0.0813 * B(i,j);
    end
end
figure, imshow(Y)
figure, imshow(Cb)
figure, imshow(Cr)

% DCT matrix, quantization matrix
% ДКП МОЖНО ПОСЧИТАТЬ АВТОМАТИЧЕСКИ
% q - quality factor
q = 2;
for i = 0:7
    for j = 0:7
        if i == 0
            DCT(i+1,j+1) = 1 / sqrt(8);
        else
            DCT(i+1,j+1) = sqrt(2/8) * cos((2*j+1) * i * pi / (2*8));
        end
        % ПЕРЕДЕЛАТЬ МАТРИЦУ КВАНТОВАНИЯ
        Q(i+1,j+1) = 1 + ((1 + i + j) * q);
    end
end
% DCT
N = 1:64:img_size(1)*img_size(2);
n = 0;
for i = 1:8:img_size(1)
    for j = 1:8:img_size(2)
        n = n + 1;
        dots = Cb(i:i+7,j:j+7);
        Cb(i:i+7,j:j+7) = DCT * (double(dots) * DCT');
        dots = Cr(i:i+7,j:j+7);
        Cr(i:i+7,j:j+7) = DCT * (double(dots) * DCT');
        % quantization
        for k = 0:7
            for l = 0:7
                Y1(i+k,j+l) = Y(i+k,j+k) / Q(k+1,l+1);
                Cr1(i+k,j+l) = Cr(i+k,j+k) / Q(k+1,l+1);
                Cb1(i+k,j+l) = Cb(i+k,j+l) / Q(k+1,l+1);
            end
        end
        % zigzag
        % imshow(Y1);
        Y_z(N(n):N(n)+63) = zigzag(Y1(i:i+7,j:j+7));
        Cb_z(N(n):N(n)+63) = zigzag(Cb1(i:i+7,j:j+7));
        Cr_z(N(n):N(n)+63) = zigzag(Cr1(i:i+7,j:j+7));        
    end
end