clear; clc;

load Fig2D_LargeInputs.mat

y = inputs;
y(y==0)=nan;
topLines = [];
bottomLines = [];
cut_off = 195;

for i= 1:1:length(y)
    if y(1,i) > cut_off
        topLines = [topLines, y(:,i)];
    else
        bottomLines = [bottomLines, y(:,i)];
    end
end
subplot(1,6,[3 4 5 6])
x = 1:1:19;
a = line(x, bottomLines, 'Color', [1 0 0], 'LineWidth', 2);
hold on;
a = line(x, topLines, 'Color', [0 0 0], 'LineWidth', 2);

ax1 = gca;
ax1.XLim = [0.5 12.4];
% ax1.YLim = [0 3.0];
ax1.TickDir = 'out'
ax1.XTick = (0:2:12);
% ax1.YTick = (0:0.5:4.0);
% 
% % ax1.YTickLabel = {'2.0','2.5','3.0','3.5'}
ax1.XTickLabel = {'0','2','4','6','8','10','12'}
ax1.XLabel.String = 'Input Number';
ax1.YLabel.String = 'Input ASA (\mum^2)';

ax1.FontSize = 18;
ax1.XMinorTick = 'on'
ax1.XAxis.MinorTickValues = [1:2:11];

set(gca, 'linewidth', 1.5)
box off

subplot(1,5,1)
Largest_Inputs = inputs(1,:);

%add value so histogram bins evenly
Largest_Inputs = [Largest_Inputs 399 -49];
[N, X] = hist(Largest_Inputs,15);
bar(X,N,'facecolor',[0 0 0]);
box off
set(gca, 'view', [90 -90]);
set(gca,'TickDir','out');
set(gca, 'linewidth', 1.5);
set(gca, 'FontSize', 18);
set(gca, 'yMinorTick','on')
ylabel('Number of Cells')
xlabel('ASA of Largest Input (\mum^2)')
xlim([0 300]);
xticks([50 100 150 200 250 300]);
ylim([0 5]);
% yminorticks([1 2 3 4]);

f = gcf
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 12 8]);
% % Now export the plot
% f = gcf
% exportgraphics(f, 'Number_Terminals_vs_Input_ASA.jpg', 'Resolution', 300)
% 
print(gcf,'InputASA_LineChart_June24_Bin25.png','-dpng','-r500'); 
