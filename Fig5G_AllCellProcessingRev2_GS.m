% This code takes in one cleaned excel sheet and produces all desired
% graphs and processed information regarding myelinated and unmyelinated
% lengths of traced processes

% Rev 2 only uses overall average fiber radius for conduction velocity
% estimates

% plot unmyelinated length vs myelinated length
% plot histogram along the top and side
% keep open histogram

% plot axon diam vs fiber diam
% plot histogram along the top and side

% plot ANF axon diam vs ANF fiber diam
% plot histogram along the top and side

% plot delay vertically by cell and put bar at mean


% clear and close
clear all;
clc;
close all;

% load excel file
d = xlsread('Fig5G_AxonDataRev3Cleaned.xlsx', 'ANF');

% determine which entries are NaNs
nans = isnan(d);
% locate which rows have the cell name
cellNameIndex = find((nans(:,1) == 0) & (nans(:,2) == 1));

% extract cell names
cInfo.name = d(cellNameIndex,1);

% create variables for All Cell information
allCells.mLength = [];
allCells.umLength = [];
allCells.axonRadius = [];
allCells.fiberRadius = [];
allCells.axonDiameter = [];
allCells.fiberDiameter = [];
allCells.fiberLdratio = [];
allCells.ANFAxonRadius = [];
allCells.ANFFiberRadius = [];

% create variables for avg cell information
cInfo.avgMLength = [];
cInfo.avgUmLength = [];
cInfo.avgAxonRadius = [];
cInfo.avgFiberRadius = [];
cInfo.avgAxonDiameter = [];
cInfo.avgFiberDiameter = [];
cInfo.avgFiberLdratio = [];
cInfo.avgFiberLdratioavgforNaN = [];
cInfo.avgANFAxonRadius = [];
cInfo.avgANFFiberRadius = [];
cInfo.avgTravelTime = [];
cInfo.avgTravelTimeLdscaled = [];

% extract all other information
for i=1:(length(cellNameIndex)-1)
    % begin data range by skipping 2 rows from cell id to rows with terminal id's and information
    % finish data range by moving up 2 rows from next cell id row due to
    % empty row at end of each cell's data
    cellInfo = d((cellNameIndex(i)+2):(cellNameIndex(i+1)-2),:)
    cInfo.terminal{i} = cellInfo(:,1);
    
    cInfo.mLength{i} = cellInfo(:,2);
    cInfo.umLength{i} = cellInfo(:,3);
    % Concatenate values into the allCells arrays
    allCells.mLength = [allCells.mLength;cInfo.mLength{i}];
    allCells.umLength = [allCells.umLength;cInfo.umLength{i}];
    
    cInfo.endStyle{i} = cellInfo(:,4);
    
    cInfo.axonRadius{i} = cellInfo(:,5);
    cInfo.fiberRadius{i} = cellInfo(:,6);
    cInfo.axonDiameter{i} = cellInfo(:,6).*2;
    cInfo.fiberDiameter{i} = cellInfo(:,6).*2;
    allCells.axonRadius = [allCells.axonRadius;cInfo.axonRadius{i}];
    allCells.fiberRadius = [allCells.fiberRadius;cInfo.fiberRadius{i}];
    allCells.axonDiameter = [allCells.axonDiameter;cInfo.axonDiameter{i}];
    allCells.fiberDiameter = [allCells.fiberDiameter;cInfo.fiberDiameter{i}];
    
    cInfo.fiberLdratio{i} = cInfo.mLength{i} ./ cInfo.fiberDiameter{i};
    cInfo.FiberLdratioavgforNaN{i} = cInfo.fiberLdratio{i};
    allCells.fiberLdratio = [allCells.fiberLdratio;cInfo.fiberLdratio{i}];
    
    cInfo.ANFAxonRadius{i} = cellInfo(:,7);
    cInfo.ANFFiberRadius{i} = cellInfo(:,8);
    allCells.ANFAxonRadius = [allCells.ANFAxonRadius;cInfo.ANFAxonRadius{i}];
    allCells.ANFFiberRadius = [allCells.ANFFiberRadius;cInfo.ANFFiberRadius{i}];
    
    clearvars cellInfo
end

% The above "for loop" omitted the final cell because the end of the data
% array could not be specified using the loop logic
% This section picks up the final cell, again skipping 2 rows in the cellInfo
% file from the cell ID to the data
% [Not sure why the allCells arrays are not updated here]

i = length(cellNameIndex);
cellInfo = d((cellNameIndex(i)+2):end,:);   % skip two rows to beginning of data
cInfo.terminal{i} = cellInfo(:,1);

cInfo.mLength{i} = cellInfo(:,2);
cInfo.umLength{i} = cellInfo(:,3);
allCells.mLength = [allCells.mLength;cInfo.mLength{i}];
allCells.umLength = [allCells.umLength;cInfo.umLength{i}];

