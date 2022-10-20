clear all; close all; clc;

load Fig1E_cellbody_sa.mat;

edges = 900:100:2500;
alpha = 0.5;
color_1 = [0 0 0];
color_2 = [1 0 0];
line_width = 1.5;

[bcs, mcs] = sort('BC', 'MC', cell_types, somatic_sa);

histogram(bcs, edges, 'FaceColor', color_1, 'FaceAlpha', alpha,...
    'EdgeColor', color_1, 'LineWidth', line_width)
hold on
histogram(mcs, edges, 'FaceColor', color_2, 'FaceAlpha', alpha,...
    'EdgeColor', color_2, 'LineWidth', line_width)

box off
set(gca,'TickDir','out');
set(gca, 'linewidth', 1.5)
set(gca, 'FontSize', 18)
% ax1.LabelFontSizeMultiplier = 1.4
set (gca, 'LabelFontSizeMultiplier', 1.3)
ylim([0 8])
ylabel('Number of Cells')
xlabel('Somatic Surface Area (\mum^2)')

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 7 5]);
print(gcf,'cellBodySA_Hist_May22c.png','-dpng','-r500'); 

function [group_1, group_2] = sort(target_1, target_2, types, sas)
  
    group_1 = zeros();
    group_2 = zeros();
    count_1 = 1;
    count_2 = 1;
    
    for i = 1:length(sas)
        
        if types(i, 1) == target_1
            group_1(count_1, 1) = sas(i, 1);
            count_1 = count_1 + 1;
        end
        if types(i, 1) == target_2
            group_2(count_2, 1) = sas(i, 1);
            count_2 = count_2 + 1;
        end
        
    end

end