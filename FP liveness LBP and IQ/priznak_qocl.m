

function [Q_OCL] = priznak_qocl(otisk, v_vyska, v_sirka, maska_pole)

    k_mat = zeros(length(v_vyska) - 1, length(v_sirka) - 1);
    q = 5;
    sobelX = [-1 0 1; -2 0 2; -1 0 1];
    sobelY = sobelX';

    for i = 1:length(v_vyska) - 1
        for j = 1:length(v_sirka) - 1

            if maska_pole(i, j) == 1;

                blok = otisk(v_vyska(i):v_vyska(i+1) - 1, v_sirka(j):v_sirka(j+1) - 1);

                GX = conv2(blok, sobelX, 'same');
                GY = conv2(blok, sobelY, 'same');

                J = cov(GX, GY);

                lambda1 = ((J(1,1) + J(2,2)) + sqrt(((J(1,1) + J(2,2)) ^ 2) - 4 * det(J))) / 2;
                lambda2 = ((J(1,1) + J(2,2)) - sqrt(((J(1,1) + J(2,2)) ^ 2) - 4 * det(J))) / 2;

                k_mat(i, j) = ((lambda1 - lambda2) ^ 2) / ((lambda1 + lambda2) ^ 2);
            else
            end
        end
    end

    pom_stred = regionprops(maska_pole,'centroid');
    lc = round(pom_stred.Centroid);

    [x, y] = meshgrid(1:size(maska_pole, 2), 1:size(maska_pole, 1));
    Q_OCL = sum(sum(k_mat .* exp(-(((lc(2) - y) .^ 2) + ((lc(1) - x) .^ 2)) / (2 * q)))) / nnz(maska_pole);

end