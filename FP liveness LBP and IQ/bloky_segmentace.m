

function [maska_pole] = bloky_segmentace(v_vyska, v_sirka, maska)

  
    maska_pole = zeros(length(v_vyska) - 1, length(v_sirka) - 1);

   
    for i = 1:length(v_vyska) - 1
        for j = 1:length(v_sirka) - 1

            pom_maska = sum(sum(maska(v_vyska(i):v_vyska(i+1) - 1, v_sirka(j):v_sirka(j+1) - 1))) /...
                ((v_vyska(2) - v_vyska(1)) ^ 2);

            if pom_maska > 0.75

                maska_pole(i,j) = 1;   

            else
            end
        end
    end

end