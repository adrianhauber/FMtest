function [amp, phase, hilbT] = tsHilbertTransform(data)

% [amp, phase] = tsHilbertTransform(data)
%
% Calculate the analytical signal via the Hilbert transformation of the
% time series in the columns of data. Output is passed in polar form and
% represents instantaneous amplitude and instantaneous phase.

% pre-processing
data = data - mean(data, 1);
data = data./std(data,[], 1);
L = size(data,1);

% mirror data to tackle boundary effects
data = [flipud(data); data; flipud(data)];

% apply transform
hilbT = hilbert(data);

% remove mirrored parts
hilbT = hilbT(L+1:2*L,:);  

% calculate amplitude and phase
amp = abs(hilbT);
phase = unwrap(angle(hilbT));

end