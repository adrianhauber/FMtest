% Power study for instantaneous frequency method
% (confidence bands adjusted to surrogate phases)

function [instPhase, instPhaseSurr, lb, ub, rejection] = tsStationarityTest2(data, statConfig)
[instPhase, instPhaseSurr] = tsStationarityTest(data, statConfig);

% calculate mean of surrogates and then shift this curve so that
% alpha/2% of surrogate trajs cross this bound?

surrMean = mean(instPhaseSurr,2);
instPhaseSurrC = instPhaseSurr - surrMean;

bestk = 0.1*statConfig.surrN;
maxSurrs = maxk(instPhaseSurrC,bestk,2);
minSurrs = mink(instPhaseSurrC,bestk,2);

ub = mean(maxSurrs,2);
lb = mean(minSurrs,2); %median?

% adjust coverage
adjFactors = 1:0.05:5;
for jj = 1:length(adjFactors)
    isVio = checkVio(instPhaseSurrC, adjFactors(jj)*lb, adjFactors(jj)*ub);
    fraction = sum(isVio)/length(isVio);
    
    if fraction < statConfig.signLevel
        adjFactor = adjFactors(jj);
        %disp('succ')
        break
    elseif jj == length(adjFactors)
        error('coverage error')
    end
end

ub = ub*adjFactor + surrMean;
lb = lb*adjFactor + surrMean;
rejection = checkVio(instPhase, lb, ub);
end

function isVio = checkVio(trajs, lb, ub)
isVio = logical(or(sum(trajs > ub,1) ~= 0, sum(trajs < lb,1) ~= 0));
end