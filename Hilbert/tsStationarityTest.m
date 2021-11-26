function [instPhase, instPhaseSurr, threshsLB, threshsUB, rejection] = tsStationarityTest(singleData, statConfig)

% [instPhaseSurr, threshsLB, threshsUB] = tsStationarityTest(singleData, surrConfig)
%
% Establish phase thresholds for non-stationary time series by surrogate
% data.

if size(singleData,2) > 1
    error('tsStationarityTest: Requires single time series (row vector) as input.')
end

% calculate hilbert transform
[~, instPhase] = tsHilbertTransform(singleData);

surrN = statConfig.surrN;
alpha = statConfig.signLevel;
surrMethod = statConfig.surrMethod;

% two-sided test: divide alpha by 2
sign_level = alpha/2;

% Calc surrogates of instantaneous phase
surrDataMat = NaN(length(singleData), surrN);
surrDataMat = tsSurrogateData(singleData, surrMethod, surrN);

[~, instPhaseSurr] = tsHilbertTransform(surrDataMat);

% find pointwise quantiles
threshsLB = quantile(instPhaseSurr,sign_level,2);
threshsUB = quantile(instPhaseSurr,1-sign_level,2);

% test decision
rejection = (sum(instPhase > threshsUB) + sum(instPhase < threshsLB) > 0);
end