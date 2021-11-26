function gaussedData = tsGaussianizeData(data)

% gaussedData = tsGaussianizeData(data)
%
%   data    data vector to gaussianize
%
% Gaussianize data set: Generate normally distributed random numbers y. If
% data(i) is the n-th largest data point, reorder y such that y(i) is the
% n-th largest data point too. gaussedData is the re-ordered list of y.

if size(data,2) > 1
    data = data';
end

x = data; y = randn(length(data),1);
gaussedData = tsRankTimeSeries(x,y) * std(data) + mean(data);
end