function displayResults(img, res, radius, centers, sigmaG)
%DISPLAYRESULTS Visualizes the results of estimatePSF.
%   displayResults(img, resolution, radius, centers, sigmaG) visualizes the result of
%   estimatePSF using image img and radius radius. centers and sigmaG are
%   the outputs of estimatePSF.

% Copyright (C) 2018 Stefan Reinhold -- All Rights Reserved
% You may use, distribute and modify this code under the terms of the
% AFL 3.0 license.
%
% See LICENSE for full license details.

clf;
imagesc(img), axis equal, colormap gray;
hold on

angles = linspace(0, 2 * pi, 360);

xCircBase = radius / res(1) * cos(angles);
yCircBase = radius  / res(2) * sin(angles);

for ii=1:size(centers, 1)
   
xCirc = xCircBase + centers(ii, 1);
yCirc = yCircBase + centers(ii, 2);

plot(centers(ii, 1), centers(ii, 2), 'gx', xCirc, yCirc, 'g--');
    
end

hold off;

fprintf('Press any key to continue\n');
pause

minRes = min(res(1:2));
r = 0.5:1.5*radius/minRes;

Y = [];

for ii=1:size(centers, 2)
    
    subplot(size(centers, 2), 1, ii);
    
    y = sampleProfiles(img, centers(ii, :), r, angles, 'spline');
    
    mu = zeros(1, 2);
    sigma = zeros(1, 2);
    [mu(1), sigma(1), mu(2), sigma(2)] = estimateInsertHU(y);
    
    [muZ, sigmaZ] = synthProfile(r, radius/minRes, mu, sigma, sigmaG);
    
    plot(...
        r*minRes, y, '.k', ...
        r*minRes, muZ, 'm-', ...
        r*minRes, muZ - 2 * sigmaZ, '--m', ...
        r*minRes, muZ + 2 * sigmaZ, '--m', 'LineWidth', 2);
    ylim([mu(2) - 3 * sigma(2), mu(1) + 3 * sigma(1)]);
end

end

