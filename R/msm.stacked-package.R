#' @name msm.stacked-package
#' @title Stacked Probabilities Plots for 'msm' Multistate Models
#' @description Create stacked probabilities plots for multistate models fitted using
#'   the 'msm' package. Plots are created using the 'ggplot2' package, and can be
#'   further customised by the user. State occupancy probabilities over time can also
#'   be calculated, including conditional predictions on being in a certain state at
#'   a given time.
#' @docType package
#' @author Alessandro Gasparini (alessandro.gasparini@@reddooranalytics.se)
#' @import ggplot2 msm rlang
NULL

# Quiets concerns of R CMD check re: variable names used internally
if (getRversion() >= "2.15.1") utils::globalVariables(c("p", "tstart", "t", "to"))
