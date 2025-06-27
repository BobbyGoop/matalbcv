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

lut = makelut(@conwaylaws, 3);

data = imread("images/creature.bmp");
figure, imshow(data);

gen2 = bwlookup(data, lut);
figure, imshow(gen2);

gen3 = bwlookup(gen2, lut);
figure, imshow(gen3);
