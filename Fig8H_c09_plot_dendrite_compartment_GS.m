% Plot the surface area and number of inputs for each dendrite compartment
% Testing creation of a .mat file in first section but not used in making plot

clear all;
close all;
clc;

matObj = matfile('Fig8H_c09_dendrite_data.mat', 'Writable', true);
inputs = [13; 24; 69; 148];
node_labels = ["Proximal"; "Hub"; "Swelling"; "Shaft"]
sas = [51.03088058; 257.2046494; 728.7918168; 1654.161555];
matObj.inputs = inputs;
matObj.node_labels = node_labels;
matObj.sas = sas;
save('c09_dendrite_data');

% Matt's code with my modifications:
figure;
yyaxis left
bar(sas, 'k', 'BarWidth', 0.8);
ax = gca;
xticks([1:1:4])
set(ax,'xticklabel', node_labels);
% set(ax,'xticklabel', ['Hub' 'Proximal' 'Shaft' 'Swelling'];

yticks([0:200:2000])
xlabel(ax, 'Dendrite Compartment')
ylabel(ax, 'Surface Area')
set(ax,'TickDir','out');
set(ax, 'linewidth', 1.5)
set(ax, 'FontSize', 18)
ylim([0 2000])
box off
ax.LabelFontSizeMultiplier = 1.4

yyaxis right;
b = scatter([1:1:4], inputs, 200, 'r', "filled");
ylabel(ax, 'Number of Inputs')


ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'r';
yticks(0:25:150)

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 14 8]);
filename = ['C09_SA_Input_Breakdown',datestr(now, 'dd_mmm_yyyy'),'.png'];
print(gcf, filename,'-dpng','-r500');

% Addition to export file
f = gcf
exportgraphics(f, 'HistogramDendriteCompartmentAreaInputs.jpg', 'Resolution', 300)
