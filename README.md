# ResolCT
A MATLAB toolbox to estimate in-plane point spread function of QCT scans from calibration phantom inserts.

## Usage
First load your QCT scan into a MATLAB 3D-matrix. Suppose your scan resides in `image` and the resolution of the scan in stores in `resolution`.
The PSF estimation functions need two additional parameters: the insert radius `radius` and the number of inserts `N` to use for the estimation.
For example the [QRM Bone Density Calibration Phantom](http://www.qrm.de/content/products/bonedensity/bdc.htm) has three inserts with an radius of 9 mm. However, the center insert (insert 2) has a water equivalent density and since the phantom base material is equivalent to soft-tissue, the contrast between insert 2 and the phantom body is very low.
For this constellation it is safer to just use the two outermost inserts (100 mg HA/cc and 200 mg HA/cc):
```matlab
radius = 9;
N = 2;
```

### Estimatin from Single Slice

To estimate the PSF from a single slice (e.g. the center slice) of `imgage` use the `estimatePSF` function.
```matlab
centerSlice = image(:, :, floor(size(image, 3) / 2));
[sigma, centers] = estimatePSF(centerSlice, resolution, radius, N);
```
The tool will then plot the slice and let yout select the two centers of the inserts to use. Just click inside each insert. You don't have to be very precise here.
Hereafter the `estimatePSF` estimates the scale parameter `sigma` of a gaussian PSF using the two specified inserts.
The returned `centers` is a Nx2 matrix containing the optimized centers of each insert.

#### Non-interactive

The estimation process can also be run non-interactively. Just add the inserts centers as an addtional parameter to `estimatePSF`:
```matlab
[sigma, optCenters] = estimatePSF(centerSlice, resolution, radius, N, centers);
```
