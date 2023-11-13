
test_that("bbe works", {
  testthat::skip_on_cran()
  expect_output(proverb("bbe"))

})

test_that("kjv works", {
  testthat::skip_on_cran()
  expect_output(proverb("kjv"))

})

test_that("web works", {
  testthat::skip_on_cran()
  expect_output(proverb("web"))

})

test_that("webbe works", {

  expect_output(proverb("webbe"))

})

test_that("almeida works", {
  testthat::skip_on_cran()
  expect_output(proverb("almeida"))

})

test_that("rccv works", {
  testthat::skip_on_cran()
  expect_output(proverb("rccv"))

})

test_that("give bad translation", {
  testthat::skip_on_cran()
  expect_error(proverb("foo"))

})


test_that("give bad main color", {
  testthat::skip_on_cran()
  expect_error(proverb(main_color = "breh"))

})


test_that("give bad accent color", {
  testthat::skip_on_cran()
  expect_error(proverb(accent_color = "bro"))

})
