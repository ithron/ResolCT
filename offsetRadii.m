function R = offsetRadii(offset, t, theta)
%OFFSETRADII Summary of this function goes here
%   Detailed explanation goes here

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

