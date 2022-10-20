% This script generates the graph of axon and fiber radius required for the 
% manuscript, using xlsread and curve fitting;
% The file used is 'AxonDataRev3Cleaned_Diameters'
%
% First clear the workspace
clear all;
close all;
clc;

% Read only the branch and auditory nerve fiber (ANF) axon and fiber radii
% Note many cells are empty or text and read as NaN
% Column code:
%   1: axon radius
%   2: fiber radius (axon + myelin)
%   3: axon diameter
%   4: fiber diameter (axon + myelin)
% Create a second matching array listing values that are NaN as 
% logical == 1 using the isnan function

excelfilename = 'Fig5F_AxonDataRev3Cleaned_Diameters';
excelsheet = 'ANF+size';
excelsheetrange = 'E4:H88';
BranchANFRadii = xlsread(excelfilename, excelsheet, excelsheetrange);
BranchANFRadiiNaN = isnan(BranchANFRadii);

% Create arrays without NaN values
% First determine the length of each column
% Then extract only numbers from each column
% Begin with the branch values
% When selecting branch radii, also compute the diameters

BranchANFRadiiSize = numel(BranchANFRadii(:,1));
j = 1;
for i = 1:BranchANFRadiiSize
    if BranchANFRadiiNaN(i,1) == 0 & BranchANFRadii(i,1) ~= BranchANFRadii(i,2)
        BranchValues(j,1) = BranchANFRadii(i,1);
        BranchValues(j,2) = BranchANFRadii(i,2);
        BranchValues(j,3) = 2*BranchValues(j,1);
        BranchValues(j,4) = 2*BranchValues(j,2);
        j = j+1;
    else
    end
end
j = j-1;    % Keep j as the number of rows in BranchValues
% Now do the same for the ANFs

k = 1;
for i = 1:BranchANFRadiiSize
    if BranchANFRadiiNaN(i,3) == 0
        ANFValues(k,1) = BranchANFRadii(i,3);
        ANFValues(k,2) = BranchANFRadii(i,4);
        ANFValues(k,3) = 2*ANFValues(k,1);
        ANFValues(k,4) = 2*ANFValues(k,2);
        k = k+1;
    else
    end
end
k = k-1;    % keep k as the number of rows in ANFValues
% Now generate a plot of values, fit each data set and draw the fit for the
% entire data set

scatter(BranchValues(:,4), BranchValues(:,3),'k','*');
hold on;
scatter(ANFValues(:,4), ANFValues(:,3),'k','o');

% First fit the ANF data to obtain the y-intercept and slope in
% linfitANF
ANFValuesFit(1:k,1) = 1;
ANFValuesFit(:,2) = ANFValues(:,4);
linfitANF = ANFValuesFit\ANFValues(:,3);
ycalcANF = ANFValuesFit*linfitANF;
% plot(ANFValues(:,4), ycalcANF)

% Then fit the Branch data to obtain the y-intercept and slope in
% linfitBranch
BranchValuesFit(1:j,1) = 1;
BranchValuesFit(:,2) = BranchValues(:,4);
linfitBranch = BranchValuesFit\BranchValues(:,3);
ycalcBranch = BranchValuesFit*linfitBranch;
%plot(BranchValues(:,4), ycalcBranch)

% Then fit the combined ANF and Branch data to obtain the y-intercept and slope in
% linfitAll

AllValues = [BranchValues; ANFValues];
AllValuesFit(1:j+k,1) = 1;
AllValuesFit(:,2) = AllValues(:,4);
linfitAll = AllValuesFit\AllValues(:,3);
ycalcAll = AllValuesFit*linfitAll;
plot(AllValues(:,4), ycalcAll,'k')

% Now set the plot parameters
ax1 = gca;
ax1.XLim = [0 4.0];
ax1.YLim = [0 3.0];
ax1.TickDir = 'out'
ax1.XTick = (0:0.5:4.0);
ax1.YTick = (0:0.5:4.0);

% ax1.YTickLabel = {'2.0','2.5','3.0','3.5'}
% ax1.XTickLabel = {'3000','3500','4000','4500','5000'}
ax1.XLabel.String = 'Fiber Diameter  (\mum)';
ax1.YLabel.String = 'Axon Diameter (\mum)';

ax1.FontSize = 16;

ax1.XMinorTick = 'on'
ax1.YMinorTick = 'on'
ax1.XAxis.MinorTickValues = [0:0.25:4.0];
ax1.YAxis.MinorTickValues = [0:0.25:4.0];

ax1.LabelFontSizeMultiplier = 1.4;
hold off

% Compute r^2 values for each of the fits, beginning with ANFs only, then
% Branch Axons then all together
% Calculate the means of the calculated y values first, to enter into the
% equations later
meanyANFValues = mean(ANFValues(:,3));
meanBranchValues = mean(BranchValues(:,3));
meanAllValues = mean(AllValues(:,3));  

%These two expressions were introduced to check the final value
% num = sum((AllValues(:,4) - ycalcAll).^2);    
% den = sum((AllValues(:,4) - meanycalcAll).^2);

rsqANF = 1 - (sum((ANFValues(:,3) - ycalcANF).^2) ...
/ sum((ANFValues(:,3) - meanyANFValues).^2));
rsqBranch = 1 - (sum((BranchValues(:,3) - ycalcBranch).^2) ...
/ sum((BranchValues(:,3) - meanBranchValues).^2));
rsqAll = 1 - (sum((AllValues(:,3) - ycalcAll).^2) ...
/ sum((AllValues(:,3) - meanAllValues).^2));

% Add the equation to the plot
text(2.6, 1.5, 'y = 0.76*x + 0.03','FontSize',14)
text(2.6, 1.3, 'r^2 = 0.97','FontSize',14)

% Determine some parameters of this analysis to report in the manuscript
% These include:
% The ratio of fiber to axon diameter for AllValues
dfda = 1/(linfitAll(2,1));
% The range of conduction velocities based on vc = 6*Dfiber
CondVelBranch = BranchValues(:,4).*6;
MaxCondVelBranch = max(CondVelBranch);
MinCondVelBranch = min(CondVelBranch);
% The range of conduction delays based on conduction velocities and
% BranchLength

% % Now export the plot
f = gcf
exportgraphics(f, 'Fiber_Diameter_vs_Axon_Diameter_Fit.jpg', 'Resolution', 300)
% 