cInfo.endStyle{i} = cellInfo(:,4);
cInfo.axonRadius{i} = cellInfo(:,5);
cInfo.fiberRadius{i} = cellInfo(:,6);
cInfo.axonDiameter{i} = cellInfo(:,6).*2;
cInfo.fiberDiameter{i} = cellInfo(:,6).*2;
cInfo.fiberLdratio{i} = cInfo.mLength{i} ./ cInfo.fiberDiameter{i};
cInfo.FiberLdratioavgforNaN{i} = cInfo.fiberLdratio{i};
cInfo.ANFAxonRadius{i} = cellInfo(:,7);
cInfo.ANFFiberRadius{i} = cellInfo(:,8);

allCells.fiberLdratio = [allCells.fiberLdratio;cInfo.fiberLdratio{i}];
clearvars cellInfo

% extract averages for branch lengths (myelinated and unmyelinated) and
% branch axon and fiber radii, noting not all branch lengths have
% associated branch radii
for i=1:length(cInfo.name)
    cInfo.avgMLength(end+1) = mean(cInfo.mLength{i});
    cInfo.avgUmLength(end+1) = mean(cInfo.umLength{i});
    
    % axon and fiber radii were not measured for every terminal, so these
    % data cells must be excluded from velocity and delay measurements
    % compute average axon and fiber radius and diameter per cell
    f1 = isnan(cInfo.axonRadius{i});
    f2 = isnan(cInfo.fiberRadius{i});
    f3 = isnan(cInfo.fiberLdratio{i});
    dummy1 = cInfo.axonRadius{i};
    dummy1(f1) = [];
    dummy2 = cInfo.fiberRadius{i};
    dummy2(f2)= [];
    dummy3 = cInfo.fiberLdratio{i};
    dummy3(f2)= [];
    
    if ((length(cInfo.axonRadius{i}) == length(dummy1)) && (length(cInfo.fiberRadius{i}) == length(dummy2)))
        % this means that data exists for everything
        cInfo.complete(i) = 1;
    else
        cInfo.complete(i) = 0;
    end
    
    cInfo.avgAxonRadius(end+1) = mean(dummy1);
    cInfo.avgFiberRadius(end+1) = mean(dummy2);
    cInfo.avgAxonDiameter(end+1) = mean(dummy1)*2;
    cInfo.avgFiberDiameter(end+1) = mean(dummy2)*2;
    cInfo.avgFiberLdratio(end+1) = mean(dummy3)
    clearvars f1 f2 f3 dummy1 dummy2 dummy3
end

% Test loop
for i=1:length(cInfo.name)
    cInfo.avgFiberDiameterwithNaN{i} = mean(cInfo.fiberDiameter{i});
end

% get overall average fiber radius, fiber diameter and Ldratio by averaging
% averages for each cell
ns = isnan(cInfo.avgFiberRadius);
cInfo.avgFiberRadius(ns) = [];
totalAvgFiberRadius = mean(cInfo.avgFiberRadius);

ns = isnan(cInfo.avgFiberDiameter);
cInfo.avgFiberDiameter(ns) = [];
totalAvgFiberDiameter = mean(cInfo.avgFiberDiameter);

ns = isnan(cInfo.avgFiberLdratio);
cInfo.avgFiberLdratio(ns) = [];
totalAvgLdRatio = mean(cInfo.avgFiberLdratio);

% create new files cInfo.fiberRadiusavgforNaN{i} and cInfo.fiberDiameteravgforNaN{i}
% to replace NaN entries in cInfo.fiberRadius{i} and cInfo.fiberDiameter{i}
% these calculations are made so that conduction velocities can be
% calculated also for these fibers
for i=1:length(cInfo.name)
    f22 = isnan(cInfo.fiberRadius{i});
    f23 = isnan(cInfo.fiberDiameter{i});
    dummy22 = cInfo.fiberRadius{i};
    dummy23 = cInfo.fiberDiameter{i};
    dummy22(f22) = totalAvgFiberRadius;
    dummy23(f23) = totalAvgFiberDiameter;
    cInfo.fiberRadiusavgforNaN{i} = dummy22;
    cInfo.fiberDiameteravgforNaN{i} = dummy23;
end

% create new file cInfo.fiberLdratioavgforNaN to replace NaN entries in 
% cInfo.fiberLdratio with totalAvgLdRatio value in advance of computing L:d scale factor
for i=1:length(cInfo.name)
    f4 = isnan(cInfo.FiberLdratioavgforNaN{i});
    dummy4 = cInfo.FiberLdratioavgforNaN{i}
    dummy4(f4) = totalAvgLdRatio
    cInfo.FiberLdratioavgforNaN{i} = dummy4;
    clearvars f4 dummy4
end

% processing for box and whisker plots
boxMyelinatedData = NaN(max(cellfun('size',cInfo.mLength,1)),length(cInfo.name));
boxUnmyelinatedData = NaN(max(cellfun('size',cInfo.umLength,1)),length(cInfo.name));
boxAxonData = NaN(max(cellfun('size',cInfo.axonRadius,1)),length(cInfo.name));
boxFiberData = NaN(max(cellfun('size',cInfo.fiberRadius,1)),length(cInfo.name));

