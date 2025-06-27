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

img_data = imread("images/bone.tif");
figure, imshow(img_data);

img_skeleton = bwmorph(img_data, 'skeleton', Inf);
figure, imshow(img_skeleton);

for k = 1:5
    img_skeleton = img_skeleton &~ endpoints(img_skeleton);
end
figure, imshow(img_skeleton);