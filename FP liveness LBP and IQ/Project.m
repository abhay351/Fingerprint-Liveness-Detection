

function program()

    close all;

    screen_size = get(0, 'ScreenSize');
    
    figure('NumberTitle', 'off',...
           'MenuBar', 'none',...
           'Name', 'FINGERPRINT LIVENESS USING LBP & IMAGE QUALITY ',...
           'Resize', 'off',...
           'Position', [(1 / 6) * screen_size(3), (1 / 10) * screen_size(4), (2 / 7) * screen_size(3), (45 / 120) * screen_size(3)]);
    
    axes('Units', 'pixels',...
         'XTickLabel', '',...
         'YTickLabel', '',...
         'XColor', 'w',...
         'YColor', 'w',...
         'Position', [(1 / 60) * screen_size(3), (8 / 100) * screen_size(3), (53 / 210) * screen_size(3), (1 / 4) * screen_size(3)]);
    
    uicontrol('Style', 'pushbutton',...
              'Units', 'pixels',...
              'String', 'LIVEDET DATASET',...
              'Position', [(1 / 60) * screen_size(3), (34 / 100) * screen_size(3), (1 / 15) * screen_size(3), (1 / 50) * screen_size(3)],...
              'Callback', @algoritmus); 
    uicontrol('Style', 'edit',...
              'HorizontalAlignment', 'left',...
              'Enable', 'off',...
              'Position', [(1 / 11) * screen_size(3), (1091 / 3200) * screen_size(3), (71 / 400) * screen_size(3), (1 / 55) * screen_size(3)],...
              'Tag', 'cesta_edit');
    
    uicontrol('Style', 'text',...
              'Tag', 'hodnoceni_text',...
              'Units', 'pixels',...
              'FontSize', 40,...
              'String', '',...
              'Visible', 'off',...
              'Position', [(1 / 60) * screen_size(3), (3 / 200) * screen_size(3), (53 / 210) * screen_size(3), (5 / 90) * screen_size(3)]);
end