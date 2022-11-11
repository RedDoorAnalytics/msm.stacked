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
  deathexact = 4,
  fixedpars = TRUE # only to speed up examples!
)

test_that("Error checks", {
  #
  expect_error(object = stacked.plot.msm())
  expect_error(object = stacked.plot.msm(model = cav.msm))
  expect_error(object = stacked.plot.msm(model = cav.msm, tstart = 0))
  expect_error(object = stacked.plot.msm(model = cav.msm, tforward = 1))

  #
  expect_error(object = stacked.plot.msm(model = cav, tstart = 0, tforward = 1))
  expect_error(object = stacked.plot.msm(model = cav.msm, tstart = c(0, 1), tforward = 1))
  expect_error(object = stacked.plot.msm(model = cav.msm, tstart = 0, tforward = c(0, 1)))
  expect_error(object = stacked.plot.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 10:20))

  #
  expect_error(object = stacked.plot.msm(model = cav, msm, tstart = -1, tforward = 1))
  expect_error(object = stacked.plot.msm(model = cav, msm, tstart = 0, tforward = 0))
  expect_error(object = stacked.plot.msm(model = cav, msm, tstart = 0, tforward = 1, tseqn = -1))
  expect_error(object = stacked.plot.msm(model = cav, msm, tstart = 0, tforward = 1, tseqn = 0))
  expect_error(object = stacked.plot.msm(model = cav, msm, tstart = 0, tforward = 1, tseqn = 1))

  #
  expect_error(object = stacked.plot.msm(model = cav.msm, tstart = 0, tforward = 1, plab = 1))
  expect_error(object = stacked.plot.msm(model = cav.msm, tstart = 0, tforward = 1, plab = TRUE))
  expect_error(object = stacked.plot.msm(model = cav.msm, tstart = 0, tforward = 1, ylab = 1))
  expect_error(object = stacked.plot.msm(model = cav.msm, tstart = 0, tforward = 1, ylab = TRUE))
  expect_error(object = stacked.plot.msm(model = cav.msm, tstart = 0, tforward = 1, xlab = 1))
  expect_error(object = stacked.plot.msm(model = cav.msm, tstart = 0, tforward = 1, xlab = TRUE))
  expect_error(object = stacked.plot.msm(model = cav.msm, tstart = 0, tforward = 1, start0 = 1))
  expect_error(object = stacked.plot.msm(model = cav.msm, tstart = 0, tforward = 1, start0 = "Hey"))
})

test_that("Output", {
  spp <- stacked.plot.msm(model = cav.msm, tstart = 0, tforward = 1)

  #
  expect_s3_class(object = spp, class = "gg")
  expect_s3_class(object = spp, class = "ggplot")
  expect_s3_class(object = spp, class = c("gg", "ggplot"))
  expect_true(object = inherits(x = spp, what = "gg"))
  expect_true(object = inherits(x = spp, what = "ggplot"))
  expect_true(object = inherits(x = spp, what = c("gg", "ggplot")))
})
