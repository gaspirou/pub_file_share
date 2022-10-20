clear; clc;

load Fig5C-D_fascicle2cell.mat

subplot(1,4,[2 3 4])

ba = bar(axons2cell,'stacked', 'BarWidth', 1, 'LineWidth', 1);
%Large and from fascicle
ba(1).FaceColor = 'flat';
ba(1).CData = [0 0 0];
%small and from fascicle
ba(2).FaceColor = 'flat';
ba(2).CData = [1 0 0];
%large and not from fasicle
ba(3).FaceColor = 'flat';
ba(3).FaceAlpha = 0.0;
ba(3).CData = [0 0 0];
xticks([1:1:21])
set(gca,'xticklabel', cell_numbers);

legend('Large - Myelinated - From Fascicle', 'Small - Myelinated - From Fascicle', 'Large - Myelinated - Not From Fascicle')
xlabel('Cell Number')
ylabel('Number of Terminals')
set(gca,'TickDir','out');
set(gca, 'linewidth', 1.5)
set(gca, 'FontSize', 18)
box off
ylim([0 15])
subplot(1,5,1)
sum = sum(axons2cell, 2);
h1 = histogram(sum, 'BinWidth', 0.999, 'FaceColor', [0 0 0], 'FaceAlpha', 1,...
    'EdgeColor', [0 0 0]);

box off
set(gca, 'view', [90 -90])
set(gca,'TickDir','out');
set(gca, 'linewidth', 1.5)
set(gca, 'FontSize', 18)
ylabel('Number of Cells')
xlabel('Number of Terminals')
xlim([0 15])
xticks(0:5:15)
ylim([0 10])

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 16 8]);
filename = ['Fascicle2Cell_Convergence_',datestr(now, 'dd_mmm_yyyy'),'.png'];
print(gcf, filename,'-dpng','-r500');

%%%%%%%%%%%%%%%%%%%
%Sorted Bar chart
%%%%%%%%%%%%%%%%%%%
clear; clc; clf;

load fascicle2cell.mat

subplot(1,4,[2 3 4])

ba = bar(axons2cell_sorted,'stacked', 'BarWidth', 1, 'LineWidth', 1);
%Large and from fascicle
ba(1).FaceColor = 'flat';
ba(1).CData = [0 0 0];
%small and from fascicle
ba(2).FaceColor = 'flat';
ba(2).CData = [1 0 0];
%large and not from fasicle
ba(3).FaceColor = 'flat';
ba(3).FaceAlpha = 0.0;
ba(3).CData = [0 0 0];
xticks([1:1:21])
set(gca,'xticklabel', cell_numbers_sorted);

legend('Large - Myelinated - From Fascicle', 'Small - Myelinated - From Fascicle', 'Large - Myelinated - Not From Fascicle')
xlabel('Cell Number')
ylabel('Number of Terminals')
set(gca,'TickDir','out');
set(gca, 'linewidth', 1.5)
set(gca, 'FontSize', 18)
box off
ylim([0 15])
subplot(1,5,1)
sum = sum(axons2cell_sorted, 2);
h1 = histogram(sum, 'BinWidth', 0.999, 'FaceColor', [0 0 0], 'FaceAlpha', 1,...
    'EdgeColor', [0 0 0]);

box off
set(gca, 'view', [90 -90])
set(gca,'TickDir','out');
set(gca, 'linewidth', 1.5)
set(gca, 'FontSize', 18)
ylabel('Number of Cells')
xlabel('Number of Terminals')
xlim([0 15])
xticks(0:5:15)
ylim([0 10])

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 16 8]);
filename = ['Fascicle2Cell_Sorted_Convergence_',datestr(now, 'dd_mmm_yyyy'),'.png'];
print(gcf, filename,'-dpng','-r500');

%%%
%Second Fig
%%%

clear; clc;

load fascicle2cell.mat

subplot(1,4,[2 3 4])

bar(relative_freq, 'k', 'BarWidth', 1);

xticks([1:1:31])
set(gca,'xticklabel', fascicle_labels);

xlabel('Fascicle Label')
ylabel('Number of Terminals / Axons in Fascicle')
set(gca,'TickDir','out');
set(gca, 'linewidth', 1.5)
set(gca, 'FontSize', 18)
ylim([0 1])
box off
subplot(1,5,1)

h1 = histogram(relative_freq, 'BinWidth', 0.05, 'FaceColor', [0 0 0], 'FaceAlpha', 1,...
    'EdgeColor', [0 0 0]);

box off
set(gca, 'view', [90 -90])
set(gca,'TickDir','out');
set(gca, 'linewidth', 1.5)
set(gca, 'FontSize', 18)
ylabel('Number of Fascicles')
xlabel('Number of Terminals / Axons in Fascicle')
xlim([0 1])
ylim([0 15])

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 16 8]);
filename = ['FascicleAxonFreq_Convergence_',datestr(now, 'dd_mmm_yyyy'),'.png'];
print(gcf, filename,'-dpng','-r500');

%%%
%Third Fig
%%%

clear; clc; clf;

load fascicle2cell.mat

figure;
yyaxis left
bar(sorted_freq, 'k', 'BarWidth', 1);
ax = gca;
xticks([1:1:31])
set(ax,'xticklabel', sorted_fascicle_labels);
yticks([0:2:20])
xlabel(ax, 'Fascicle Label')
ylabel(ax, 'Number of Terminals in Volume')
set(ax,'TickDir','out');
set(ax, 'linewidth', 1.5)
set(ax, 'FontSize', 18)
ylim([0 20])
box off
yyaxis right;
b = scatter([1:1:31], sorted_fascicle_axon_count, 120, 'r','filled');
ylabel(ax, 'Number of Axons in Fascicle')
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'r';

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 16 8]);
filename = ['NotNorm_FascicleAxonFreq_Convergence_',datestr(now, 'dd_mmm_yyyy'),'.png'];
print(gcf, filename,'-dpng','-r500');


%%%
%By Major Fascicle
%%%

clear; clc; clf;

load fascicle2cell.mat

figure;
yyaxis left
ba = bar(major_fascicle_axon_breakdown,'stacked', 'BarWidth', 1, 'LineWidth', 2);

for i = 1:8
    %myColors = round(rand(3,3),1);
    %colorSet = [colorSet myColors];
    ba(i).FaceColor = 'flat';
    ba(i).FaceAlpha = 0.0;
    ba(i).CData = [0 0 0];
 end

ax = gca;
xticks([1:1:9])
set(ax,'xticklabel', sorted_major_fascicle_labels);
yticks([0:50:300])
xlabel(ax, 'Fascicle Label')
ylabel(ax, 'Number of Axons in Fascicle')
set(ax,'TickDir','out');
set(ax, 'linewidth', 1.5)
set(ax, 'FontSize', 18)
ylim([0 300])
box off
yyaxis right;
b = scatter([1:1:9], sorted_major_terminalcount, 120, 'r','filled');
ylabel(ax, 'Number of Terminals in Volume')
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'r';

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 12 8]);
filename = ['Norm_MajorFascicleAxonFreq_Convergence_',datestr(now, 'dd_mmm_yyyy'),'.png'];
print(gcf, filename,'-dpng','-r500');