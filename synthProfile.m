function [Y, S] = synthProfile(R, r, mu, sigma, g)
%SYNTHPROFILE Synthesis a profile for radii R
%   [Y, S] synthProfile(R, r, mu, sigma, g)
%   R is a MxN matrix if radii, r is the radius of the insert,
%   mu is a 1x2 row vector with mean HU values of the insert and the
%   phantom body,
%   sigma is a 1x2 row vector containing the HU standard deviations,
%   g is the scale of the PSF, use [] for unconvolved profile.
%   Returns the mean functions in Y and the standard deviation function in
%   S.

Y = mu(1) * ones(size(R));
S = zeros(size(R));


if (isempty(g))

    Y(R <= r) = mu(1);
    S(R <= r) = sigma(1);
    Y(R > r) = mu(2);
    S(R > r) = sigma(2);

else
    
    f = @(x) erf((r - x) ./ (sqrt(2) * g));
    G = @(x) 0.5 * (mu(1) + mu(2) + (mu(1) - mu(2)) * f(x));

    Y = G(R);
    S = sqrt(0.25 * (sigma(1)^2 * (1 + f(R)).^2 + sigma(2)^2 * (1 - f(R)).^2));
    
end

end

