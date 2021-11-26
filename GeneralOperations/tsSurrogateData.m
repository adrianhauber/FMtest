function surrogateData = tsSurrogateData(data, method, N)

% surrogateData = tsSurrogateData(data, method, N)
%
% Generate surrogates from data using the methods specified in Theiler et
% al. 1992: Testing for nonlinearity in time series.
%
%   data      input data
%   method    string to specify method, see below ['AFFT']
%   N         number of surrogate data sets to generate
%
% Available methods:
%
%   'FT'       Generate randn data and randomize phases => equal FT
%   'WFT'      Same as FT, but with windowed data
%   'AFFT'     Amplitude adjusted fourier transform, data is gaussianized
%              beforehand
%
% See also tsRankTimeSeries, tsGaussianizeData

if ~exist('method') || isempty(method)
    method = 'AFFT';
end
if ~exist('N') || isempty(N)
    N = 1;
end

% convert data to column vector
if size(data, 1) == 1 && size(data, 2) > 1
    data = data';
end

if strcmp(method, 'AFFT')
    % amplitude adjusted Fourier transform algorithm
    gaussedData = tsGaussianizeData(data);
    %surrogateOfGaussian = ft_algo(window_data(gaussedData),N);
    surrogateOfGaussian = ft_algo(gaussedData,N);
    
    % re-ranking -> inverse order of input args
    surrogateData = tsRankTimeSeries(surrogateOfGaussian, repmat(data, 1, N));    
elseif strcmp(method, 'WFT')
    % windowed Fourier transform algorithm
    windowed_data = window_data(data);
    surrogateData = ft_algo(windowed_data, N);
elseif strcmp(method, 'FT')
    % Fourier transform algorithm
    surrogateData = ft_algo(data, N);
elseif strcmp(method, 'IID')
    surrogateData = nan(size(data,1),N);
    for i = 1:N
        surrogateData(:,i) = data(randperm(size(data,1)));
    end
else
    error('invalid method specified')
end
end

function y = ft_algo(x, N)
% unwindowed Fourier transform algorithm
%x = pad_data(x, nextpow2(length(x)));
n = size(x,1);

X = fft(x);

randomPhases = rand(n/2-1,N)*2*pi;
symmetrizedRandomPhases = [zeros(1,N); randomPhases; zeros(1,N); ...
    -flipud(randomPhases)];
X = abs(X) .* exp(1i * symmetrizedRandomPhases );

if sum(X(2:n/2,1) ~= flipud(conj(X(n/2+2:end,1)))) > 0
    warning('non-conjugated')
end

y = ifft(X,[],1, 'symmetric'); % fragwürdig
end

function windowed_data = window_data(data)
N = size(data,1);
windowed_data = 2 * bartlett(N) .* data; % ???window without normalization???, factor of two
end