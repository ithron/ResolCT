function [sigmaG, centers] = estimatePSF(img, res, radius, N, varargin)
%ESTIMATEPSF Estimates the PSF scale parameter using calibration phantoms
%   [sigmaG, centers] = estimatePSF(img, red, radius, N)
%   Estimate the PSF scale parameter sigmaG using N inserts from a QCT
%   calibration phantom visible in the image slice img. radius denotes the
%   radius of the insert and N is the number of inserts to use for the
%   estimation.
%   Note: Only use inserts with good contrast for the estimation, e.g. do
%   not use a 'water insert' for the estimation if the phantom body is
%   equivalent to soft-tissue.
%   This function is ineractive and asks the user to specify the
%   approximate centers of the inserts.
%
%   [sigmaG, centers] = estimatePSF(img, red, radius, N, centers)
%   Additionaly specify the centers of the inserts in centers.

if isempty(varargin)
    centers = zeros(N, 2);
    
    imagesc(img), axis equal, colormap gray;
    
    for ii=1:N
        title(sprintf('Select center of rod %d.', ii));
        centers(ii, :) = round(ginput(1));
    end
    
else
    centers = varargin{1};
end

dt = 0.1 * min(res);

r = 0:dt:2*radius;
angles = linspace(0, 2*pi, 180);

muInsert = zeros(N, 1);
sigmaInsert = zeros(N, 1);
muBG = 0;
sigmaBG = 0;

profiles = zeros(length(r) * length(angles), N);

for ii=1:N
    Y = sampleProfiles(img, centers(ii, :), r/res(1), angles, 'spline');
    
    [muInsert(ii), sigmaInsert(ii), muBGi, sigmaBGi] = estimateInsertHU(Y);
    
    muBG = muBG + muBGi;
    sigmaBG = sqrt(sigmaBG^2 + sigmaBGi^2);
    
    profiles(:, ii) = reshape(Y', [], 1);
    
end

muBG = muBG / N;
sigmaBG = sigmaBG / N;

% Filter profiles
profiles(profiles < muBG - 2 * sigmaBG) = NaN;

% target function
    function ll = targetFunction(x)
        K = length(r) * length(angles);
        ll = zeros(N * K, 1);
        for jj=1:N
            c = [x(2 * (jj - 1) + 1), x(2 * jj)];
            ll((jj - 1) * K + 1:jj * K) = ...
                distanceToSynthProfile(...
                profiles(:, jj), ...
                r, ...
                angles, ...
                [muInsert(jj), muBG], ....
                [sigmaInsert(jj), sigmaBG], ...
                radius, ...
                c, ...
                abs(x(end)));
        end
    end

options = optimoptions(...
    'lsqnonlin', ...
    'Algorithm', 'trust-region-reflective', ...
    'Display','off', ...
    'MaxFunctionEvaluations', 1e12);

c0 = zeros(1, 2 * N);
LB = [repmat(-[size(img, 2), size(img, 1)], 1, N), 0];
UB = [repmat([size(img, 2), size(img, 1)], 1, N), inf];
params = lsqnonlin(@targetFunction, [c0 1], LB, UB, options);

sigmaG = params(end);

centers = reshape(params(1:end-1), 2, N)' ./ repmat([res(1), res(2)], N, 1) + [centers(:, 1), centers(:, 2)];

end

