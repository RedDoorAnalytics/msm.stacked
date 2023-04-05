#' @name msm.stacked-package
#' @title Stacked Probabilities Plots and Transition Probabilities for 'msm' Multi-State Models
#' @description Create stacked probabilities plots for multi-state models fitted using
#'   the 'msm' package. Plots are created using the 'ggplot2' package, and can be
#'   further customised by the user. State transition probabilities over time can also
#'   be calculated, including conditional predictions on being in a certain state at
#'   a given time.
#' @docType package
#' @author Alessandro Gasparini (alessandro.gasparini@@reddooranalytics.se)
#' @import checkmate ggplot2 msm rlang
NULL

# Quiets concerns of R CMD check re: variable names used internally
if (getRversion() >= "2.15.1") utils::globalVariables(c("p", "tstart", "t", "to"))
