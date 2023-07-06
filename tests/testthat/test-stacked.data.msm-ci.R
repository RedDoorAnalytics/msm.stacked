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
  expect_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, conf.int = "t"))
  expect_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, conf.int = "42"))
  expect_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, conf.int = 42))
  expect_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, conf.int = as.Date("2023-04-05")))
  expect_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, alpha = "Hey"))
  expect_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, B = -10))
  expect_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, B = "Boot"))
  expect_no_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, conf.int = FALSE))
  expect_no_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, conf.int = FALSE))
  expect_no_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, conf.int = TRUE, B = 10, progress = FALSE))
  expect_no_error(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, conf.int = TRUE, B = 20, alpha = 0.1, progress = FALSE))
})

test_that("Output", {
  expect_s3_class(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, conf.int = FALSE), class = "data.frame")
  expect_s3_class(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, conf.int = TRUE, B = 10, progress = FALSE), class = "data.frame")
  expect_s3_class(object = stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, conf.int = TRUE, B = 20, alpha = 0.1, progress = FALSE), class = "data.frame")
  #
  sda1 <- stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, conf.int = FALSE)
  sda2 <- stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, conf.int = TRUE, B = 10, progress = FALSE)
  sda3 <- stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3, conf.int = TRUE, B = 20, alpha = 0.1, progress = FALSE)
  #
  expect_equal(object = sda2$p, expected = sda1$p)
  expect_equal(object = sda3$p, expected = sda1$p)
  #
  expect_false(object = identical(sda2$conf.low, sda3$conf.low))
  expect_false(object = identical(sda2$conf.high, sda3$conf.high))
})
