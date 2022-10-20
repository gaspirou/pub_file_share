% Plot of number of hubs vs number of swellings per cell
% Ten cells selected from dendrite grading to be mostly complete
% Cells 02, 05, 06, 09, 10, 11, 13, 17, 18, 30
%

% Define the matrices for hubs {matrix A} and swellings {matrix B}
% Cell number is indicated in matrix C

clear all;
close all;
clc;

A = [126 51 108 70 60 87 53 40 70 84];  % number of swellings
B = [3 7 6 8 10 4 2 2 9 14];            % number of hubs
C = [2 5 6 9 10 11 13 17 18 30];        % globular bushy cell number

x1 = A;
x2 = A;
y1 = B;
y2 = B;

% nexttile

sz = 60;
scatter (A, B, sz,'k', 'filled')
ax1 = gca;
p = ax1.Position;
xlabel('Number of Swellings','FontSize', 24)
ylabel('Number of Hubs')

% ax1 = gca
ax1.XTickMode = 'manual'
ax1.YTickMode = 'manual'
ax1.TickDir = 'out'
ax1.FontSize = 16;
ax1.XLim = [0 150]
ax1.YLim = [0 15]
ax1.XTick = [0:25:150]
ax1.YTick = [0:5:15]

ax1.XMinorTick = 'on'
ax1.YMinorTick = 'on'
ax1.XAxis.MinorTickValues = [10:10:150]
%ax1.YAxis.MinorTickValues = [1:1:15]
ax1.LabelFontSizeMultiplier = 1.4

hold on;

% Now plot an inset figure on the x-axis
%
pvershh1 = 0.025;           % Vertical shift to align with parent plot
phorshh1 = 0.002;       % Horizontal shift to align with parent plot
pinset1 = [p(1)+phorshh1 p(2)+pvershh1 p(3)-phorshh1 p(4)-0.75];
hi1 = axes('Parent', gcf, 'Position', pinset1)
x2edges = [0:25:150];
histogram(hi1, A, x2edges, 'FaceColor', 'k')
ax2 = gca;
ax2.XTickMode = 'manual'
ax2.YTickMode = 'manual'
ax2.FontSize = 16;
ax2.XLim = [0 150]
ax2.XAxis.Visible = 'off'
ax2.YAxisLocation = 'right'
ax2.YLim = [0 5];
ax2.YTick = [0:5:5]
ax2.YMinorTick = 'on'
ax2.Box = 'off';
ax2.YLabel.String = 'Count';
% ax2.LabelFontSizeMultiplier = 1.4
% 
% Now plot an inset figure on the y-axis
%
pvershh2 = 0.025        % vertical shift for histogram 2 to align with parent plot
pinset2 = [p(1) p(2)+pvershh2 p(3)-0.735 p(4)-pvershh2];
hi2 = axes('Parent', gcf, 'Position', pinset2)
y3edges = [0:2.5:15];
histogram(hi2, B, y3edges, 'FaceColor', 'k', 'Orientation', 'horizontal')
ax3 = gca;
ax2.XTickMode = 'manual'
ax3.XLim = [0 3];
ax3.XTick = [0:3:3];
ax3.XMinorTick = 'on'
ax3.FontSize = 16;
ax3.XAxisLocation = 'top'
ax3.Box = 'off'
ax3.YLim = [0 15];
ax3.YAxis.Visible = 'off'
ax3.XTickLabelRotation = -90;
ax3.XLabel.String = 'Count';
% ax3.LabelFontSizeMultiplier = 1.4
% 
% hold on;
% 
% 
% hold off;

% Export the figure
%
f = gcf
exportgraphics(f, 'SwellingsHubsHistograms.jpg', 'Resolution', 300)
