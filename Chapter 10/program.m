function [h, theta, rho] = hough_2(f, dtheta, drho) 
    % HOUGH Hough transform. 
    % [H, THETA, RHO] = HOUGH(F, DTHETA, DRHO) computes the Hough 
    % transform of the image F. DTHETA specifies the spacing (in 
    % degrees) of the Hough transform bins along the theta axis. DRHO 
    % specifies the spacing of the Hough transform bins along the rho 
    % axis. H is the Hough transform matrix. It is NRHO-by-NTHETA, 
    % where NRHO = 2*ceil(norm(size(F))/DRH0) - 1, and NTHETA = 
    % 2*ceil(90/DTHETA). Note that if 90/DTHETA is not an integer, the 
    % actual angle spacing will be 90 / ceil (90/DTHETA) . 
    % 
    % THETA is an NTHETA-element vector containing the angle (in 
    % degrees) corresponding to each column of H. RHO is an 
    % NRHO-element vector containing the value of rho corresponding to 
    % each row of H. 
    % [H, THETA, RHO] = HOUGH(F) computes the Hough transform using 
    % DTHETA = 1 and DRHO = 1. 
    if nargin < 3 
        drho = 1; 
    end 
    if nargin < 2 
        dtheta = 1; 
    end 
    f = double(f); 
    [M,N] = size(f); 
    theta = linspace(-90, 0, ceil(90/dtheta) + 1); 
    theta = [theta -fliplr(theta(2:end - 1))]; 
    ntheta = length(theta); 
    D = sqrt((M - 1)^2 + (N - 1)^2); 
    q = ceil(D/drho); 
    nrho = 2*q - 1; 
    rho = linspace(-q*drho, q*drho, nrho); 
    [x, y, val] = find(f); 
    x=x-1;y=y-1; 
    % Initialize output, 
    h = zeros(nrho, length(theta)); 
    % To avoid excessive memory usage, process 1000 nonzero pixel 
    % values at a time, 
    for k = 1:ceil(length(val)/1000) 
        first = (k - 1)*1000 + 1; 
        last = min(first+999, length(x)); 
        x_matrix = repmat(x(first:last), 1, ntheta); 
        y_matrix = repmat(y(first:last), 1, ntheta); 
        val_matrix = repmat(val(first:last), 1, ntheta); 
        theta_matrix = repmat(theta, size(x_matrix, 1), 1)*pi/180; 
        rho_matrix = x_matrix.*cos(theta_matrix) + ... 
            y_matrix.*sin(theta_matrix); 
        slope = (nrho - 1)/(rho(end) - rho(1)); 
        rho_bin_index = round(slope*(rho_matrix - rho(1)) + 1); 
        theta_bin_index = repmat(1:ntheta, size(x_matrix, 1), 1); 
        % Take advantage of the fact that the SPARSE function, which 
        % constructs a sparse matrix, accumulates values when input 
        % indices are repeated. That's the behavior we want for the 
        % Hough transform. We want the output to be a full (nonsparse) 
        % matrix, however, so we call function FULL on the output of 
        % SPARSE. 
        h = h + full(sparse(rho_bin_index(:), theta_bin_index(:), val_matrix(:), nrho, ntheta)); 

    end
end


