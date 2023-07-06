# {msm.stacked} 0.0.3

### Breaking changes

- Updated algorithm to estimate confidence intervals for transition probabilities to be more consistent across time-points.
  This is based on a parametric bootstrap approach, where we use each resample along the entire time requested for prediction, with confidence intervals then calculated using the percentile method.
  The arguments of `stacked.data.msm()` have been updated accordingly, and names have been adjusted to not collide with {msm}.
  Please read the documentation page at `?stacked.data.msm()` to get familiar with the new arguments.

### Housekeeping

- Removed a URL in the vignette on confidence intervals that was giving a `403 Forbidden` error. 

# {msm.stacked} 0.0.2

### New features

- It is now possible to calculate confidence intervals for the transition probabilities returned by `stacked.data.msm()` via the `ci` argument.
  This supports all methods implemented in `msm::pmatrix.msm()`, and can be used with multi-state models with and without covariates.
- Added new vignettes describing the functionality of {msm.stacked}.
  They can be found by typing the following in your R console:
  ```r
  vignette("A-introduction", package = "msm.stacked")
  vignette("B-ci", package = "msm.stacked")
  ```

### Housekeeping

- Updated README file.
- Updated copyright year.

# {msm.stacked} 0.0.1

Initial release of the package. Currently, the following functions are included:
- `stacked.data.msm()`, to calculate transition probabilities over time from an {msm} model fit;
- `stacked.plot.msm()`, to automatically produce stacked probabilities plots based on transition probabilities over time;
- `states.msm()`, a utility function to determine the names of states for an {msm} model.