for i=1:length(cInfo.name)
    len1 = length(cInfo.mLength{i});
    len2 = length(cInfo.umLength{i});
    len3 = length(cInfo.axonRadius{i});
    len4 = length(cInfo.fiberRadius{i});
    boxMyelinatedData(1:len1,i) = cInfo.mLength{i};
    boxUnmyelinatedData(1:len2,i) = cInfo.umLength{i};
    boxAxonData(1:len3,i) = cInfo.axonRadius{i};
    boxFiberData(1:len4,i) = cInfo.fiberRadius{i};
end




%% Conduction Estimates
% First compute the L:d scale factor function from measurements on figure
% from Brill et al. in Photoshop; Velocity as % max on scale where 0-100% 
% Velocity = 680.03 units in Photoshop

VelLDratioCalibrationXValues = [0 2.5 5 10 20 100 200 400 600 800 890 950];
VelPhotoshopUnits = [0 89.7 250.05 336.05 441.04 649.04 660.04 597 513.02 423 362.09 316.03];
VelPerCentMax = VelPhotoshopUnits ./ 680.03;

% Fit: 'LdLinearInterpolationFit'.
[xData, yData] = prepareCurveData( VelLDratioCalibrationXValues, VelPerCentMax );

% Set up fittype and options.
ft = 'linearinterp';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );
%input = [25 55]

% Generate the velocity scale factor matrix only for fibers with measured diameters
for i=1:length(cInfo.name)
    dummy6 = cInfo.fiberLdratio{i};
    f6 = isnan(cInfo.fiberLdratio{i});
    dummy6(f6) = []
    cInfo.VelScaleFactor{i} = fitresult(dummy6);
end

% Generate the velocity scale factor matrix substituting the average L:d value
% for fibers without measured diameters
for i=1:length(cInfo.name)
    cInfo.VelScaleFactoravgforNaN{i} = fitresult(cInfo.FiberLdratioavgforNaN{i});
end

% % calculate travel time of signal in microseconds using sum of myelinated
% % and unmyelinated axon lengths; currently not using this approach
% for i=1:length(cInfo.name)  
%     cInfo.totalTravelTime{i} = ((cInfo.mLength{i} + cInfo.umLength{i})./(totalAvgFiberRadius.*2.*6.*(10^6))).*(10^6);
% end


% calculate travel time of signal in microseconds using myelinated axon
% length; conduction velocity scale factors for myelinated fibers are either 4.6 or 5.7 m/sec
condvelscale = 4.6

% generate travel times using only axons for which diameters were measured
for i=1:length(cInfo.name)
    dummy51 = cInfo.mLength{i};
    dummy52 = cInfo.fiberDiameter{i};
    f5 = isnan(cInfo.fiberDiameter{i});
    dummy51(f5) = [];
    dummy52(f5) = [];
    condvel{i} = dummy52.*condvelscale;
    cInfo.m2TravelTime{i} = dummy51./(dummy52.*condvelscale);
    cInfo.avgTravelTime{i} = mean(cInfo.m2TravelTime{i});
    cInfo.m2TravelTimeLdscaled{i} = cInfo.m2TravelTime{i} ./ cInfo.VelScaleFactor{i};
    cInfo.avgTravelTimeLdscaled{i} = mean(cInfo.m2TravelTimeLdscaled{i});  

    clearvars f5 dummy51 dummy52
end
%     meancondvel = mean(condvel,'all');
%     stdevcondvel = std(condvel,'all');
% generate travel times substituting the average diameter value
% for fibers without measured diameters
for i=1:length(cInfo.name)
    cInfo.m2TravelTimeavgforNaN{i} = cInfo.mLength{i}./(cInfo.fiberDiameteravgforNaN{i}.*condvelscale);
    cInfo.m2TravelTimeLdscaledavgforNaN{i} = cInfo.m2TravelTimeavgforNaN{i} ./ cInfo.VelScaleFactoravgforNaN{i};
end

% Note these calculations are written by Sean, using myelinated and unmyelinated
% diameter
%     if cInfo.complete(i) == 1
%         % conduction velocity is cInfo.fiberDiameter * condvelscale
% 
%         cInfo.mTravelTime{i} = cInfo.mLength{i}./(cInfo.fiberDiameter{i}.*condvelscale);
%         
%         % travel time for myelin + unmyelin
%         % cInfo.totalTravelTime{i} = (cInfo.mLength{i} + cInfo.umLength{i})./(cInfo.fiberRadius{i}.*2.*6.*(10^6));
%         % convert to microseconds - note only necessary when travel time
%         % was multiplied by 10^6
%         % cInfo.totalTravelTime{i} = cInfo.totalTravelTime{i}.*(10^-6);
%     else
%         % use the total average fiber diameter when individual axons were not
%         % quantified
%         cInfo.mTravelTime{i} = cInfo.mLength{i}/(totalAvgFiberDiameter*condvelscale);
%         
%         % travel time for myelin + unmyelin
%         % cInfo.totalTravelTime{i} = (cInfo.mLength{i} + cInfo.umLength{i})./(cInfo.fiberRadius{i}.*2.*6.*(10^6));
%         % convert to microseconds
%         % cInfo.totalTravelTime{i} = cInfo.totalTravelTime{i}.*(10^-6);
%     end






%% Myelinated and Unmyelinated Length Figure

figure()
% scatter plot umlength on y and mlength on x
plot(allCells.mLength,allCells.umLength,'b*')