function [r, c, hnew] = houghpeaks(h, numpeaks, threshold, nhood) 
    % HOUGHPEAKS Detect peaks in Hough transform. 
    % [R, C, HNEW] = HOUGHPEAKSCH, NUMPEAKS, THRESHOLD, NHOOD) detects 
    % peaks in the Hough transform matrix H. NUMPEAKS specifies the 
    % maximum number of peak locations to look for. Values of H below 
    % THRESHOLD will not be considered to be peaks. NHOOD is a 
    % two-element vector specifying the size of the suppression 
    % neighborhood. This is the neighborhood around each peak that is 
    % set to zero after the peak is identified. The elements of NHOOD 
    % must be positive, odd integers. R and С are the row and column 
    % coordinates of the identified peaks. HNEW is the Hough transform 
    % with peak neighborhood suppressed. 
    % 
    % If NHOOD is omitted, it defaults to the smallest odd values >= 
    % size(H)/50. If THRESHOLD is omitted, it defaults to 
    % 0.5*max(H(:)) . If NUMPEAKS is omitted, it defaults to 1. 
    if nargin < 4 
    nhood = size(h)/50; 
    % Make sure the neighborhood size is odd. 
    nhood = max(2*ceil(nhood/2) + 1, 1); 
    end 
    if nargin < 3 
        threshold = 0.5 * max(h(:)); 
    end 
    if nargin < 2 
        numpeaks = 1; 
    end 
        done = false; 
        hnew = h; r = [];
        c = [] ; 
    while ~done 
        [p, q] = find(hnew == max(hnew(:))); 
        p = p(1); q = q(1); 
        if hnew(p, q) >= threshold 
            r(end + 1) = p; c(end + 1) = q; 
            % Suppress this maximum and its close neighbors. 
            p1 = p - (nhood(1) - 1)/2; p2 = p + (nhood(1) - 1)/2; 
            q1 = q - (nhood(2) - 1)/2; q2 = q + (nhood(2) - 1)/2; 
            [pp, qq] = ndgrid(p1:p2, q1:q2); 
            pp = pp(:); qq = qq(:); 
            % Throw away neighbor coordinates that are out of bounds in 
            % the rho direction. 
            badrho = find((pp < 1) | (pp > size(h, 1))); 
            pp(badrho) = [] ; qq (badrho) = [] ; 
            % For coordinates that are out of bounds in the theta 
            % direction, we want to consider that H is antisymmetric 
            % along the rho axis for theta = +/- 90 degrees. 
            theta_too_low = find(qq < 1) ;
            qq(theta_too_low) = size(h, 2) + qq(theta_too_low); 
            pp(theta_too_low) = size(h, 1) - pp(theta_too_low) + 1; 
            theta_too_high = find(qq > size(h, 2)); 
            qq(theta_too_high) = qq(theta_too_high) - size(h, 2); 
            pp(theta_too_high) = size(h, 1) - pp(theta_too_high) + 1; 
            % Convert to linear indices to zero out all the values. 
            hnew(sub2ind(size(hnew), pp, qq)) = 0; 
            done = length(r) == numpeaks; 
        else 
            done = true; 
        end 
    end
end


function lines = houghlines(f,theta,rho,rr,cc,fillgap,minlength) 
    % HOUGHLINES Extract line segments based on the Hough transform. 
    % LINES = HOUGHLINES(F, THETA, RHO, RR, CC, FILLGAP, MINLENGTH) 
    % extracts line segments in the image F associated with particular 
    % bins in a Hough transform. THETA and RHO are vectors returned by 
    % function HOUGH. Vectors RR and CC specify the rows and columns 
    % of the Hough transform bins to use in searching for line 
    % segments. If HOUGHLINES finds two line segments associated with 
    % the same Hough transform bin that are separated by less than 
    % FILLGAP pixels, HOUGHLINES merges them into a single line 
    % segment. FILLGAP defaults to 20 if omitted. Merged line 
    % segments less than MINLENGTH pixels long are discarded. 
    % MINLENGTH defaults to 40 if omitted. 
    % 
    % LINES is a structure array whose length equals the number of 
    % merged line segments found. Each element of the structure array 
    % has these fields: 
    % 
    % pointl End-point of the line segment; two-element vector 
    % point2 End-point of the line segment; two-element vector 
    % length Distance between pointl and point2 
    % theta Angle (in degrees) of the Hough transform bin 
    % rho Rho-axis position of the Hough transform bin 
    if nargin < 6 
        fillgap = 20; 
    end 
    if nargin < 7 
        minlength = 40; 
    end 
        numlines = 0; lines = struct; 
    for k = l:length(rr) 
        rbin = rr(k); cbin = cc(k); 
        % Get all pixels associated with Hough transform cell. 
        [r, c] = houghpixels(f, theta, rho, rbin, cbin); 
        if isempty(r) 
            continue 
        end 

        % Rotate the pixel locations about A,1) so that they lie 
        % approximately along a vertical line. 
        omega = (90 - theta(cbin)) * pi / 180; 
        T = [cos(omega) sin(omega); -sin(omega) cos(omega)]; 
        xy = [r - 1 c - 1] * T; 
        x = sort(xy(:,1)); 
        % Find the gaps larger than the threshold. 
        diff.x = [diff(x); Inf]; 
        idx = [0; find(diff_x > fillgap)] ; 
        for p = 1:length(idx) - 1 
            xl = x(idx(p) + 1); x2 = x(idx(p + 1)); 
            linelength = x2 - xl; 
            if linelength >= minlength 
                point1 = [xl rho(rbin)] / T;
                point2 = [x2 rho(rbin)] / T; 
                % Rotate the end-point locations back to the original angle. 
                % MATLAB warnings for inversion
                % Tinv = inv(T); 
                % point1 = point1 * Tinv;
                % point2 = point2 * Tinv; 
                numlines = numlines + 1; 
                lines(numlines).point1 = point1 + 1; 
                lines(numlines).point2 = point2 + 1; 
                lines(numlines).length = linelength; 
                lines(numlines).theta = theta(cbin); 
                lines(numlines).rho = rho(rbin); 
            end 
        end 
    end 
