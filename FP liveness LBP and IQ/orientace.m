

function [pole_orientace] = orientace(otisk, v_sirka, v_vyska, maska_pole)

    pole_orientace = ones(length(v_vyska) - 1, length(v_sirka) - 1) * NaN;
    sobelX = [-1 0 1; -2 0 2; -1 0 1];
    sobelY = sobelX';

    for i = 1:length(v_vyska) - 1
        for j = 1:length(v_sirka) - 1

            if maska_pole(i, j) == 1

                blok = otisk(v_vyska(i):v_vyska(i+1) - 1, v_sirka(j):v_sirka(j+1) - 1);

                GX = conv2(blok, sobelX, 'same');
                GY = conv2(blok, sobelY, 'same');

                Vx = sum(sum(2 .* GX .* GY));
                Vy = sum(sum(GX .^ 2 - GY .^ 2));

                theta = atan2(Vx, Vy) / 2;
                pole_orientace(i, j) = theta + pi / 2;

                
                if pole_orientace(i, j) >= pi
                    pole_orientace(i, j) = pole_orientace(i, j) - pi;
                else
                end
            else
            end

        end
    end

end