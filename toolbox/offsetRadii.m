function R = offsetRadii(offset, t, theta)
%OFFSETRADII Summary of this function goes here
%   Detailed explanation goes here

% Copyright (C) 2018 Stefan Reinhold -- All Rights Reserved
% You may use, distribute and modify this code under the terms of the
% AFL 3.0 license.
%
% See LICENSE for full license details.


if size(theta, 1) < size(theta, 2)
    theta = theta';
end

if size(t, 1) > size(t, 2)
    t = t';
end

a = kron(2 * cos(theta) * offset(1), t);
b = kron(2 * sin(theta) * offset(2), t);

Rsq = norm(offset)^2 - a - b;
Rsq = bsxfun(@plus, Rsq, t.^2);

R = sqrt(Rsq);

end