% label axes
xlabel('myelinated length (um)')
ylabel('unmyelinated length (um)')

% secure figure axis and record position
ax1 = gca;
p = ax1.Position;

% declare upper limits for lengths
ax1XUp = 150;
ax1YUp = 35;

% format axis 1
ax1.XTickMode = 'manual';
ax1.YTickMode = 'manual'
ax1.TickDir = 'out'
ax1.FontSize = 12;
ax1.XLim = [0 ax1XUp];
ax1.YLim = [0 ax1YUp];
% set major x ticks
ax1.XTick = [0:10:ax1XUp];
% set major y ticks
ax1.YTick = [0:5:ax1YUp];

% turn on minor ticks
ax1.XMinorTick = 'on';
ax1.YMinorTick = 'on';
% set minor x ticks
ax1.XAxis.MinorTickValues = [0:5:ax1XUp];
% set minor y ticks
ax1.YAxis.MinorTickValues = [0:1:ax1YUp];

hold on

% plot an inset figure on y-axis
% horizontal shift
phorshh2 = 0.6995;
% vertical shift
pvershh2 = -0.001;

% create inset figure on parent figure
pinset2 = [p(1)+phorshh2 p(2)+pvershh2 p(3)-0.7 p(4)-pvershh2];
% declare axis for next plot
hi2 = axes('Parent', gcf, 'Position', pinset2);
% set histogram edges
y3edges = [0:5:30];
% plot histogram sideways
histogram(hi2, allCells.umLength, y3edges, 'FaceColor', [1 1 1], 'Orientation', 'horizontal','LineWidth',1.5);
% control inset plot axis characteristics
ax3 = gca;
ax3.XTickMode = 'manual';
ax3.XLim = [0 30];
ax3.XTick = [0:30:30];
%ax3.XMinorTick = 'on'
ax3.FontSize = 12;
ax3.XAxisLocation = 'top';
ax3.Box = 'off';
ax3.YLim = [0 ax1YUp];
ax3.YAxis.Visible = 'off';
ax3.XDir = 'reverse'
%ax3.XTickLabelRotation = -90;
ax3.XLabel.String = 'Count';

% Now plot an inset figure on the x-axis
%vertical shift
pvershh1 = 0.7;
% horizontal shift
phorshh1 = 0.001;

% create inset figure on parent figure
pinset1 = [p(1)+phorshh1 p(2)+pvershh1 p(3)-phorshh1 p(4)-0.7];
% declare axis for next plot
hi1 = axes('Parent', gcf, 'Position', pinset1);
% set histogram edges
x2edges = [0:10:ax1XUp];
% plot histogram
histogram(hi1, allCells.mLength, x2edges,'FaceColor',[1 1 1],'LineWidth',1.5)
% control inset plot axis characteristics
ax2 = gca;
ax2.XTickMode = 'manual'
ax2.YTickMode = 'manual'
ax2.FontSize = 12;
ax2.XLim = [0 ax1XUp]
ax2.XAxis.Visible = 'off'
ax2.YAxisLocation = 'right'
ax2.YLim = [0 10];
ax2.YTick = [0:10:10]
%ax2.YMinorTick = 'on'
ax2.Box = 'off';
%flip histogram upside down
ax2.YDir = 'reverse'
ax2.YLabel.String = 'Count';

% move plot to speed up workflow
movegui('northeast');


%% Figure for axon and fiber diameter
figure()
% scatter plot axon diameter on y and fiber diameter on x
plot(allCells.fiberRadius.*2,allCells.axonRadius.*2,'b*')
xlim([0 2])
ylim([0 2])

f1 = isnan(allCells.fiberRadius);
f2 = isnan(allCells.axonRadius);
allCells.fiberRadius(f1) = [];
allCells.axonRadius(f2)= [];

pol = polyfit(allCells.fiberRadius.*2,allCells.axonRadius.*2,1);
R = corrcoef(allCells.fiberRadius.*2,allCells.axonRadius.*2);
R2 = R(1,2).*R(1,2)

% label axes
xlabel('fiber diameter (um)')
ylabel('axon diameter (um)')

% secure figure axis and record position
ax4 = gca;
p = ax4.Position;

% format axis 1
ax4.XTickMode = 'manual'
ax4.YTickMode = 'manual'
ax4.TickDir = 'out'
ax4.FontSize = 12;
ax4.XLim = [0 2];
ax4.YLim = [0 2];
% set major x ticks
ax4.XTick = [0:0.2:2]
% set major y ticks
ax4.YTick = [0:0.2:2]

% turn on minor ticks
ax4.XMinorTick = 'on'
ax4.YMinorTick = 'on'
% set minor x ticks
ax4.XAxis.MinorTickValues = [0:0.1:2]
% set minor y ticks
ax4.YAxis.MinorTickValues = [0:0.1:2]
ax4.Box = 'off'

hold on

% plot line of best fit
yFit = polyval(pol,allCells.fiberRadius.*2);
plot(allCells.fiberRadius.*2,yFit,'r')

% plot an inset figure on y-axis
% horizontal shift
phorshh4 = 0.0009;
% vertical shift
pvershh4 = 0;%0.001;

