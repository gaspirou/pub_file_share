clear; clc;

load Fig1F_synapse_data.mat

%subplot(1,4,[2 3 4])
figure(1)
x = 1:1:12;
a = scatter(ASAs, densities, 80,'MarkerFaceColor', [0 0 0],...
    'LineWidth', 1, 'MarkerEdgeColor', [0 0 0]);
hold on;
line = lsline;
R = corrcoef(ASAs, densities);
R_squared = R(1, 2) * R(1, 2)
s = strcat('R^2 = ', num2str(R_squared))
text(0.8,0.9,s,'Units','normalized', 'FontSize',14)
line.LineWidth = 3;
line.Color = 'r';
xlim([0 300])
ylim([0 1])
xlabel('ASA (\mum^2)')
ylabel('Synapse Density (synapses / \mum^2)')
set(gca,'TickDir','out');
set(gca, 'linewidth', 1.5)
set(gca, 'FontSize', 18)
box off
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 7 5]);
print(gcf,'synapseDensity_lineOnly_June26.png','-dpng','-r500'); 
%subplot(1,5,1)

figure(2)
%add value so histogram bins evenly
histogram(densities, 'FaceColor', [0 0 0], 'FaceAlpha', 1)
box off
set(gca, 'view', [90 -90])
set(gca,'TickDir','out');
set(gca, 'linewidth', 4)
set(gca, 'FontSize', 22)
% ax = gca;
% ax.YAxisLocation = 'right';
ylabel('Count')
xlabel('Synapse Density (synapses / \mum^2)')
xlim([0.5 1])
ylim([0 10])
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 2 5]);
print(gcf,'synapseDensity_HistOnly_June26.png','-dpng','-r500'); 