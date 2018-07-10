function [muInsert, sigmaInsert, muBG, sigmaBG] = estimateInsertHU(Y)
%ESTIMATEINSERTHU Estimate the HU distribution (mean + sd) of the insert
%and the background given a set of radial profiles centered at the insert.
%   [muInsert, sigmaInsert, muBG, sigmaBG] = estimateInsertHU(Y)
%   The input parameter Y is a MxN matrix containing M radial profiles of
%   length N sampled from the input image, approximately centered on the
%   insert.
%   muInsert and sigmaInsert are the estimated parameters of the gaussian
%   distribution of the HU of the insert, while muBG and sigmaBG are the
%   parameters of the background HU distribution.

% Copyright (C) 2018 Stefan Reinhold -- All Rights Reserved
% You may use, distribute and modify this code under the terms of the
% AFL 3.0 license.
%
% See LICENSE for full license details.


% filter out any NaNs
y = Y(isfinite(Y));

% Initial guess for GMM
labels = kmeans(y, 3, 'Start', [200, 0, -500]');

% fit GMM to data
gmm = fitgmdist(y, 3, 'Start', labels);

% sort components in descending oder
[mu, idx] = sort(gmm.mu, 'descend');
sigma = sqrt(squeeze(gmm.Sigma));
sigma = sigma(idx);

muInsert = mu(1);
sigmaInsert = sigma(1);

muBG = mu(2);
sigmaBG = sigma(2);

end