end

function detect_point()
    [ha, pos] = tight_subplot(1, 2, [0.05, 0.05]);
    image_data = imread('images/test_pattern_with_single_pixel.tif');
    axes(ha(1)), imshow(image_data);
    w = [-1 -1 -1; -1 8 -1; -1 -1 -1]; 
    g = abs(imfilter(double(image_data), w)); 
    T = max(g(:)); 
    g = g >= T; 
    se = strel('disk', 3);  
    g = imdilate(g, se); 
    axes(ha(2)),imshow(g);
end
% detect_point


function detect_line()
    f = imread('images/wirebond_mask.tif');   
    [ha, pos] = tight_subplot(1, 3, [0.05, 0.05]);
    w = [-1 -1 -1; 2 2 2; -1 -1 -1];       % Горизонтальные
    w(:,:,2)= [-1 -1 2; -1 2 -1; 2 -1 -1]; % 45
    % w(:,:,3)= [-1 2 -1; -1 2 -1; -1 2 -1]; % Вертикальные
    w(:,:,3)= [2 -1 -1; -1 2 -1; -1 -1 2]; % -45

    for i = 1:3
        g = abs(imfilter(double(f), w(:, :, i)));
        disp(w(:, :, i))
        T = max(g(:)); 
        g = g >= T;
        figure;
        axes(ha(i)), imshow(imdilate(g, strel('disk', 3))); 
    end
end

% detect_line

function test_edge_filters()
    image_data = imread('images/building.tif')

    figure, [ha, pos] = tight_subplot(1, 3, [0.02, 0.02]);
    [sobel_def, t] = edge(image_data, 'sobel');
    axes(ha(1)), imshow(sobel_def); 
    
    [log_def, t] = edge(image_data, 'log'); 
    axes(ha(2)), imshow(log_def); 

    [canny_def, t] = edge(image_data, 'canny'); 
    axes(ha(3)), imshow(canny_def); 
    
    figure, [ha, pos] = tight_subplot(1, 3, [0.02, 0.02]);   
    [sobel_custom, t] = edge(image_data, 'sobel', 0.05);
    axes(ha(1)), imshow(sobel_custom); 
    
    [log_custom, t] = edge(image_data, 'log', 0.003, 2.25); 
    axes(ha(2)), imshow(log_custom); 

    [canny_custom, t] = edge(image_data, 'canny', [0.04, 0.10], 1.5); 
    axes(ha(3)), imshow(canny_custom); 
end

