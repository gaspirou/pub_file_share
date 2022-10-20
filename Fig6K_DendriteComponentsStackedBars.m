% Now make stacked bar plots for the dendritic components of ten cells
% Need to read from Excel file targeting selected columns and rows
% 'Dendrite_SA_Breakdown_Test.xlsx' is a subset of cells extracted from Dendrite_SA_Breakdown_copy.xlsx'
clear all;
close all;
clc;
A = readmatrix('Fig6K_Dendrite_SA_Breakdown_Test.xlsx');

% Columns are: 1. Dendritic Hubs, 2. Dendritic Swellings, 3. Distal
% Dendrites, 4. Myelinated Axon, 5. Proximal Dendrite, 6. Soma
%
% First change the ordering of columns to: 1. Proximal Dendrite, 2.
% Dendrite Hubs, 3. Dendrite Swellings, 4. Dendrite Shafts
% Place reordered columns into matrix B
% Place soma areas into matrix C
B = A(:,[5 1 2 3 4 6]);
C = A(:,6);

% Remove columns 4 and 6 from matrix B, and rows 9 and 10 from matrices B and C
%
B(:,6) = []
B(:,5) = []
B(10,:) = []
B(9,:) = []
C(10,:) = []
C(9,:) = []

% Add a row that contains the averages of each compartment across cells
%
numrows = length(B(:,1))
numcols = length(B(1,:))
for i = 1:numcols
    Bisum = sum(B(:,i));
    B(numrows+1, i) = Bisum / numrows
end
    
xlab = categorical({'c02', 'c05', 'c06', 'c09', 'c10', 'c11', 'c13', 'c17', 'c30', 'Avg'});
xlab = reordercats(xlab,{'c02', 'c05', 'c06', 'c09', 'c10', 'c11', 'c13', 'c17', 'c30', 'Avg'})

% Plot the stacked bar graph
%

b = bar(xlab, B, 'stacked', 'EdgeColor', 'k', 'LineWidth', 1.5)
b(1).FaceColor = 'k'
b(2).FaceColor = [0.9 0.9 0.9]
b(3).FaceColor = [0.5 0.5 0.5]
b(4).FaceColor = [0.75 0.75 0.75]
ax1 = gca
p = ax1.Position;               % Note this is also the InnerPosition
op = ax1.OuterPosition;         % Obtain values for outer frame of figure
ti = ax1.TightInset;
ax1.Position = [p(1)+0.06 p(2)+0.02 p(3)-0.1 p(4)]
pnew = ax1.Position;
xlabel('GBC Cell Number')
ylabel({'Surface Area (\mum^{2})';'by Dendrite Compartment'})
ax1.FontSize = 16;
ax1.XTickMode = 'manual'
ax1.YTickMode = 'manual'
ax1.YLim = [0 4000];
ax1.YTick = [0:500:4000];
ax1.TickDir = 'out'
ax1.YMinorTick = 'on'
ax1.YAxis.MinorTickValues = [250:250:3750];
ax1.LineWidth = 2;
ax1.Box = 'off';
ax1.LabelFontSizeMultiplier = 1.4
hold on;

% Draw a y-axis at right scaled to 100% for the Average histogram
%

AvgTot = sum(B(10,:))
pversh = 0.0   % Set vertical shift of right y-axis to line up with left y-axis
pinset1 = [pnew(1)+pnew(3) pnew(2)+pversh pnew(3)-(pnew(3)-0.001) (pnew(4)-pversh)*(AvgTot/4000)];
AvgYAxis = axes('Parent', gcf, 'Position', pinset1)
AvgYAxis = gca
opavg = AvgYAxis.OuterPosition; % Just to check the values
tiavg = AvgYAxis.TightInset;    % Just to check the values
AvgYAxis.YAxisLocation = 'right'
AvgYAxis.TickDir = 'out'
AvgYAxis.YLim = [0 AvgTot];
AvgYAxis.YTick = [0:AvgTot/4:AvgTot];
AvgYAxis.YTickLabel = [0 25 50 75 100];
AvgYAxis.FontSize = 18;
AvgYAxis.LineWidth = 2;
ylabel(AvgYAxis, 'Percent of Avg');
AvgYAxis.LabelFontSizeMultiplier = 1.4

% Export the figure
%
f = gcf
exportgraphics(f, 'HistogramDendriteCompartments.jpg', 'Resolution', 300)

