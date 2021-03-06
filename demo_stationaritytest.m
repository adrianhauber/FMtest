% Demo script for stationarity test (Hauber et al 2021) using normalized data 
%from e15c064 (Sigloch et al. 2020). Each individual section should not take 
%much longer than a few seconds to compute on a modern machine.

tsInit

%% Simulate data (AR[2] process) with frequency modulation
nTimePoints = 1000;
nRealizations = 1;
decay = 100;
discardLength = 5*decay;
baseline = 20;
switchTime = 300;
switchLevel = 40;

decays = decay * ones(nTimePoints + discardLength,1);
period = baseline * ones(nTimePoints + discardLength,1);
period((discardLength+switchTime):end) = baseline+switchLevel;
arPars = tsCalcAr2Pars(period, decays);
[data, ~] = tsSimulateAR(arPars, nTimePoints, nRealizations, discardLength);

figure
plot(data)
hold on
xline(switchTime, '--')
hold off
xlabel('Time')
title('Simulated data (AR[2] process) with FM')

%% Perform stationarity test
statConfig.signLevel = 0.05;
statConfig.surrN = 1000;
statConfig.surrMethod = 'AFFT';
idata = 1;

[instPhase, instPhaseSurr, lb, ub, rejection] = ...
    tsStationarityTest2(data(:,idata), statConfig);

figure
plot(instPhaseSurr(:,1:5:end), 'Color', 0.7*[1 1 1], 'HandleVisibility', 'off')
hold on
plot(instPhase, 'Color', 'k', 'LineWidth',2)
plot(lb,'k-.', 'LineWidth',2)
plot(ub,'k-.','HandleVisibility','off', 'LineWidth',2)
xline(switchTime,'--')
hold off

xlabel('Time')
title('Instantaneous phase - simulated data (AR[2] process) with FM')

%% Simulate data (AR[2] process) without frequency modulation
nTimePoints = 1000;
nRealizations = 1;
decay = 100;
discardLength = 5*decay;
baseline = 20;

decays = decay;
period = baseline;
arPars = tsCalcAr2Pars(period, decays);
[data, ~] = tsSimulateAR(arPars, nTimePoints, nRealizations, discardLength);

figure
plot(data)
xlabel('Time')
title('Simulated data (AR[2] process) without FM')

%% Perform stationarity test
statConfig.signLevel = 0.05;
statConfig.surrN = 1000;
statConfig.surrMethod = 'AFFT';
idata = 1;

[instPhase, instPhaseSurr, lb, ub, rejection] = ...
    tsStationarityTest2(data(:,idata), statConfig);

figure
plot(instPhaseSurr(:,1:5:end), 'Color', 0.7*[1 1 1], 'HandleVisibility', 'off')
hold on
plot(instPhase, 'Color', 'k', 'LineWidth',2)
plot(lb,'k-.', 'LineWidth',2)
plot(ub,'k-.','HandleVisibility','off', 'LineWidth',2)
xline(switchTime,'--')
hold off

xlabel('Time')
title('Instantaneous phase - simulated data (AR[2] process) without FM')

%% Experimental data
import = csvread('demodata_stationaritytest.csv');
times = import(:,1); data = import(:,2);
figure
plot(times, data)
xlabel('Time [min]')
title('Data - e15c064')

%% Perform stationarity test
rng(2)
statConfig.signLevel = 0.05;
statConfig.surrN = 1000;
statConfig.surrMethod = 'AFFT';
idata = 1;

[instPhase, instPhaseSurr, lb, ub, rejection] = ...
    tsStationarityTest2(data, statConfig);

figure
plot(times',instPhaseSurr(:,1:4:end), 'Color', 0.7*[1 1 1], 'HandleVisibility', 'off')
hold on
plot(times,instPhase, 'Color', 'k', 'LineWidth',2)
plot(times,lb,'k-.', 'LineWidth',2)
plot(times,ub,'k-.','HandleVisibility','off', 'LineWidth',2)
hold off

xlabel('Time')
title('Instantaneous phase - e15c064')


