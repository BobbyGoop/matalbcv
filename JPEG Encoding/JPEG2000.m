clearvars;
close all;
in_image=imread("Images/PNG/16x16-(24b).png");
img_size = size(in_image);

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
    ycbcr = rgb2ycbcr(in_image);
    custom_ycbcr = min(max(0,round(0.256788*R+0.5040509*G+0.09790*B + 16)),255);
end
ycbcr_or = R;
min_v = min(min(ycbcr_or));
ycbcr = ycbcr_or - 16;


% DESCRETE WAVELET TRANSFORM
[C,S]=wavedec2(ycbcr(:, :, 1),4,'haar');

% LEVEL 1 EXTRACTION
[H1,V1,D1] = detcoef2('all',C,S,1);
A1 = appcoef2(C,S,'haar',1);

V1img = wcodemat(V1,255,'mat',1);
H1img = wcodemat(H1,255,'mat',1);
D1img = wcodemat(D1,255,'mat',1);
A1img = wcodemat(A1,255,'mat',1);

figure
colormap gray(255)
subplot(2,2,1)
imagesc(A1img)
pbaspect([1 1 1])
title('Approximation Coef. of Level 1')

subplot(2,2,2)
imagesc(H1img)
pbaspect([1 1 1])
title('Horizontal Detail Coef. of Level 1')

subplot(2,2,3)
imagesc(V1img)
pbaspect([1 1 1])
title('Vertical Detail Coef. of Level 1')

subplot(2,2,4)
imagesc(D1img)
pbaspect([1 1 1])
title('Diagonal Detail Coef. of Level 1')

zz = Zigzag(A1img);

% %--------------------------------------------
% % LEVEL 2 EXCTRACTION
% [H2,V2,D2] = detcoef2('all',C,S,2);
% A2 = appcoef2(C,S,'haar',2);
% 
% V2img = wcodemat(V2,255,'mat',1);
% H2img = wcodemat(H2,255,'mat',1);
% D2img = wcodemat(D2,255,'mat',1);
% A2img = wcodemat(A2,255,'mat',1);
% 
% 
% figure
% subplot(2,2,1)
% imagesc(A2img)
% pbaspect([1 1 1])
% colormap pink(255)
% title('Approximation Coef. of Level 2')
% 
% subplot(2,2,2)
% imagesc(H2img)
% pbaspect([1 1 1])
% title('Horizontal Detail Coef. of Level 2')
% 
% subplot(2,2,3)
% imagesc(V2img)
% pbaspect([1 1 1])
% title('Vertical Detail Coef. of Level 2')
% 
% subplot(2,2,4)
% imagesc(D2img)
% pbaspect([1 1 1])
% title('Diagonal Detail Coef. of Level 2')
% 
% %--------------------------------------------
% % LEVEL 3 EXCTRACTION
% [H3,V3,D3] = detcoef2('all',C,S,3);
% A3 = appcoef2(C,S,'haar',3);
% 
% V3img = wcodemat(V3,255,'mat',1);
% H3img = wcodemat(H3,255,'mat',1);
% D3img = wcodemat(D3,255,'mat',1);
% A3img = wcodemat(A3,255,'mat',1);
% 
% 
% figure
% colormap gray(255)
% subplot(2,2,1)
% imagesc(A3img)
% pbaspect([1 1 1])
% title('Approximation Coef. of Level 3')
% 
% subplot(2,2,2)
% imagesc(H3img)
% pbaspect([1 1 1])
% title('Horizontal Detail Coef. of Level 3')
% 
% subplot(2,2,3)
% imagesc(V3img)
% pbaspect([1 1 1])
% title('Vertical Detail Coef. of Level 3')
% 
% subplot(2,2,4)
% imagesc(D3img)
% pbaspect([1 1 1])
% title('Diagonal Detail Coef. of Level 3')
% 
% %--------------------------------------------
% % LEVEL 3 EXCTRACTION
% [H4,V4,D4] = detcoef2('all',C,S,4);
% A4 = appcoef2(C,S,'haar',4);
% 
% V4img = wcodemat(V4,255,'mat',1);
% H4img = wcodemat(H4,255,'mat',1);
% D4img = wcodemat(D4,255,'mat',1);
% A4img = wcodemat(A4,255,'mat',1);
% 
% 
% figure
% colormap gray(255)
% subplot(2,2,1)
% imagesc(A4img)
% pbaspect([1 1 1])
% title('Approximation Coef. of Level 4')
% 
% subplot(2,2,2)
% imagesc(H4img)
% pbaspect([1 1 1])
% title('Horizontal Detail Coef. of Level 4')
% 
% subplot(2,2,3)
% imagesc(V4img)
% pbaspect([1 1 1])
% title('Vertical Detail Coef. of Level 4')
% 
% subplot(2,2,4)
% imagesc(D4img)
% pbaspect([1 1 1])
% title('Diagonal Detail Coef. of Level 4')

