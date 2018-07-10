function d = distanceToSynthProfile(V, t, theta, mu, sigma, r, offset, g)
%DISTANCETOSYNTHPROFILE Calculates the distance between model and data
%   d = distanceToSynthProfile(V, t, theta, mu, sigma, r, offset, g)
%   V is a row vector containing samples from an input image, t is a 
%   row vector containing the radii for each profile of V, theta is a
%   vector containing the angles of the profiles in V, mu and sigma are the
%   mean and standard deviations of the insert and the phantom body,
%   respectively. r is the radius of the insert, offset is a 2-vector
%   containing estimating offsets to the origin of the radial profiles,
%   g is the PSF scale (see synthProfile).

% Copyright (C) 2018 Stefan Reinhold -- All Rights Reserved
% You may use, distribute and modify this code under the terms of the
% AFL 3.0 license.
%
% See LICENSE for full license details.

R = offsetRadii(offset, t, theta);
[SynMu, SynSigma] = synthProfile(R, r, mu, sigma, g);

synMu = reshape(SynMu', [], 1);
synSigma = reshape(SynSigma', [], 1);

d = (V - synMu) ./ synSigma;

d(~isfinite(d)) = 0;

end

