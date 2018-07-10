function Y = sampleProfiles(img, center, radii, angles, varargin)
%SAMPLEPROFILES sampels radial profiles from the input image 
%   Y = sampleProfiles(img, center, r, theta, interpolationMethod)
%   img is a slice of the input volume,
%   center is a 2-vector containing the starting position in image
%   coordinats (pixels).
%   radii is, is a N-vector containing the radii (in pixels) for that the profiles will be 
%   generated, angles is a M-vector containing the angles (in radians) of the
%   profiles.
%   interpolationMethod is the interpolation method passed to interp2.
%   Default is 'linear'.
%   The output Y is a MxN matrix containing interpolated image gray values.
%   Each row of Y represents a profile at the corresponding angle in
%   angles.

[XI, YI] = meshgrid(1:size(img, 2), 1:size(img, 1));

Xq = kron(cos(angles)', radii) + center(1);
Yq = kron(sin(angles)', radii) + center(2);

Xq = reshape(Xq', [], 1);
Yq = reshape(Yq', [], 1);

if isempty(varargin)
    interpolationMethod = 'linear';
else
    interpolationMethod = varargin{1};
end

Y = interp2(XI, YI, img, Xq, Yq , interpolationMethod);

Y = reshape(Y, length(radii), [])';


end

