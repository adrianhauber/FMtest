function rankedData = tsRankTimeSeries(x, dataToRank, randomizationStrength)

% rankedData = tsRankTimeSeries(x,dataToRank, randomize)
%
% Rank time series dataToRank such that if x(i) is the n-th largest element
% of all the x's, rankedData(i) will be the n-th largest of all the
% dataToRank's.
%
%   randomizationStrength  
%
% see also tsGaussianizeData, tsSurrogateData

% if size(x,1) ~= size(unique(x),1)
%     error('x cannot contain identical values with randomization turned off.')
% end

%if ~exist('randomize') || isempty(randomize)
%    randomize = 0;
%end
%randomizationStrength = std(x)/100;
%randomizationMatrix = randn(size(x))*randomizationStrength;
%x = x + randomizationMatrix;

rankedData = NaN(size(x));
for j = 1:size(dataToRank,2)
    [~,idx] = ismember(x(:,j), sort(x(:,j), 'descend'));
    sortedy = sort(dataToRank, 'descend');
    rankedData(:,j) = sortedy(idx);
end

end