% create inset figure on parent figure
pinset4 = [p(1)+phorshh4 p(2)+pvershh4 p(3)-0.665 p(4)-pvershh4];
% declare axis for next plot
hi2 = axes('Parent', gcf, 'Position', pinset4)
% set histogram edges
y4edges = [0:0.2:2];
% plot histogram sideways
histogram(hi2, allCells.axonRadius.*2, y4edges, 'FaceColor', [1 1 1], 'Orientation', 'horizontal','LineWidth',1.5)
% control inset plot axis characteristics
ax4 = gca;
ax4.XTickMode = 'manual'
ax4.YTickMode = 'manual'
ax4.XLim = [0 10];
ax4.XTick = [0:10:10];
ax4.FontSize = 12;
ax4.XAxisLocation = 'top'
ax4.Box = 'off'
ax4.YLim = [0 2];
ax4.YAxis.Visible = 'off'
%ax4.XDir = 'reverse'
ax4.XLabel.String = 'Count';

% Now plot an inset figure on the x-axis
%vertical shift
pvershh5 = 0.002;
% horizontal shift
phorshh5 = 0.0027;

% create inset figure on parent figure
pinset5 = [p(1)+phorshh5 p(2)+pvershh5 p(3)-phorshh5 p(4)-0.7];
% declare axis for next plot
hi5 = axes('Parent', gcf, 'Position', pinset5)
% set histogram edge
x5edges = [0:0.2:2];
% plot histogram
histogram(hi5, allCells.fiberRadius.*2, x5edges,'FaceColor',[1 1 1],'LineWidth',1.5)
% control inset plot axis characteristics
ax5 = gca;
ax5.XTickMode = 'manual'
ax5.YTickMode = 'manual'
ax5.FontSize = 12;
ax5.XLim = [0 2]
ax5.XAxis.Visible = 'off'
ax5.YAxisLocation = 'right'
ax5.YLim = [0 10];
ax5.YTick = [0:10:10]
%ax2.YMinorTick = 'on'
ax5.Box = 'off';
%flip histogram upside down
%ax5.YDir = 'reverse'
ax5.YLabel.String = 'Count';



%% Figure for ANF axon and fiber diameter
figure()
% scatter plot axon diameter on y and fiber diameter on x
plot(allCells.ANFFiberRadius.*2,allCells.ANFAxonRadius.*2,'b*')
xlim([0 4])
ylim([0 4])

f1 = isnan(allCells.ANFFiberRadius);
f2 = isnan(allCells.ANFAxonRadius);
allCells.ANFFiberRadius(f1) = [];
allCells.ANFAxonRadius(f2)= [];

clearvars pol R R2;
pol = polyfit(allCells.ANFFiberRadius.*2,allCells.ANFAxonRadius.*2,1);
R = corrcoef(allCells.ANFFiberRadius.*2,allCells.ANFAxonRadius.*2);
R2 = R(1,2).*R(1,2);

% label axes
xlabel('ANF fiber diameter (um)')
ylabel('ANF axon diameter (um)')

% secure figure axis and record position
ax4 = gca;
p = ax4.Position;

% format axis 1
ax4.XTickMode = 'manual'
ax4.YTickMode = 'manual'
ax4.TickDir = 'out'
ax4.FontSize = 12;
ax4.XLim = [0 4];
ax4.YLim = [0 4];
% set major x ticks
ax4.XTick = [0:0.5:4]
% set major y ticks
ax4.YTick = [0:0.5:4]

% turn on minor ticks
ax4.XMinorTick = 'on'
ax4.YMinorTick = 'on'
% set minor x ticks
ax4.XAxis.MinorTickValues = [0:0.25:4]
% set minor y ticks
ax4.YAxis.MinorTickValues = [0:0.25:4]
ax4.Box = 'off'

hold on

% plot line of best fit
yFit = polyval(pol,allCells.ANFFiberRadius.*2);
plot(allCells.ANFFiberRadius.*2,yFit,'r')

% plot an inset figure on y-axis
% horizontal shift
phorshh4 = 0.0009;
% vertical shift
pvershh4 = 0;%0.001;

% create inset figure on parent figure
pinset4 = [p(1)+phorshh4 p(2)+pvershh4 p(3)-0.665 p(4)-pvershh4];
% declare axis for next plot
hi2 = axes('Parent', gcf, 'Position', pinset4)
% set histogram edges
y4edges = [0:0.5:4];
% plot histogram sideways
histogram(hi2, allCells.ANFAxonRadius.*2, y4edges, 'FaceColor', [1 1 1], 'Orientation', 'horizontal','LineWidth',1.5)
% control inset plot axis characteristics
ax4 = gca;
ax4.XTickMode = 'manual'
ax4.YTickMode = 'manual'
ax4.XLim = [0 20];
ax4.XTick = [0:10:20];
ax4.FontSize = 12;
ax4.XAxisLocation = 'top'
ax4.Box = 'off'
ax4.YLim = [0 4];
ax4.YAxis.Visible = 'off'
%ax4.XDir = 'reverse'
ax4.XLabel.String = 'Count';

% Now plot an inset figure on the x-axis
%vertical shift
pvershh5 = 0.002;
% horizontal shift
phorshh5 = 0.0027;

