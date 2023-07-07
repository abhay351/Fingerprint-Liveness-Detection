

function algoritmus(varargin)

    [jmeno, cesta] = uigetfile({'*.tif; *.bmp', 'Soubor otisku (*.tif, *.bmp)'}, 'Naèíst otisk');
    
    if jmeno ~= 0
        
        popisek = findobj('Tag', 'hodnoceni_text');
        
        set(findobj('Tag', 'cesta_edit'), 'String', [cesta jmeno]);
        set(popisek, 'Visible', 'on', 'BackgroundColor', 'w', 'String', 'Analyzing...');
        
        obraz = imread([cesta jmeno]);
        imshow(obraz, [], 'Parent', gca);
        
        pause(0.1);
      
        %% Algoritmus
        obraz = im2double(obraz);
        [obraz_norm, maska, otisk] = predzpracovani_otisk(obraz);
        [v_vyska, v_sirka] = bloky_deleni(maska);
        [maska_pole] = bloky_segmentace(v_vyska, v_sirka, maska);
        [pole_orientace] = orientace(otisk, v_sirka, v_vyska, maska_pole);
        obr_gaussfilter = gauss_filtr(obraz_norm);
        
        TestVstup = zeros(16, 1);
        
        [FR_MSE, FR_PSNR, FR_SNR, FR_RAMD, FR_TED, FR_SME, FR_SPE,...
        FR_GME, FR_GPE] = priznaky_FR(obraz_norm, obr_gaussfilter, 10);
        
        TestVstup(1:9) = [FR_MSE, FR_PSNR, FR_SNR, FR_RAMD, FR_TED,...
            FR_SME, FR_SPE, FR_GME, FR_GPE]';
        
        TestVstup(10) = priznak_gl1(otisk, maska);
        TestVstup(11) = priznak_gl2(otisk, maska);
        TestVstup(12) = priznak_qe(otisk);
        TestVstup(13) = priznak_qocl(otisk, v_vyska, v_sirka, maska_pole);
        TestVstup(14) = priznak_qloq(pole_orientace, maska_pole);
        TestVstup(15) = priznak_qmean(maska, otisk);
        TestVstup(16) = priznak_qstd(maska, otisk);
        
        if size(obraz, 1) < 480
            load 'neuronka_biometrika.mat'
        elseif size(obraz, 1) == 480
            load 'neuronka_crossmatch.mat'
        else
            load 'neuronka_identix.mat'
        end
        
        stav = net(TestVstup);
        stav = round(stav); 
        
        if stav == 1
            set(popisek, 'Visible', 'on', 'BackgroundColor', 'g', 'String', 'True');
            
        else
            set(popisek, 'Visible', 'on', 'BackgroundColor', 'r', 'String', 'False');
        end
    end
end