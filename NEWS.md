# {msm.stacked} development version

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
