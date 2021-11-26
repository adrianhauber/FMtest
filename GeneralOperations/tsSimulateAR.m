function [data, fulldata] = tsSimulateAR(arPars, nTimePoints, nRealizations, discardLength, inits, innovations)

% arPars must be row vector of size 1*arOrder or nTimePoints*arOrder for time-dependent arPars 
%% Check input arguments
% arPars
arOrder = size(arPars,2);

% nRealizations
if ~exist('nRealizations') || isempty(nRealizations)
    nRealizations = 1;
end

% discardLength: calculate characteristic time scale
if ~exist('discardLength') || isempty(discardLength)
    if arOrder == 1
        tau = -1/log(abs(arPars(1,1)));
    elseif arOrder == 2
        try
        tau = 2/-log(-arPars(1,2));
        catch
            error('tsSimulateAR: Relaxation time calculation failed.')
        end
    else
        error('tsSimulateAR: Must specify discardLength for AR models with order > 2')
    end
    discardLength = ceil(10*tau);
end

% expand length of simulated data by discardLength
Nint = nTimePoints + discardLength;

% catch time dependent arPars
if size(arPars,1)>1
    if size(arPars,1) ~= Nint
        error('Size of arPars matrix must correspond to nTimePoints+discardLength')
    end
    fprintf('Simulating data with time-dependent parameters...\n')
else
    arPars = repmat(arPars, [Nint,1]);
end


% inits
if ~exist('inits') || isempty(inits)
    inits = rand(size(arPars,2),1)-0.5; %should not be zero because it is not realization of AR2 process
else
    if size(inits) ~= size(arPars(1,:))
        error('tsSimulateAR: Inits must be the same size as arPars')
    end
end

% innovations
if ~exist('innovations') || isempty(innovations)
    innovations = randn(Nint, nRealizations);
elseif size(innovations,1) ~= nTimePoints + discardLength
    error('length of innovations vectors must be equal to nTimePoints+discardLength')
end

%% Simulation
data = NaN(Nint, nRealizations);
data(1:arOrder,:) = repmat(inits,[1,nRealizations]); %???

for i = arOrder+1:Nint
    toAdd = NaN(arOrder,nRealizations);
    for j = 1:arOrder
        toAdd(j,:) = arPars(i,j)*data(i-j,:);
    end
    data(i,:) = sum(toAdd,1) + innovations(i,:);
end

% remove the first discardLength elements of simulations to remove
fulldata = data;
data = data(discardLength+1:end,:);
% influence of initial conditions
end