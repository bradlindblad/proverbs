
test_that("bbe works", {

  expect_output(proverb("bbe"))

})

test_that("kjv works", {

  expect_output(proverb("kjv"))

})

test_that("web works", {

  expect_output(proverb("web"))

})

test_that("webbe works", {

  expect_output(proverb("webbe"))

})

test_that("almeida works", {

  expect_output(proverb("almeida"))

})

test_that("rccv works", {

  expect_output(proverb("rccv"))

})

test_that("give bad translation", {

  expect_error(proverb("foo"))

})
