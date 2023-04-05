# Based on example in ?msm
library(msm)
twoway4.q <- rbind(
  c(-0.5, 0.25, 0, 0.25),
  c(0.166, -0.498, 0.166, 0.166),
  c(0, 0.25, -0.5, 0.25),
  c(0, 0, 0, 0)
)
cav.msm <- msm(
  formula = state ~ years,
  subject = PTNUM,
  data = cav,
  qmatrix = twoway4.q,
  deathexact = 4
)

test_that("Error checks", {
  expect_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = "t"))
  expect_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = "42"))
  expect_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = 42))
  expect_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = TRUE))
  expect_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = as.Date("2023-04-05")))
  expect_no_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = "none"))
  expect_no_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = "norm"))
  expect_no_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = "normal"))
  expect_no_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = "normal", cl = 0.9))
})

test_that("Output", {
  expect_s3_class(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = "none"), class = "data.frame")
  expect_s3_class(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = "normal"), class = "data.frame")
  expect_s3_class(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = "normal", cl = 0.9), class = "data.frame")
  #
  sda1 <- stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = "none")
  sda2 <- stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = "normal")
  sda3 <- stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, ci = "normal", cl = 0.9)
  #
  expect_equal(object = sda2$p, expected = sda1$p)
  expect_equal(object = sda3$p, expected = sda1$p)
  #
  expect_false(object = identical(sda2$conf.low, sda3$conf.low))
  expect_false(object = identical(sda2$conf.high, sda3$conf.high))
})