% create inset figure on parent figure
pinset5 = [p(1)+phorshh5 p(2)+pvershh5 p(3)-phorshh5 p(4)-0.7];
% declare axis for next plot
hi5 = axes('Parent', gcf, 'Position', pinset5)
% set histogram edge
x5edges = [0:0.5:4];
% plot histogram
histogram(hi5, allCells.ANFFiberRadius.*2, x5edges,'FaceColor',[1 1 1],'LineWidth',1.5)
% control inset plot axis characteristics
ax5 = gca;
ax5.XTickMode = 'manual'
ax5.YTickMode = 'manual'
ax5.FontSize = 12;
ax5.XLim = [0 4]
ax5.XAxis.Visible = 'off'
ax5.YAxisLocation = 'right'
ax5.YLim = [0 20];
ax5.YTick = [0:10:20]
%ax2.YMinorTick = 'on'
ax5.Box = 'off';
%flip histogram upside down
%ax5.YDir = 'reverse'
ax5.YLabel.String = 'Count';



%% Figure for conduction delay

n = num2str(cInfo.name);
origins = [];
for i=1:length(cInfo.name)
    origins(end+1) = convertCharsToStrings(n(i,:));
end

figure()
hold on

k=0;
for i=1:length(cInfo.name)
    %pick random color
    % c = rand(1,3);
    
    x = zeros(1,length(cInfo.m2TravelTimeavgforNaN{i}));
%     x = x + i;
%     x1 = x - 0.1;
%     x2 = x + 0.1;
    y1 = cInfo.m2TravelTimeavgforNaN{i};
    y2 = cInfo.m2TravelTimeLdscaledavgforNaN{i};
    %avgTravelTime(i) = mean(cInfo.m2TravelTime{i});
    if i~=1 && i~=7 && i~=12
        x1 = zeros(1,length(cInfo.m2TravelTimeavgforNaN{i}));
        x2 = zeros(1,length(cInfo.m2TravelTimeavgforNaN{i}));
        k=k+1;
        x1 = x1+k-0.1;
        x2 = x2+k+0.1;
        for j=1:length(x1)
            x3 = [x1(j) x2(j)];
            y3 = [y1(j) y2(j)];
            plot(x3, y3,'-o','Color','k')
        end
    else
    end
%     if cInfo.avgTravelTime(i) ~= NaN
%     plot([mean(x)-0.4 mean(x)],[cInfo.avgTravelTime(i) cInfo.avgTravelTime(i)],'color','k')
%    else
%    end
end
clearvars k
% remove cells 02, 12, 29 from the final plot, which are indices 1, 7, 12
% in cInfo.name
%
for i=1:length(cInfo.name)
cInfo.namemod(i) = cInfo.name(i);
end

f7 = [1 0 0 0 0 0 1 0 0 0 0 1];
f71 = logical(f7);
cInfo.namemod(f71) = [];

% Now set the plot parameters
ax1 = gca;
ax1.XLim = [0 length(cInfo.namemod)+1];
ax1.YLim = [0 25];
ax1.TickDir = 'out'
ax1.XTick = (1:length(cInfo.namemod));
ax1.YTick = (0:5:25);
ax1.XTickLabel = {cInfo.namemod}
ax1.XLabel.String = 'Bushy Cell'
ax1.YLabel.String = 'Delay (µs)'
% ax1.YTickLabel = {'2.0','2.5','3.0','3.5'}
% ax1.XTickLabel = {'3000','3500','4000','4500','5000'}
% ax1.XLabel.String = 'Fiber Diameter  (\mum)';
% ax1.YLabel.String = 'Axon Diameter (\mum)';

%set(gca,'XTick',1:length(cInfo.namemod),'XTickLabel',cInfo.namemod)
%xlim([0 length(cInfo.namemod)+1])

ax1.FontSize = 16;
ax1.LabelFontSizeMultiplier = 1.4;

% export the plot as a jpg file
f = gcf
exportgraphics(f, 'ConductionVelocityWithLdScale.jpg', 'Resolution', 300)


%% Figure for fiber diameter compared to somatic size

% load data
d2 = xlsread('AxonDataRev3Cleaned.xlsx', 'ANF+size');

% determine which entries are NaNs
nans = isnan(d);
% locate which rows have the cell name
clearvars cellNameIndex
cellNameIndex = find((nans(:,1) == 0) & (nans(:,2) == 1));

% extract cell names
cInfo2.name = d2(cellNameIndex,1);

allCells2.axonRadius = [];
allCells2.fiberRadius = [];
allCells2.size = [];
% extract all other information
for i=1:(length(cellNameIndex)-1)
    cellInfo = d2((cellNameIndex(i)+2):(cellNameIndex(i+1)-2),:);
    cInfo2.terminal{i} = cellInfo(:,1);
    
    cInfo2.mLength{i} = cellInfo(:,2);
    cInfo2.umLength{i} = cellInfo(:,3);
    
    cInfo2.endStyle{i} = cellInfo(:,4);
    
    cInfo2.axonRadius{i} = cellInfo(:,5);
    cInfo2.fiberRadius{i} = cellInfo(:,6);
    allCells2.axonRadius = [allCells2.axonRadius;cInfo2.axonRadius{i}];
    allCells2.fiberRadius = [allCells2.fiberRadius;cInfo2.fiberRadius{i}];
    
    cInfo2.ANFAxonRadius{i} = cellInfo(:,7);
    cInfo2.ANFFiberRadius{i} = cellInfo(:,8);
    
    cInfo2.size{i} = cellInfo(:,12);
    allCells2.size = [allCells2.size;cInfo2.size{i}];
    
    clearvars cellInfo
