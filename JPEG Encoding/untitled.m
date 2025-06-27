in_image = imread('images/32x32 24bit.png');
img_size = size(in_image);

testYCrCb = rgb2ycbcr(in_image);

testY = testYCrCb(:, :, 1);
testCr = testYCrCb(:, :, 2);
testCb = testYCrCb(:, :, 3);

R = in_image(:, :, 1);
G = in_image(:, :, 2);
B = in_image(:, :, 3);

for i = 1:img_size(1)
    for j = 1:img_size(2)
        origin_Y(i,j) = 0.299 * R(i,j) + 0.578 * G(i,j) + 0.114 * B(i,j);
        origin_Cr(i,j) = 0.5 * R(i,j) - 0.4187 * G(i,j) + 0.0813 * B(i,j);
        origin_Cb(i,j) = 0.1678 * R(i,j) - 0.3313 * G(i,j) + 0.5* B(i,j);
    end
end

figure
imshow(testYCrCb)