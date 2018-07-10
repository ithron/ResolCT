function [sigmas, allCenters, outliers] = estimatePSFRange(img, res, radius, N, varargin)
%ESTIMATEPSFRANGE like estimatePSF for run for each slice of img
%   [sigmas, allCenters, outliers] = estimatePSFRange(img, res, radius, N)
%   sigmas is a vector containing the sigma for each slice
%   allCenters is a cell array containing the centers for each slice
%   outliers is a logical vector marking outliers of sigmas

if isempty(varargin)
    centers = zeros(N, 2);
    
    clf
    imagesc(img(:, :, floor(size(img, 3) / 2))), axis equal, colormap gray;
    
    for ii=1:N
        title(sprintf('Select center of rod %d.', ii));
        centers(ii, :) = round(ginput(1));
    end
    
else
    centers = varargin{1};
end

allCenters = cell(size(img, 3), 1);
sigmas = zeros(size(img, 3), 1);

parfor ii=1:size(img, 3)
    
    [sigmas(ii), allCenters{ii}] = estimatePSF(img(:, :, ii), res, radius, N, centers);
    
end

outliers = isoutlier(sigmas);

end