end
i = length(cellNameIndex);
cellInfo = d2((cellNameIndex(i)+2):end,:);
cInfo2.terminal{i} = cellInfo(:,1);

cInfo2.mLength{i} = cellInfo(:,2);
cInfo2.umLength{i} = cellInfo(:,3);

cInfo2.endStyle{i} = cellInfo(:,4);
cInfo2.axonRadius{i} = cellInfo(:,5);
cInfo2.fiberRadius{i} = cellInfo(:,6);
cInfo2.ANFAxonRadius{i} = cellInfo(:,7);
cInfo2.ANFFiberRadius{i} = cellInfo(:,8);
cInfo2.size{i} = cellInfo(:,12);
clearvars cellInfo


figure()
for j=1:length(cInfo2.name)
    for i=1:length(cInfo2.size{j})
        if isnan(cInfo2.fiberRadius{j}(i)) == 0
            plot(cInfo2.size{j}(i),cInfo2.fiberRadius{j}(i)*2,'b*')
            hold on
        end
    end
end
xlabel('input size (um^2)')
ylabel('fiber diameter (um)')

% secure figure axis and record position
ax4 = gca;
p = ax4.Position;

% format axis 1
ax4.XTickMode = 'manual'
ax4.YTickMode = 'manual'
ax4.TickDir = 'out'
ax4.FontSize = 12;
ax4.XLim = [0 240];
ax4.YLim = [0 3];
% set major x ticks
ax4.XTick = [0:40:240]
% set major y ticks
ax4.YTick = [0:0.2:3]

% turn on minor ticks
ax4.XMinorTick = 'on'
ax4.YMinorTick = 'on'
% set minor x ticks
ax4.XAxis.MinorTickValues = [0:20:240]
% set minor y ticks
ax4.YAxis.MinorTickValues = [0:0.1:2]
ax4.Box = 'off'

hold on

% plot an inset figure on y-axis
% horizontal shift
phorshh4 = 0.0009;
% vertical shift
pvershh4 = 0;%0.001;

% create inset figure on parent figure
pinset4 = [p(1)+phorshh4 p(2)+pvershh4 p(3)-0.665 p(4)-pvershh4];
% declare axis for next plot
hi2 = axes('Parent', gcf, 'Position', pinset4)
% set histogram edges
y4edges = [0:0.2:3];
% plot histogram sideways
histogram(hi2, allCells2.fiberRadius.*2, y4edges, 'FaceColor', [1 1 1], 'Orientation', 'horizontal','LineWidth',1.5)
% control inset plot axis characteristics
ax4 = gca;
ax4.XTickMode = 'manual'
ax4.YTickMode = 'manual'
ax4.XLim = [0 20];
ax4.XTick = [0:10:20];
ax4.FontSize = 12;
ax4.XAxisLocation = 'top'
ax4.Box = 'off'
ax4.YLim = [0 3];
ax4.YAxis.Visible = 'off'
%ax4.XDir = 'reverse'
ax4.XLabel.String = 'Count';

% Now plot an inset figure on the x-axis
%vertical shift
pvershh5 = 0.002;
% horizontal shift
phorshh5 = 0.0027;

% create inset figure on parent figure
pinset5 = [p(1)+phorshh5 p(2)+pvershh5 p(3)-phorshh5 p(4)-0.7];
% declare axis for next plot
hi5 = axes('Parent', gcf, 'Position', pinset5)
% set histogram edge
x5edges = [0:40:240];
% plot histogram
histogram(hi5, allCells2.size, x5edges,'FaceColor',[1 1 1],'LineWidth',1.5)
% control inset plot axis characteristics
ax5 = gca;
ax5.XTickMode = 'manual'
ax5.YTickMode = 'manual'
ax5.FontSize = 12;
ax5.XLim = [0 240]
ax5.XAxis.Visible = 'off'
ax5.YAxisLocation = 'right'
ax5.YLim = [0 20];
ax5.YTick = [0:10:20]
%ax2.YMinorTick = 'on'
ax5.Box = 'off';
%flip histogram upside down
%ax5.YDir = 'reverse'
ax5.YLabel.String = 'Count';



