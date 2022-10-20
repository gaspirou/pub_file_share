clear; clc; clf;

load Fig2C_AllInputs.mat

histogram(inputs, 'BinWidth', 5, 'FaceColor', [0 0 0], 'FaceAlpha', 1)
xlim([0 300])
set(gca,'TickDir','out')
xticks(0:10:300)
set(gca, 'XTickLabel', {'', '', '20','', '40', '', '60', '', '80', '', '100', '', '120', '', '140', '', '160', '', '180', '', '200', '', '220', '', '240', '', '260', '', '280', '', '300',})
set(gca, 'linewidth', 1.5)
set(gca, 'FontSize', 18)
box off
xlabel({'Input ASA (\mum^2)'})
ylabel({'Number of Inputs'})

hold on


set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 12 8]);
print(gcf,'InputASA_Histogram_June23.png','-dpng','-r500');