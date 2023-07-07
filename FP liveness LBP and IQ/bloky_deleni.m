

function [v_vyska, v_sirka] = bloky_deleni(maska)

 
    okno = 16;

  
    stred_obr_ind1 = floor(size(maska, 1) / 2);  
    stred_obr_ind2 = floor(size(maska, 2) / 2);  

   
    if mod(okno, 2) == 1    
        okno_vel = floor(okno / 2);
    else                    
        okno_vel = (okno / 2) - 1;
    end

    v_vyska = [fliplr(stred_obr_ind1 - okno_vel:-okno:1), stred_obr_ind1 + ... 
        floor(okno / 2) + 1:okno:size(maska, 1)];
    v_sirka = [fliplr(stred_obr_ind2 - okno_vel:-okno:1), stred_obr_ind2 + ...
        floor(okno / 2) + 1:okno:size(maska, 2)];

    if size(maska, 1) - v_vyska(end) == okno - 1
        v_vyska = [v_vyska, size(maska, 1)];
    else
    end

    if size(maska, 2) - v_sirka(end) == okno - 1
        v_sirka = [v_sirka, size(maska, 2)];
    else
    end

end