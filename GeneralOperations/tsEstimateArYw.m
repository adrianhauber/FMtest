function [pars,resVar] = tsEstimateArYw(data, arOrder)

N = length(data);
covs = zeros(arOrder,1); 
cov0 = xcov(data,0,'unbiased'); %variance

%cov0 = myCov(data,0);
for p = 1:arOrder
    autocovs = xcov(data,p,'unbiased');
    covs(p) = autocovs(end);
end

%build matrix
indexmatrix = zeros(arOrder); covsmatrix = zeros(arOrder);
for p = 1:arOrder
    indexmatrix = indexmatrix + diag((p)*ones(arOrder-p,1),p);
    indexmatrix = indexmatrix + diag((p)*ones(arOrder-p,1),-p);
end
indexmatrix(indexmatrix == 0) = 1; % dummy value, will be overwritten later

covsmatrix = covs(indexmatrix);
covsmatrix = covsmatrix - diag(diag(covsmatrix)) + diag(cov0*ones(arOrder,1));

pars = covsmatrix\covs;

% calc error par
sigsq = cov0 - covs'*pars;
pars = pars';
resVar = sigsq;
end