% test_edge_filters
function hough_filter_2()
    image_data = imread('images/building.tif');
    output_image = image_data;   
    f_bin = edge(imrotate(image_data,50,'crop'), 'canny');  
    [H, theta, rho] = hough(f_bin);  
    P  = houghpeaks(H,2);
    imshow(H,[],'XData',theta,'YData',rho,'InitialMagnification','fit');
    xlabel('\theta'), ylabel('\rho');
    axis on, axis normal, hold on;
    plot(theta(P(:,2)),rho(P(:,1)),'s','color','white');

    % disp(peaks)
    % r = peaks(:, 1); 
    % c = peaks(:, 2); 
    % lines = houghlines(f_bin, theta, rho, [r c]); 
    % for k = 1:length(lines) 
    %     xy = [lines(k).point1; lines(k).point2]; 
    %     output_image = insertShape(output_image, 'Line', [xy(1,1), 
    %     xy(1,2), xy(2,1), xy(2,2)], 'Color', 'white', 'LineWidth', 2); 
    % end 
    % imshow(output_image);
end

function hough_filter()
    rotI = imrotate(imread('images/circuit.tif'), 45, 'crop');
    figure, [ha, pos] = tight_subplot(1, 3, [0.02, 0.02]);
    % Show original image
    axes(ha(1)), imshow(rotI);
    
    BW = edge(rotI,'canny');
    % Show canny outline
    axes(ha(2)), imshow(BW);

    [H,T,R] = hough(BW);
    P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    x = T(P(:,2)); y = R(P(:,1));
    
    lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
    % Show Hough lines and peaks
    axes(ha(3)), imshow(rotI), hold on
    
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
    imshow(H,[],'XData',T,'YData',R, 'InitialMagnification','fit');        
    xlabel('\theta'), ylabel('\rho');
    axis on, axis normal, hold on;
    plot(x,y,'s','color','white');
end

% hough_filter

function step_filter
    figure, [ha, pos] = tight_subplot(1, 2, [0.02, 0.02]);
    f = imread('images/scanned-text-grayscale.tif');   
    axes(ha(1)), imshow(f);
    T2 = graythresh(f); 
    disp(T2 * 255); 
    g = f >= T2 * 255; 
    axes(ha(2)), imshow(~g); 
    
end

% step_filter

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
    
    figure, [ha, pos] = tight_subplot(1, 2, [0.02, 0.02]);

    f = imread('images/defective_weld.tif');   
    axes(ha(1)), imshow(f);

    [g, NR, SI, TI] = regiongrow(f, 255, 65);  
    
    axes(ha(2)), imshow(g); 
end

% segment_grow

function split_image()
    figure, [ha, pos] = tight_subplot(2, 3, [0.02, 0.02]);
    f = imread('images/cygnusloop_Xray_original.tif');
    axes(ha(1)), imshow(f);
    start_axes = 2;
    block_sizes = [2, 4, 8, 16, 32];
    for i=1:5
        g = splitmerge(f, block_sizes(i), @predicate);  
        axes(ha(start_axes)), imshow(g);
        start_axes = start_axes + 1;
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

% split_image


function watershed_default
    figure, [ha, pos] = tight_subplot(1, 2, [0.02, 0.02]);
    f = imread('images/binary-dowel-image.tif');
    axes(ha(1)), imshow(f);
    gc = ~f; 
    D = bwdist(gc); 
    L = watershed(-D); 
    w = L == 0; 
    g2 = gc & ~w; 
    axes(ha(2)), imshow(g2);
end

% watershed_default

function watershed_gradient
    figure, [ha, pos] = tight_subplot(1, 2, [0.02, 0.02]);
    f = imread('images/small-blobs.tif');
    axes(ha(1)), imshow(f);
    h = fspecial('sobel');  
    fd = double(f);  
    g = sqrt(imfilter(fd,h, 'replicate') .^2 + imfilter(fd, h', 'replicate') .^2);  
    
    L = watershed(g);  
    wr = L == 0;  
    axes(ha(2)), imshow(wr);
end

% watershed_gradient

function watershed_markers
    figure, [ha, pos] = tight_subplot(1, 2, [0.02, 0.02]);
    f = imread('images/gel-image.tif');
    axes(ha(1)), imshow(f);
    
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
    axes(ha(2)), imshow(f2); 
end

watershed_markers