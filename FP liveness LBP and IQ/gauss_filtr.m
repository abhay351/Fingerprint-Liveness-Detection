

function obr_gaussfilter = gauss_filtr(obraz_norm)
    
   
    vel_maska = [3, 3];
    sigma = 0.5;
    
   
    h = fspecial('gaussian', vel_maska, sigma);
    obr_gaussfilter = imfilter(obraz_norm, h);

end