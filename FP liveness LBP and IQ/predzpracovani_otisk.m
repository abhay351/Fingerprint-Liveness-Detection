

function [obraz_norm, maska, otisk] = predzpracovani_otisk(obraz)

    obraz_norm = imadjust(obraz);

    prah = graythresh(obraz_norm);
    segmentace_maska = zeros(size(obraz));
    segmentace_maska(imclose((obraz_norm < prah), strel('disk', 10))) = 1;
    regiony = bwconncomp(segmentace_maska);
    velikosti = zeros(1, length(regiony.PixelIdxList));
    for i = 1:length(regiony.PixelIdxList)
        velikosti(i) = length(regiony.PixelIdxList{i});
    end
    [~, id_region] = max(velikosti);
    segmentace_maska = zeros(size(obraz));

    segmentace_maska(regiony.PixelIdxList{id_region}) = 1;

    elipsa = regionprops(segmentace_maska, 'Orientation', 'MajorAxisLength', ...
        'MinorAxisLength', 'Eccentricity', 'Centroid');

    phi = linspace(0, 2 * pi, 3000);
    cosphi = cos(phi);
    sinphi = sin(phi);

    stredX= elipsa.Centroid(1);
    stredY = elipsa.Centroid(2);

    a = elipsa.MajorAxisLength / 2;
    b = elipsa.MinorAxisLength / 2;

    theta = pi * elipsa.Orientation / 180;
    R = [cos(theta), sin(theta); -sin(theta), cos(theta)];
    xy = [a * cosphi; b * sinphi];
    xy = R * xy;
    x = uint32(xy(1, :) + stredX);
    y = uint32(xy(2, :) + stredY);

    x = min(x, size(obraz_norm, 2));
    y = min(y, size(obraz_norm, 1));
    x = max(x, 1);
    y = max(y, 1);

    souradnice = sub2ind(size(obraz_norm), y, x);
    elipsa_maska = zeros(size(obraz));
    elipsa_maska(souradnice) = 1;
    elipsa_maska = imfill(elipsa_maska);

    [indXY] = find(elipsa_maska == 1);
    elipsa_otisk = zeros(size(obraz_norm));
    elipsa_otisk(indXY) = obraz_norm(indXY);

    prah_delka = elipsa.MajorAxisLength * 0.2;
    if elipsa.MajorAxisLength - elipsa.MinorAxisLength > prah_delka

        if elipsa.Orientation >= 0
            uhel_otoc = 90 - elipsa.Orientation;
        else    
            uhel_otoc = -90 + abs(elipsa.Orientation);
        end

    else
        uhel_otoc = 0;
    end

    elipsa_otisk = imrotate(elipsa_otisk, uhel_otoc);
    elipsa_maska = imrotate(elipsa_maska, uhel_otoc);

    [Y_index, X_index, ~] = find(elipsa_maska == 1);

    elipsa_X_min = min(X_index);
    elipsa_X_max = max(X_index);
    elipsa_Y_min = min(Y_index);
    elipsa_Y_max = max(Y_index);

    maska_vyrez = elipsa_maska(elipsa_Y_min:elipsa_Y_max, elipsa_X_min:elipsa_X_max);
    otisk_vyrez = elipsa_otisk(elipsa_Y_min:elipsa_Y_max, elipsa_X_min:elipsa_X_max);

    elipsa_X_vel = size(maska_vyrez, 2);
    elipsa_Y_vel = size(maska_vyrez, 1);

    if mod(size(obraz, 2), 2) == 1
        obr_stred_X = floor(size(obraz, 2)/2) + 1;
        obr_delka_X = obr_stred_X - 1;
    else
        obr_stred_X = size(obraz, 2)/2;
        obr_delka_X = obr_stred_X - 1;
    end

    if mod(size(obraz, 1), 2) == 1
        obr_stred_Y = floor(size(obraz, 1)/2) + 1;
        obr_delka_Y = obr_stred_Y - 1;
    else
        obr_stred_Y = size(obraz, 1)/2;
        obr_delka_Y = obr_stred_Y - 1;
    end

    if elipsa_X_vel > size(obraz, 2)

        if mod(elipsa_X_vel, 2) == 1    
            vyrez_stred_X = floor(elipsa_X_vel/2) + 1;
            elipsa_X_min = vyrez_stred_X - obr_delka_X;
            elipsa_X_max = vyrez_stred_X + obr_delka_X;
            delta_X = 0;
        else                            
            vyrez_stred_X = elipsa_X_vel/2;
            elipsa_X_min = vyrez_stred_X - obr_delka_X;
            elipsa_X_max = vyrez_stred_X + obr_delka_X + 1;
            delta_X = 0;
        end

    elseif elipsa_X_vel == size(obraz, 2)
        elipsa_X_min = 1;
        elipsa_X_max = size(maska_vyrez, 2);
        delta_X = 0;
    else    
        elipsa_X_min = 1;
        elipsa_X_max = size(maska_vyrez, 2);
        delta_X = floor((size(obraz, 2) - elipsa_X_vel)/2);    
    end

    if elipsa_Y_vel > size(obraz, 1)

        if mod(elipsa_Y_vel, 2) == 1   
            vyrez_stred_Y = floor(elipsa_Y_vel/2) + 1;
            elipsa_Y_min = vyrez_stred_Y - obr_delka_Y;
            elipsa_Y_max = vyrez_stred_Y + obr_delka_Y;
            delta_Y = 0;
        else                            
            vyrez_stred_Y = elipsa_Y_vel/2;
            elipsa_Y_min = vyrez_stred_Y - obr_delka_Y;
            elipsa_Y_max = vyrez_stred_Y + obr_delka_Y + 1;
            delta_Y = 0;
        end
    elseif elipsa_Y_vel == size(obraz, 1)
        elipsa_Y_min = 1;
        elipsa_Y_max = size(maska_vyrez, 1);
        delta_Y = 0;
    else    
        elipsa_Y_min = 1;
        elipsa_Y_max = size(maska_vyrez, 1);
        delta_Y = floor((size(obraz, 1) - elipsa_Y_vel)/2);
    end

    maska_vyrez2 = maska_vyrez(elipsa_Y_min:elipsa_Y_max, elipsa_X_min:elipsa_X_max);
    otisk_vyrez2 = otisk_vyrez(elipsa_Y_min:elipsa_Y_max, elipsa_X_min:elipsa_X_max);

    maska_pom = zeros(size(obraz, 1), size(obraz, 2));
    otisk_pom = maska_pom;

    maska_pom(1:size(maska_vyrez2, 1), 1:size(maska_vyrez2, 2)) = maska_vyrez2;
    otisk_pom(1:size(maska_vyrez2, 1), 1:size(maska_vyrez2, 2)) = otisk_vyrez2;

    maska = circshift(maska_pom,[delta_Y, delta_X]);
    otisk = circshift(otisk_pom,[delta_Y, delta_X]);

end