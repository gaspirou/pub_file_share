clear; clc; clf;

load InputsFromFascicles.mat

alpha = 1;
color_1 = [0 0 0];
color_2 = [0 0 0];
color_3 = [0 0 0];
line_width = 1.5;

subplot(3, 1, 1)
h1 = histogram(inputs_from_fascicles, 'BinWidth', 5, 'FaceColor', color_1, 'FaceAlpha', alpha,...
    'EdgeColor', color_1, 'LineWidth', line_width);
hold on
title('From Fascicle')

xlim([0 300])
set(gca,'TickDir','out')
xticks(0:10:300)
set(gca, 'XTickLabel', {'', '', '20','', '40', '', '60', '', '80', '', '100', '', '120', '', '140', '', '160', '', '180', '', '200', '', '220', '', '240', '', '260', '', '280', '', '300',})
set(gca, 'linewidth', 1.5)
set(gca, 'FontSize', 18)
box off
ylabel({'Number of Inputs'})
ylim([0 10])
yticks(0:2:10)

subplot(3, 1, 2)
h3 = histogram(myelinated_NotFromFascicle, 'BinWidth', 5, 'FaceColor', color_3, 'FaceAlpha', alpha,...
    'EdgeColor', color_3, 'LineWidth', line_width);
title('Myelinated')

xlim([0 300])
set(gca,'TickDir','out')
xticks(0:10:300)
set(gca, 'XTickLabel', {'', '', '20','', '40', '', '60', '', '80', '', '100', '', '120', '', '140', '', '160', '', '180', '', '200', '', '220', '', '240', '', '260', '', '280', '', '300',})
set(gca, 'linewidth', 1.5)
set(gca, 'FontSize', 18)
box off
ylabel({'Number of Inputs'})
ylim([0 10])
yticks(0:2:10)

subplot(3, 1, 3)
h2 = histogram(unmyelinated, 'BinWidth', 5, 'FaceColor', color_2, 'FaceAlpha', alpha,...
    'EdgeColor', color_2, 'LineWidth', line_width);
title('Unmyelinated')


xlim([0 300])
set(gca,'TickDir','out')
xticks(0:10:300)
set(gca, 'XTickLabel', {'', '', '20','', '40', '', '60', '', '80', '', '100', '', '120', '', '140', '', '160', '', '180', '', '200', '', '220', '', '240', '', '260', '', '280', '', '300',})
set(gca, 'linewidth', 1.5)
set(gca, 'FontSize', 18)
box off
xlabel({'Input Apposed Surface Area (\mum^2)'})
ylabel({'Number of Inputs'})
ylim([0 10])
yticks(0:2:10)
hold on


set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 12 8]);
filename = ['InputsFromFascicles_Histogram_',datestr(now, 'dd_mmm_yyyy'),'.png'];
print(gcf, filename,'-dpng','-r500'); 