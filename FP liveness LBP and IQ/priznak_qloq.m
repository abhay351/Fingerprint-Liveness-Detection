

function [Q_LOQ] = priznak_qloq(pole_orientace, maska_pole)

    LOQ = zeros(size(pole_orientace, 1), size(pole_orientace, 2));
    LOQS = LOQ;

    for i = 1:size(pole_orientace, 1)
        for j = 1:size(pole_orientace, 2)

            if maska_pole(i,j) == 1;

                if i == 1 && j == 1

                    blok_pom = pole_orientace(i:i + 1, j:j + 1);
                    okoli = 3;

                elseif i == 1 && j == size(pole_orientace, 2)

                    blok_pom = pole_orientace(i:i + 1, j - 1:j);
                    okoli = 3;

                elseif i == size(pole_orientace, 1) && j == 1

                    blok_pom = pole_orientace(i - 1:i, j:j + 1);
                    okoli = 3;

                elseif i == size(pole_orientace, 1) && j == size(pole_orientace, 2)

                    blok_pom = pole_orientace(i - 1:i, j - 1:j);
                    okoli = 3;

                elseif i == 1 && j > 1 && j < size(pole_orientace, 2)

                    blok_pom = pole_orientace(i:i + 1, j - 1:j + 1);
                    okoli = 5;

                elseif i == size(pole_orientace, 1) && j > 1 && j < size(pole_orientace, 2)

                    blok_pom = pole_orientace(i - 1:i, j - 1:j + 1);
                    okoli = 5;

                elseif i > 1 && i < size(pole_orientace, 1) && j == 1

                    blok_pom = pole_orientace(i - 1:i + 1, j:j + 1);
                    okoli = 5;

                elseif i > 1 && i < size(pole_orientace, 1) && j == size(pole_orientace, 2)

                    blok_pom = pole_orientace(i - 1:i + 1, j - 1 : j);
                    okoli = 5;

                else

                    blok_pom = pole_orientace(i - 1:i + 1, j - 1:j + 1);
                    okoli = 8;

                end

                pz = find(isnan(blok_pom));
                odpocet = length(pz);
                blok_pom(pz) = blok_pom(2 ,2);

                LOQ(i, j) = sum(sum(abs(blok_pom(2, 2) - blok_pom))) / (okoli - odpocet);

                if rad2deg(LOQ(i, j)) <= 8
                    LOQS(i, j) = 0;
                else
                    LOQS(i, j) = (rad2deg(LOQ(i, j)) - 8) / (90 - 8);
                end
            else
            end

        end
    end
    poz_GOQS = find(maska_pole == 1);
    Q_LOQ = sum(sum(LOQS(poz_GOQS))) / length(poz_GOQS);

end