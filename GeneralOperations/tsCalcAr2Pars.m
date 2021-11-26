function arPars = tsCalcAr2Pars(T,tau)
% arPars = tsCalcAr2Pars(T,tau)
%
% Calculate AR[2] parameters arPars = [a1,a2] from phyiscally interpretable
% quantities T and tau

a1 = 2*cos(2*pi./T).*exp(-1./tau);
a2 = -exp(-2./tau);

arPars = [a1,a2];
end
