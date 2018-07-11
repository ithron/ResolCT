# ResolCT
A MATLAB toolbox to estimate in-plane point spread function of QCT scans from calibration phantom inserts.

## Motivation
The traditional way to measure the in-plane point spread function (PSF) of a CT is by scanning a special phantom. The resulting images are then deconvolved to obtain the PSF \[[1](#references)\]. However, doing such extra scans is tedious task and not always possible.
Luckily, in QCT a calibration phantom is simultaneously scanned with the patient. So in each QCT scan there is a phantom with known geometry that can be used for PSF estimation.

## Method
ResolCT is based on a method called *Analysis by Synthesis* (AbS). In AbS we do not analyze the image directly, but instead synthesize images from a model and find the model parameters for which the synthetic and the input image match best.
In the case of this toolbox, the model is a circular slice of an QCT calibration phantom insert.
The imaging system is approximated by a convolution with a gaussan PSF with unknown scale `sigma`. 
First radial 1D profiles of an insert in the image are sampled. Since the geometry of the inserts is known, the ideal profiles for a given `sigma` can be computed and compared to the samples from the input image. The optimal parameters are then found by minimization of the negative log likelihood function of the model parameters given the image.  

## Istallation

Clone this repository or download [ResolCT.mltbx](https://github.com/ithron/ResolCT/raw/master/ResolCT.mltbx).
Open MATLAB and double click *ResolCT.mltbx* to install the toolbox.

## Usage
First load your QCT scan into a MATLAB 3D-matrix. Suppose your scan resides in `image` and the resolution of the scan in stores in `resolution`.
The PSF estimation functions need two additional parameters: the insert radius `radius` and the number of inserts `N` to use for the estimation.
For example the [QRM Bone Density Calibration Phantom](http://www.qrm.de/content/products/bonedensity/bdc.htm) has three inserts with an radius of 9 mm. However, the center insert (insert 2) has a water equivalent density and since the phantom base material is equivalent to soft-tissue, the contrast between insert 2 and the phantom body is very low.
For this constellation it is safer to just use the two outermost inserts (100 mg HA/cc and 200 mg HA/cc):
```matlab
radius = 9;
N = 2;
```

### Estimation from Single Slice

To estimate the PSF from a single slice (e.g. the center slice) of `image` use the `estimatePSF` function.
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

### Estimation from Multiple Slices

To estimate the PSF from multiple slices use the `estimatePSFRange` function.
For example to estiamte the PSF from the complete scan use:
```matlab
[sigmas, allCenters, outliers] = estimatePSFRange(image, resolution, radius, N)
```
The function will present the same insert selection as in the single slice case.
You only have to select the insert centers for a single slice.

Then `sigmas` is an `M` vector (`M` is the number of slices in `image`) containing the estimated scale parameter for each slice separatly. `allCenters` is a `M` cell array containing the Nx2 matrices of the optimized insert centers for each slice.
Additionally the logical M-vector `outliers` is returned marking the entries of `sigmas` which have been detected as outliers.
Outliers should either be removed to compute the mean scale parameter or the estimation process should be re-run using the single slice method on the slices corresponding to outliers.

```matlab
overallSigma = mean(sigmas(~outliers));
```

#### Non-interactive
The same as for the single slice case: just add the centers for any slice as the last parameter.

## Display Results

To display the results the `displayResults` functions can be used:
```matlab
displayResults(centerSlice, resolution, radius, centers, sigma);
```
where `centers` and `sigma` are the results from `estimatePSF`.
The functions shows two figures: the first one overlays `centerSlice` with circles for each insert.
This way it is conventent to verify that the inserts were detected corretly.
The second figure plot all profiles sampled from an insert together with the mean and the 95% confidence interval of the fitted synthetic profile:
<p style="width: 100%">
<a href="https://github.com/ithron/ResolCT/raw/master/images/displayResult-1.png"><img alt="First figure of displayResults" src="https://github.com/ithron/ResolCT/raw/master/images/displayResult-1.png" width="45%" style="float: center" /></a>
<a href="https://github.com/ithron/ResolCT/raw/master/images/displayResult-2.png"><img alt="Second figure of displayResults" src="https://github.com/ithron/ResolCT/raw/master/images/displayResult-2.png" width="45%" style="float: center" /></a>
 </p>

## Lincense
You may use, distribute and modify this software under the terms of the Academic Free License 3.0 (AFL 3.0).
See [LICENSE](https://raw.githubusercontent.com/ithron/ResolCT/master/LICENSE) for full license details.

## References

\[1\]	[Ohkubo M, Wada S, Ida S, Kunii M, Kayugawa A, Matsumoto T, et al. Determination of point spread function in computed tomography accompanied with verification. Medical Physics. 2009 Jun;36(6):2089–97](https://aapm.onlinelibrary.wiley.com/doi/abs/10.1118/1.3123762)