%{
% generate box and whisker plots for data variance within cells
n = num2str(cInfo.name);
origins = [];
for i=1:length(cInfo.name)
    origins(end+1) = convertCharsToStrings(n(i,:));
end

figure()
subplot(2,2,1)
boxplot(boxMyelinatedData,origins)
hold on
for i=1:length(cInfo.name)
    x = zeros(1,length(boxMyelinatedData(:,i)));
    x = x + i;
    
    scatter(x,boxMyelinatedData(:,i),'*')
end
hold off
title('Myelinated Length ANF')
ylabel('length (um)')
xlabel('Cell')

subplot(2,2,3)
boxplot(boxUnmyelinatedData,origins)
hold on
for i=1:length(cInfo.name)
    x = zeros(1,length(boxUnmyelinatedData(:,i)));
    x = x + i;
    
    scatter(x,boxUnmyelinatedData(:,i),'*')
end
hold off
title('Unmyelinated Length ANF')
ylabel('length (um)')
xlabel('Cell')

subplot(2,2,2)
boxplot(boxAxonData*2,origins)
hold on
for i=1:length(cInfo.name)
    x = zeros(1,length(boxAxonData(:,i)));
    x = x + i;
    
    scatter(x,boxAxonData(:,i)*2,'*')
end
hold off
title('Axon Diameter')
ylabel('diameter (um)')
xlabel('Cell')

subplot(2,2,4)
boxplot(boxFiberData*2,origins)
hold on
for i=1:length(cInfo.name)
    x = zeros(1,length(boxFiberData(:,i)));
    x = x + i;
    
    scatter(x,boxFiberData(:,i)*2,'*')
end
hold off
title('Fiber Diameter')
ylabel('diameter (um)')
xlabel('Cell')


%{
% generate histograms for data variance between averages of all cells
nbins = ceil(sqrt(length(cInfo.avgMLength)));
figure()
subplot(1,2,1)
histogram(cInfo.avgMLength,nbins,'DisplayStyle','stairs')
title('Avg Myelinated Length All Cells')
ylabel('Probability')
xlabel('Length (um)')

nbins = ceil(sqrt(length(cInfo.avgUmLength)));
subplot(1,2,2)
histogram(cInfo.avgUmLength,nbins,'DisplayStyle','stairs')
title('Avg Unmyelinated Length All Cells')
ylabel('Probability')
xlabel('Length (um)')
%}



%{
% generate histograms for data variance between all cells
nbins = ceil(sqrt(length(allCells.mLength)));
figure()
subplot(1,2,1)
% set histogram edges
step = 10;
edges = 0:step:max(allCells.mLength);
histogram(allCells.mLength,nbins,'LineWidth',1,'BinEdges',edges,'FaceColor',[1 1 1]);
title('Myelinated Length All Cells')
xlabel('Length (um)')
xlim([0 150])
ylim([0 15])

xticks(0:50:150);
ax = gca;
ax.XAxis.MinorTick = 'on';
ax.XAxis.MinorTickValues = 0:10:150;
clearvars edges


subplot(1,2,2)
% set histogram edges
step = 5;
edges = 0:step:max(allCells.umLength);
histogram(allCells.umLength,nbins,'LineWidth',1,'BinEdges',edges,'FaceColor',[1 1 1]);
title('Unmyelinated Length All Cells')
xlabel('Length (um)')
xlim([0 30])
ylim([0 25])

xticks(0:15:30);
ax = gca;
ax.XAxis.MinorTick = 'on';
ax.XAxis.MinorTickValues = 0:5:30;
clearvars edges nbins


% generate histograms of axon and fiber diameters
figure()
subplot(1,2,1)
step = 0.1;
edges = 0:step:3;
counts = histcounts(allCells.axonRadius*2,'BinEdges',edges);
bar(counts,0.8,'LineWidth',1,'FaceColor',[1 1 1])
title('Axon Diameter All Cells')
xlabel('Diameter (um)')
xlim([0 3])
ylim([0 10])

subplot(1,2,2)
histogram((allCells.fiberRadius)*2,'LineWidth',1,'BinEdges',edges,'FaceColor',[1 1 1]);
title('Fiber Diameter All Cells')
xlabel('Diameter (um)')
xlim([0 3])
ylim([0 10])

figure()
step = 0.1;
edges = 0:step:3;
counts = histcounts(allCells.axonRadius*2,'BinEdges',edges);
bar(counts,0.8,'LineWidth',1,'FaceColor',[1 1 1])
%}

%}

%%

% function [fitresult, gof] = createFit(VelLDratioCalibrationXValues, VelPerCentMax)
%CREATEFIT(VELLDRATIOCALIBRATIONXVALUES,VELPERCENTMAX)
%  Create a fit.
%
%  Data for 'LdLinearInterpolationFit' fit:
%      X Input : VelLDratioCalibrationXValues
%      Y Output: VelPerCentMax
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 09-Jul-2022 20:02:28


% %% Fit: 'LdLinearInterpolationFit'.
% [xData, yData] = prepareCurveData( VelLDratioCalibrationXValues, VelPerCentMax );
% 
% % Set up fittype and options.
% ft = 'linearinterp';
% 
% % Fit model to data.
% [fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );
%end

% Plot fit with data.
figure( 'Name', 'LdLinearInterpolationFit' );
h = plot( fitresult, xData, yData );
legend( h, 'VelPerCentMax vs. VelLDratioCalibrationXValues', 'LdLinearInterpolationFit', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'VelLDratioCalibrationXValues', 'Interpreter', 'none' );
ylabel( 'VelPerCentMax', 'Interpreter', 'none' );
grid on









